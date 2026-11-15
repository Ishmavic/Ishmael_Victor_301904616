-- Use two psql terminals connected to the same exercise database.
-- Follow the numbered order across Session A and Session B.

-- 2. Session B: also read 1 before A writes.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003;

-- 4. Session B: write its stale value. The final count is 2, so one increment is lost.
UPDATE portfolio."inventory_lot" SET "p3_processed_count" = 2 WHERE "lot_id" IS NOT DISTINCT FROM 1003 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003;

-- 7. Session B: request the same row lock. This statement waits.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003 FOR UPDATE;

-- 9. Session B: its SELECT now returns 2. Apply the second increment and commit.
UPDATE portfolio."inventory_lot" SET "p3_processed_count" = 3 WHERE "lot_id" IS NOT DISTINCT FROM 1003 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003;
