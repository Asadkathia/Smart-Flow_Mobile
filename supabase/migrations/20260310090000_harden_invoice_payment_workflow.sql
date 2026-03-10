-- Harden invoice/payment workflow:
-- 1) Prevent multiple finalized invoices per visit/job lifecycle
-- 2) Allow technicians assigned to a visit to record payments
-- 3) Enforce payment validity and auto-sync invoice status from payments

-- =====================================================
-- Payments RLS: technicians can record payments on assigned visits
-- =====================================================
DROP POLICY IF EXISTS "Technicians can record payments" ON payments;

CREATE POLICY "Technicians can record payments"
ON payments FOR INSERT
TO authenticated
WITH CHECK (
  org_id = get_user_org_id()
  AND received_by = auth.uid()
  AND EXISTS (
    SELECT 1
    FROM invoices i
    JOIN visits v ON v.id = i.visit_id
    WHERE i.id = payments.invoice_id
      AND i.org_id = get_user_org_id()
      AND i.status IN ('unpaid', 'partially_paid')
      AND v.technician_id = auth.uid()
  )
);

-- =====================================================
-- Invoices: enforce single finalized invoice per visit
-- =====================================================
CREATE OR REPLACE FUNCTION public.enforce_single_finalized_invoice_per_visit()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.status IN ('unpaid', 'partially_paid', 'paid')
     AND (
       TG_OP = 'INSERT'
       OR OLD.status = 'draft'
     ) THEN
    IF EXISTS (
      SELECT 1
      FROM invoices i
      WHERE i.visit_id = NEW.visit_id
        AND i.id <> NEW.id
        AND i.status IN ('unpaid', 'partially_paid', 'paid')
    ) THEN
      RAISE EXCEPTION 'A finalized invoice already exists for this visit.'
        USING ERRCODE = '23505';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_enforce_single_finalized_invoice_per_visit ON invoices;
CREATE TRIGGER trg_enforce_single_finalized_invoice_per_visit
BEFORE INSERT OR UPDATE OF status, visit_id ON invoices
FOR EACH ROW
EXECUTE FUNCTION public.enforce_single_finalized_invoice_per_visit();

CREATE INDEX IF NOT EXISTS idx_invoices_visit_id_status
ON invoices(visit_id, status);

-- =====================================================
-- Payments: validate amount/invoice state before write
-- =====================================================
CREATE OR REPLACE FUNCTION public.validate_payment_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invoice_total NUMERIC;
  v_invoice_status invoice_status;
  v_invoice_org UUID;
  v_already_paid NUMERIC;
BEGIN
  SELECT i.total, i.status, i.org_id
  INTO v_invoice_total, v_invoice_status, v_invoice_org
  FROM invoices i
  WHERE i.id = NEW.invoice_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invoice not found for payment.' USING ERRCODE = '23503';
  END IF;

  IF NEW.org_id <> v_invoice_org THEN
    RAISE EXCEPTION 'Payment org_id must match invoice org_id.' USING ERRCODE = '23514';
  END IF;

  IF v_invoice_status NOT IN ('unpaid', 'partially_paid') THEN
    RAISE EXCEPTION 'Payments can only be recorded for unpaid or partially_paid invoices.'
      USING ERRCODE = '23514';
  END IF;

  IF NEW.amount <= 0 THEN
    RAISE EXCEPTION 'Payment amount must be greater than zero.' USING ERRCODE = '23514';
  END IF;

  SELECT COALESCE(SUM(p.amount), 0)
  INTO v_already_paid
  FROM payments p
  WHERE p.invoice_id = NEW.invoice_id
    AND (TG_OP <> 'UPDATE' OR p.id <> NEW.id);

  IF v_already_paid + NEW.amount > v_invoice_total + 0.000001 THEN
    RAISE EXCEPTION 'Payment exceeds remaining invoice balance.' USING ERRCODE = '23514';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validate_payment_write ON payments;
CREATE TRIGGER trg_validate_payment_write
BEFORE INSERT OR UPDATE OF amount, invoice_id, org_id ON payments
FOR EACH ROW
EXECUTE FUNCTION public.validate_payment_write();

-- =====================================================
-- Payments: auto-update invoice status after payment changes
-- =====================================================
CREATE OR REPLACE FUNCTION public.sync_invoice_status_from_payments()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invoice_id UUID;
  v_total_paid NUMERIC;
  v_invoice_total NUMERIC;
  v_new_status invoice_status;
BEGIN
  v_invoice_id := COALESCE(NEW.invoice_id, OLD.invoice_id);

  SELECT i.total
  INTO v_invoice_total
  FROM invoices i
  WHERE i.id = v_invoice_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT COALESCE(SUM(p.amount), 0)
  INTO v_total_paid
  FROM payments p
  WHERE p.invoice_id = v_invoice_id;

  IF v_total_paid >= v_invoice_total - 0.000001 THEN
    v_new_status := 'paid';
  ELSIF v_total_paid > 0 THEN
    v_new_status := 'partially_paid';
  ELSE
    v_new_status := 'unpaid';
  END IF;

  UPDATE invoices
  SET status = v_new_status,
      paid_at = CASE
        WHEN v_new_status = 'paid' THEN COALESCE(paid_at, now())
        ELSE NULL
      END,
      updated_at = now()
  WHERE id = v_invoice_id
    AND status IN ('unpaid', 'partially_paid', 'paid');

  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_invoice_status_from_payments ON payments;
CREATE TRIGGER trg_sync_invoice_status_from_payments
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW
EXECUTE FUNCTION public.sync_invoice_status_from_payments();
