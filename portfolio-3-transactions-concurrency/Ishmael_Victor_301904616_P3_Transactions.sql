-- This helper counter exists only in the temporary transaction exercise.
-- Original case columns and constraints are preserved. It is not part of the P1 design.
ALTER TABLE portfolio."inventory_lot" ADD COLUMN "p3_processed_count" integer NOT NULL DEFAULT 0;
ALTER TABLE portfolio."inventory_lot" ADD CONSTRAINT "p3_count_nonnegative" CHECK ("p3_processed_count" >= 0);

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."inventory_lot" SET "p3_processed_count" = "p3_processed_count" + 1 WHERE "lot_id" IS NOT DISTINCT FROM 1003 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003;

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."inventory_lot" SET "p3_processed_count" = "p3_processed_count" + 10 WHERE "lot_id" IS NOT DISTINCT FROM 1003 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A negative counter deliberately fails its CHECK. Keep psql open so ROLLBACK can run.
\set ON_ERROR_STOP off
\set VERBOSITY verbose
UPDATE portfolio."inventory_lot" SET "p3_processed_count" = -1 WHERE "lot_id" IS NOT DISTINCT FROM 1003 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A failed transaction rejects another statement until it is rolled back.
SELECT 1;
ROLLBACK;
\set ON_ERROR_STOP on
SELECT "lot_id", "p3_processed_count" FROM portfolio."inventory_lot" WHERE "lot_id" IS NOT DISTINCT FROM 1003;
