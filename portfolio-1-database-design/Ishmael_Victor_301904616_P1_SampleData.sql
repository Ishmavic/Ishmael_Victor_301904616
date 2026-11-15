-- Fictional sample records for Smart Medical Inventory and Emergency Supply Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."medicine" ("medicine_id", "sku_code", "name", "category", "requires_cold_storage", "reorder_level") VALUES (1001, 'SYN-MED-001', 'Synthetic saline solution', 'Fluid', FALSE, 20);
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email") VALUES (1002, 'Example Medical Supply', 'supply@example.test');
INSERT INTO portfolio."inventory_lot" ("lot_id", "medicine_id", "supplier_id", "received_date", "expiry_date", "quantity_on_hand", "unit_cost") VALUES (1003, 1001, 1002, '2026-10-01', '2028-10-01', 80, 2.5);
INSERT INTO portfolio."stock_movement" ("movement_id", "lot_id", "occurred_at", "movement_type", "quantity_delta") VALUES (1004, 1003, '2026-10-02T09:30:00Z', 'receipt', 80);
COMMIT;
