// Edge Function: AI Inventory Item Detection
// Endpoint: POST /v1/tech/inventory/items/ai-detect
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
    const { image_url, image_base64, hint } = body

    if (!image_url && !image_base64) {
      throw new Error('Image URL or base64 image is required')
    }

    const supabase = getSupabaseClient()

    // Get OpenAI API key from secrets
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      throw new Error('OpenAI API key not configured')
    }

    // Get historical pricing data for context (optional)
    const { data: recentItems } = await supabase
      .from('inventory_items')
      .select('name, sale_price, unit, category')
      .eq('org_id', auth.orgId)
      .eq('active', true)
      .order('created_at', { ascending: false })
      .limit(20)

    const historicalContext = recentItems && recentItems.length > 0
      ? `\n\nHistorical pricing context from this organization:\n${recentItems.map(item => `- ${item.name}: $${item.sale_price} per ${item.unit}`).join('\n')}`
      : ''

    // Build prompt for structured detection
    const detectionPrompt = `Analyze this inventory item image and provide a structured JSON response with the following fields:
- name: The item name (e.g., "PVC 1/2 inch elbow", "HVAC Filter 16x25x1")
- category: Item category (e.g., "plumbing", "electrical", "hvac", "hardware")
- unit: Unit of measurement (e.g., "each", "ft", "lb", "sq ft", "gal")
- suggested_price: Estimated price in USD (based on visual characteristics, brand if visible, and market pricing)
- sku: SKU or product code if visible in image (barcode, label, etc.)
- confidence: Confidence score 0-1 for the detection
- notes: Any additional observations (brand, size, condition, etc.)

${hint ? `\nHint from technician: ${hint}` : ''}
${historicalContext}

Return ONLY valid JSON in this exact format:
{
  "name": "string",
  "category": "string",
  "unit": "string",
  "suggested_price": number,
  "sku": "string or null",
  "confidence": number,
  "notes": "string"
}`

    // Build messages for OpenAI
    const messages: any[] = [
      {
        role: 'system',
        content: 'You are an expert at identifying inventory items from images. Analyze the image carefully and provide accurate, structured JSON responses. Focus on identifying the item type, inferring appropriate units, and estimating realistic market prices.',
      },
      {
        role: 'user',
        content: [
          {
            type: 'text',
            text: detectionPrompt,
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
        max_tokens: 500,
        temperature: 0.3, // Lower temperature for more consistent structured output
        response_format: { type: 'json_object' }, // Force JSON response
      }),
    })

    if (!openaiResponse.ok) {
      const errorData = await openaiResponse.json().catch(() => ({}))
      throw new Error(`OpenAI API error: ${errorData.error?.message || openaiResponse.statusText}`)
    }

    const openaiData = await openaiResponse.json()
    const responseText = openaiData.choices[0]?.message?.content || '{}'
    
    // Parse JSON response
    let detectionResult: any
    try {
      detectionResult = JSON.parse(responseText)
    } catch (parseError) {
      // Try to extract JSON from markdown code blocks if present
      const jsonMatch = responseText.match(/```json\s*([\s\S]*?)\s*```/) || responseText.match(/```\s*([\s\S]*?)\s*```/)
      if (jsonMatch) {
        detectionResult = JSON.parse(jsonMatch[1])
      } else {
        throw new Error('Failed to parse AI response as JSON')
      }
    }

    // Validate and normalize response
    const validatedResult = {
      name: detectionResult.name || 'Unknown Item',
      category: detectionResult.category || 'general',
      unit: detectionResult.unit || 'each',
      suggested_price: Math.max(0, parseFloat(detectionResult.suggested_price) || 0),
      sku: detectionResult.sku || null,
      confidence: Math.min(1, Math.max(0, parseFloat(detectionResult.confidence) || 0.5)),
      notes: detectionResult.notes || '',
    }

    const tokensIn = openaiData.usage?.prompt_tokens || 0
    const tokensOut = openaiData.usage?.completion_tokens || 0

    // Log AI interaction
    await supabase.from('ai_interaction_logs').insert({
      org_id: auth.orgId,
      technician_id: auth.userId,
      visit_id: null,
      prompt: `Inventory item detection${hint ? ` (hint: ${hint})` : ''}`,
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
