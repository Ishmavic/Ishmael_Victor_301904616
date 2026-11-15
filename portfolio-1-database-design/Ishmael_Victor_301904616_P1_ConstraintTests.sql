-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject medicine primary key. Expected: pk_medicine, SQLSTATE 23505.
INSERT INTO portfolio."medicine" ("medicine_id", "sku_code", "name", "category", "requires_cold_storage", "reorder_level")
VALUES (1001, 'SYN-MED-101', 'Synthetic gauze', 'Dressing', FALSE, 10);

-- 2. reject medicine unique sku. Expected: uq_medicine_0, SQLSTATE 23505.
INSERT INTO portfolio."medicine" ("medicine_id", "sku_code", "name", "category", "requires_cold_storage", "reorder_level")
VALUES (6001, 'SYN-MED-001', 'Synthetic gauze', 'Dressing', FALSE, 10);

-- 3. reject medicine not null name. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."medicine" ("medicine_id", "sku_code", "name", "category", "requires_cold_storage", "reorder_level")
VALUES (6002, 'SYN-MED-102', NULL, 'Dressing', FALSE, 10);

-- 4. reject supplier primary key. Expected: pk_supplier, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email")
VALUES (1002, 'Example Medical Supply Two', 'supply-two@example.test');

-- 5. reject supplier unique email. Expected: uq_supplier_0, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email")
VALUES (6003, 'Example Medical Supply Two', 'supply@example.test');

-- 6. reject lot primary key. Expected: pk_inventory_lot, SQLSTATE 23505.
INSERT INTO portfolio."inventory_lot" ("lot_id", "medicine_id", "supplier_id", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (1003, 1001, 1002, '2026-10-03', '2028-10-03', 10, 3.25);

-- 7. reject lot medicine fk. Expected: fk_inventory_lot_0, SQLSTATE 23503.
INSERT INTO portfolio."inventory_lot" ("lot_id", "medicine_id", "supplier_id", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (6004, 9901, 1002, '2026-10-03', '2028-10-03', 10, 3.25);

-- 8. reject lot supplier fk. Expected: fk_inventory_lot_1, SQLSTATE 23503.
INSERT INTO portfolio."inventory_lot" ("lot_id", "medicine_id", "supplier_id", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (6005, 1001, 9902, '2026-10-03', '2028-10-03', 10, 3.25);

-- 9. reject lot negative quantity. Expected: lot_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."inventory_lot" ("lot_id", "medicine_id", "supplier_id", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (6006, 1001, 1002, '2026-10-03', '2028-10-03', -1, 3.25);

-- 10. reject movement primary key. Expected: pk_stock_movement, SQLSTATE 23505.
INSERT INTO portfolio."stock_movement" ("movement_id", "lot_id", "occurred_at", "movement_type", "quantity_delta")
VALUES (1004, 1003, '2026-10-04T10:00:00Z', 'issue', -1);

-- 11. reject movement lot fk. Expected: fk_stock_movement_0, SQLSTATE 23503.
INSERT INTO portfolio."stock_movement" ("movement_id", "lot_id", "occurred_at", "movement_type", "quantity_delta")
VALUES (6007, 9903, '2026-10-04T10:00:00Z', 'issue', -1);

-- 12. reject movement zero quantity. Expected: movement_nonzero, SQLSTATE 23514.
INSERT INTO portfolio."stock_movement" ("movement_id", "lot_id", "occurred_at", "movement_type", "quantity_delta")
VALUES (6008, 1003, '2026-10-04T10:00:00Z', 'adjustment', 0);
