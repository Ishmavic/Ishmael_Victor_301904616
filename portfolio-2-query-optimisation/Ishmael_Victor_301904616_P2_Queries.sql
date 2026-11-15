-- Show related stock_movement, inventory_lot, medicine records (up to 20).
SELECT t0."movement_id" AS "stock_movement_movement_id",
       t0."occurred_at" AS "stock_movement_occurred_at",
       t1."lot_id" AS "inventory_lot_lot_id",
       t1."received_date" AS "inventory_lot_received_date",
       t2."medicine_id" AS "medicine_medicine_id",
       t2."sku_code" AS "medicine_sku_code"
FROM portfolio."stock_movement" t0
JOIN portfolio."inventory_lot" t1 ON t0."lot_id" = t1."lot_id"
JOIN portfolio."medicine" t2 ON t1."medicine_id" = t2."medicine_id"
ORDER BY t0."movement_id", t1."lot_id", t2."medicine_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."movement_id" AS "stock_movement_movement_id",
       t0."occurred_at" AS "stock_movement_occurred_at",
       t1."lot_id" AS "inventory_lot_lot_id",
       t1."received_date" AS "inventory_lot_received_date",
       t2."medicine_id" AS "medicine_medicine_id",
       t2."sku_code" AS "medicine_sku_code"
FROM portfolio."stock_movement" t0
JOIN portfolio."inventory_lot" t1 ON t0."lot_id" = t1."lot_id"
JOIN portfolio."medicine" t2 ON t1."medicine_id" = t2."medicine_id"
ORDER BY t0."movement_id", t1."lot_id", t2."medicine_id"
LIMIT 20;

-- Find inventory_lot records where expiry_date matches "2028-10-01" (up to 20).
SELECT * FROM portfolio."inventory_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2028-10-01'
ORDER BY "lot_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."inventory_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2028-10-01'
ORDER BY "lot_id"
LIMIT 20;

-- Count stock_movement records for each lot_id (up to 20 groups).
SELECT "lot_id", count(*) AS record_count
FROM portfolio."stock_movement"
GROUP BY "lot_id"
ORDER BY record_count DESC, "lot_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "lot_id", count(*) AS record_count
FROM portfolio."stock_movement"
GROUP BY "lot_id"
ORDER BY record_count DESC, "lot_id" NULLS LAST
LIMIT 20;
