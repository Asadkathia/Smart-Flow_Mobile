// Edge Function: AI Inventory Price Suggestion
// Endpoint: POST /v1/tech/inventory/items/ai-price
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
      image_url, 
      image_base64, 
      item_name, 
      unit,
      item_id, // Optional: if updating existing item
    } = body

    if (!image_url && !image_base64) {
      throw new Error('Image URL or base64 image is required')
    }

    if (!item_name) {
      throw new Error('Item name is required for price suggestion')
    }

    const supabase = getSupabaseClient()

    // Get OpenAI API key from secrets
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      throw new Error('OpenAI API key not configured')
    }

    // Get historical pricing data for similar items
    const { data: similarItems } = await supabase
      .from('inventory_items')
      .select('name, sale_price, unit')
      .eq('org_id', auth.orgId)
      .eq('active', true)
      .ilike('name', `%${item_name.split(' ')[0]}%`) // Find similar items
      .order('created_at', { ascending: false })
      .limit(10)

    const historicalContext = similarItems && similarItems.length > 0
      ? `\n\nSimilar items in this organization:\n${similarItems.map(item => `- ${item.name}: $${item.sale_price} per ${item.unit}`).join('\n')}`
      : ''

    // Build prompt for price suggestion
    const pricePrompt = `Analyze this inventory item image and suggest an appropriate sale price.

Item Details:
- Name: ${item_name}
- Unit: ${unit || 'each'}
${historicalContext}

Consider:
- Visual characteristics (size, brand if visible, condition)
- Market pricing for similar items
- Historical pricing in this organization
- Item category and typical price range

Return ONLY valid JSON in this exact format:
{
  "suggested_price": number,
  "confidence": number (0-1),
  "reasoning": "brief explanation of price suggestion",
  "price_range": {
    "min": number,
    "max": number
  }
}`

    // Build messages for OpenAI
    const messages: any[] = [
      {
        role: 'system',
        content: 'You are an expert at estimating prices for inventory items based on visual analysis. Provide realistic, market-based price suggestions.',
      },
      {
        role: 'user',
        content: [
          {
            type: 'text',
            text: pricePrompt,
          },
          {
            type: 'image_url',
            image_url: {
              url: image_url || `data:image/jpeg;base64,${image_base64}`,
            },
          },
        ],
      },
    ]

    // Call OpenAI API with GPT-4o (best for vision)
    const openaiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openaiApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4o',
        messages: messages,
        max_tokens: 300,
        temperature: 0.3,
        response_format: { type: 'json_object' },
      }),
    })

    if (!openaiResponse.ok) {
      const errorData = await openaiResponse.json().catch(() => ({}))
      throw new Error(`OpenAI API error: ${errorData.error?.message || openaiResponse.statusText}`)
    }

    const openaiData = await openaiResponse.json()
    const responseText = openaiData.choices[0]?.message?.content || '{}'
    
    // Parse JSON response
    let priceResult: any
    try {
      priceResult = JSON.parse(responseText)
    } catch (parseError) {
      const jsonMatch = responseText.match(/```json\s*([\s\S]*?)\s*```/) || responseText.match(/```\s*([\s\S]*?)\s*```/)
      if (jsonMatch) {
        priceResult = JSON.parse(jsonMatch[1])
      } else {
        throw new Error('Failed to parse AI response as JSON')
      }
    }

    // Validate and normalize response
    const validatedResult = {
      suggested_price: Math.max(0, parseFloat(priceResult.suggested_price) || 0),
      confidence: Math.min(1, Math.max(0, parseFloat(priceResult.confidence) || 0.5)),
      reasoning: priceResult.reasoning || 'Price estimated based on visual analysis',
      price_range: {
        min: Math.max(0, parseFloat(priceResult.price_range?.min) || priceResult.suggested_price * 0.8),
        max: parseFloat(priceResult.price_range?.max) || priceResult.suggested_price * 1.2,
      },
    }

    const tokensIn = openaiData.usage?.prompt_tokens || 0
    const tokensOut = openaiData.usage?.completion_tokens || 0

    // Update item's ai_suggested_price if item_id provided
    if (item_id) {
      await supabase
        .from('inventory_items')
        .update({ ai_suggested_price: validatedResult.suggested_price })
        .eq('id', item_id)
        .eq('org_id', auth.orgId)
    }

    // Log AI interaction
    await supabase.from('ai_interaction_logs').insert({
      org_id: auth.orgId,
      technician_id: auth.userId,
      visit_id: null,
      prompt: `Price suggestion for: ${item_name}`,
      response: JSON.stringify(validatedResult),
      model: 'openai-gpt-4o',
      tokens_in: tokensIn,
      tokens_out: tokensOut,
    })

    return createSuccessResponse({
      ...validatedResult,
      tokens_used: tokensIn + tokensOut,
      provider: 'openai',
    })
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
