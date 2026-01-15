// Edge Function: List/Create Inventory Items
// Endpoint: GET/POST /v1/tech/inventory/items
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    const supabase = getSupabaseClient()

    if (req.method === 'GET') {
      // List inventory items for the organization
      const { data: items, error } = await supabase
        .from('inventory_items')
        .select('*')
        .eq('org_id', auth.orgId)
        .eq('active', true)
        .order('name', { ascending: true })

      if (error) throw error

      return createSuccessResponse(items || [])
    }

    if (req.method === 'POST') {
      // Create new inventory item
      const body = await req.json()
      const {
        name,
        sku,
        unit,
        sale_price,
        taxable_default = true,
        image_path,
        ai_suggested_price,
      } = body

      if (!name || !unit || sale_price === undefined) {
        throw new Error('name, unit, and sale_price are required')
      }

      // Validate sale_price
      if (sale_price < 0) {
        throw new Error('sale_price must be >= 0')
      }

      const { data: item, error: createError } = await supabase
        .from('inventory_items')
        .insert({
          org_id: auth.orgId,
          name,
          sku: sku || null,
          unit,
          sale_price,
          taxable_default,
          active: true,
          image_path: image_path || null,
          ai_suggested_price: ai_suggested_price || null,
          created_by: auth.userId,
        })
        .select()
        .single()

      if (createError || !item) {
        throw new Error(`Failed to create inventory item: ${createError?.message}`)
      }

      // Log audit entry
      await supabase.from('audit_logs').insert({
        org_id: auth.orgId,
        entity: 'inventory_item',
        entity_id: item.id,
        action: 'create',
        performed_by: auth.userId,
        payload: {
          name,
          sku: sku || null,
          sale_price,
        },
      })

      return createSuccessResponse(item, 201)
    }

    throw new Error('Method not allowed')
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
