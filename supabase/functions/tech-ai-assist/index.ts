// Edge Function: AI Assistant (OpenAI with Job Context)
// Endpoint: POST /v1/tech/ai/assist
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    if (req.method !== 'POST') {
      throw new Error('Method not allowed')
    }

    const body = await req.json()
    const { 
      prompt, 
      visit_id, 
      image_url, 
      image_base64,
      model, // Optional: override model selection
      require_web_search = false, // Optional: request web search
    } = body

    if (!prompt || prompt.trim().length === 0) {
      throw new Error('Prompt is required')
    }

    const supabase = getSupabaseClient()

    // Get OpenAI API key from secrets
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      throw new Error('OpenAI API key not configured')
    }

    // Use gpt-4o-mini as default model for all requests (text and image)
    const hasImage = !!(image_url || image_base64)
    const selectedModel = model || 'gpt-4o-mini'

    // Build context from visit/job if visit_id provided
    let visitContext = ''
    if (visit_id) {
      const { data: visit, error: visitError } = await supabase
        .from('visits')
        .select(`
          *,
          job:jobs!inner (
            *,
            customer:customers!inner (
              name,
              phone,
              email
            ),
            property:properties (
              address,
              latitude,
              longitude
            )
          )
        `)
        .eq('id', visit_id)
        .eq('technician_id', auth.userId)
        .single()

      if (!visitError && visit) {
        // Get recent notes for context
        const { data: notes } = await supabase
          .from('notes')
          .select('body, created_at')
          .eq('visit_id', visit_id)
          .order('created_at', { ascending: false })
          .limit(5)

        visitContext = `
Current Job Context:
- Job Number: ${visit.job?.job_number || 'N/A'}
- Service Type: ${visit.job?.service_type || 'N/A'}
- Priority: ${visit.job?.priority || 'N/A'}
- Customer: ${visit.job?.customer?.name || 'N/A'}
- Property Address: ${visit.job?.property?.address || 'N/A'}
- Visit Status: ${visit.status}
- Scheduled: ${new Date(visit.scheduled_start).toLocaleString()}
${notes && notes.length > 0 ? `\nRecent Notes:\n${notes.map(n => `- ${n.body} (${new Date(n.created_at).toLocaleString()})`).join('\n')}` : ''}
`
      }
    }

    // Build messages array
    const messages: any[] = [
      {
        role: 'system',
        content: `You are a helpful assistant for field service technicians. Provide clear, concise, and actionable advice based on the job context provided.${visitContext ? '\n\nYou have access to the current job information above.' : ''}`,
      },
    ]

    // Build user message with optional image
    const userMessage: any = {
      role: 'user',
      content: [],
    }

    // Add text prompt with context
    const fullPrompt = visitContext 
      ? `${visitContext}\n\nTechnician Question: ${prompt}`
      : prompt

    userMessage.content.push({
      type: 'text',
      text: fullPrompt,
    })

    // Add image if provided
    if (image_url) {
      userMessage.content.push({
        type: 'image_url',
        image_url: { url: image_url },
      })
    } else if (image_base64) {
      userMessage.content.push({
        type: 'image_url',
        image_url: { url: `data:image/jpeg;base64,${image_base64}` },
      })
    }

    messages.push(userMessage)

    // Perform web search if requested (optional feature)
    let webSearchResults = ''
    if (require_web_search) {
      try {
        // Call web search function (if implemented)
        const searchResponse = await fetch(
          `${Deno.env.get('SUPABASE_URL')}/functions/v1/tech-ai-web-search`,
          {
            method: 'POST',
            headers: {
              'Authorization': req.headers.get('Authorization') || '',
              'X-Channel': 'mobile_technician',
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ query: prompt }),
          }
        )

        if (searchResponse.ok) {
          const searchData = await searchResponse.json()
          if (searchData.data?.results) {
            webSearchResults = `\n\nWeb Search Results:\n${searchData.data.results.map((r: any) => `- ${r.title}: ${r.snippet} (${r.url})`).join('\n')}`
            userMessage.content[0].text += webSearchResults
          }
        }
      } catch (searchError) {
        // Web search failed, continue without it
        console.error('Web search error:', searchError)
      }
    }

    // Call OpenAI API
    const openaiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openaiApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: selectedModel,
        messages: messages,
        max_tokens: 1500,
        temperature: 0.7,
      }),
    })

    if (!openaiResponse.ok) {
      const errorData = await openaiResponse.json().catch(() => ({}))
      throw new Error(`OpenAI API error: ${errorData.error?.message || openaiResponse.statusText}`)
    }

    const openaiData = await openaiResponse.json()
    const responseText = openaiData.choices[0]?.message?.content || 'No response generated'
    const tokensIn = openaiData.usage?.prompt_tokens || 0
    const tokensOut = openaiData.usage?.completion_tokens || 0

    // Calculate cost estimate
    const costEstimate = calculateCostEstimate(selectedModel, tokensIn, tokensOut)

    // Log AI interaction
    await supabase.from('ai_interaction_logs').insert({
      org_id: auth.orgId,
      technician_id: auth.userId,
      visit_id: visit_id || null,
      prompt: fullPrompt,
      response: responseText,
      model: `openai-${selectedModel}`,
      tokens_in: tokensIn,
      tokens_out: tokensOut,
    })

    return createSuccessResponse({
      response: responseText,
      model: `openai-${selectedModel}`,
      tokens_used: tokensIn + tokensOut,
      cost_estimate: costEstimate,
      provider: 'openai',
      has_context: !!visitContext,
      has_image: hasImage,
    })
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})

// Helper function to estimate cost
function calculateCostEstimate(model: string, tokensIn: number, tokensOut: number): number {
  const pricing: Record<string, { input: number; output: number }> = {
    'gpt-4o-mini': { input: 0.15, output: 0.60 },
    'gpt-4o': { input: 2.50, output: 10.00 },
    'gpt-4-turbo': { input: 10.00, output: 30.00 },
    'gpt-3.5-turbo': { input: 0.50, output: 1.50 },
  }

  const price = pricing[model] || pricing['gpt-4o-mini']
  const cost = (tokensIn / 1_000_000) * price.input + (tokensOut / 1_000_000) * price.output
  return Math.round(cost * 10000) / 10000 // Round to 4 decimal places
}
