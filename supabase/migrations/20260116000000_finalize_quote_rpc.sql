-- Helper Function: Finalize Quote (Bypass RLS)
-- Allows technicians to finalize quotes securely
-- ============================================

CREATE OR REPLACE FUNCTION finalize_quote(quote_id UUID)
RETURNS JSONB AS $$
DECLARE
    v_quote quotes%ROWTYPE;
BEGIN
    -- Check if quote exists
    SELECT * INTO v_quote FROM quotes WHERE id = quote_id;
    
    IF v_quote IS NULL THEN
        RAISE EXCEPTION 'Quote not found';
    END IF;
    
    -- Check if status is draft
    IF v_quote.status != 'draft' THEN
        RAISE EXCEPTION 'Only draft quotes can be finalized. Current status: %', v_quote.status;
    END IF;

    -- Update status
    UPDATE quotes 
    SET status = 'finalized', 
        locked_at = now(),
        updated_at = now()
    WHERE id = quote_id
    RETURNING * INTO v_quote;
    
    -- Return the updated quote as JSON
    RETURN to_jsonb(v_quote);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
