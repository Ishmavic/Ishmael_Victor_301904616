# Smart Medical Inventory and Emergency Supply Management System — SQL queries

## 1. Show related stock_movement, inventory_lot, medicine records (up to 20).

```sql
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
```

| stock_movement_movement_id | stock_movement_occurred_at | inventory_lot_lot_id | inventory_lot_received_date | medicine_medicine_id | medicine_sku_code |
| --- | --- | --- | --- | --- | --- |
| 1004 | 2026-10-02T09:30:00+00:00 | 1003 | 2026-10-01 | 1001 | SYN-MED-001 |

## 2. Find inventory_lot records where expiry_date matches "2028-10-01" (up to 20).

```sql
SELECT * FROM portfolio."inventory_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2028-10-01'
ORDER BY "lot_id"
LIMIT 20;
```

| lot_id | medicine_id | supplier_id | received_date | expiry_date | quantity_on_hand | unit_cost |
| --- | --- | --- | --- | --- | --- | --- |
| 1003 | 1001 | 1002 | 2026-10-01 | 2028-10-01 | 80 | 2.5 |

## 3. Count stock_movement records for each lot_id (up to 20 groups).

```sql
SELECT "lot_id", count(*) AS record_count
FROM portfolio."stock_movement"
GROUP BY "lot_id"
ORDER BY record_count DESC, "lot_id" NULLS LAST
LIMIT 20;
```

| lot_id | record_count |
| --- | --- |
| 1003 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.42 | 2.599, 2.42, 2.298 | Sort → Seq Scan | 274 |
| After index | 0.294 | 0.294, 0.289, 0.458 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.42 ms to 0.294 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.565..2.568 rows=50 loops=1)
  Seq Scan on inventory_lot (actual time=0.017..2.518 rows=50 loops=1)
Planning Time: 0.345 ms
Execution Time: 2.599 ms
```

### Before index, run 2

```text
Sort (actual time=2.385..2.388 rows=50 loops=1)
  Seq Scan on inventory_lot (actual time=0.015..2.342 rows=50 loops=1)
Planning Time: 0.335 ms
Execution Time: 2.42 ms
```

### Before index, run 3

```text
Sort (actual time=2.267..2.27 rows=50 loops=1)
  Seq Scan on inventory_lot (actual time=0.015..2.224 rows=50 loops=1)
Planning Time: 0.338 ms
Execution Time: 2.298 ms
```

### After index, run 1

```text
Sort (actual time=0.237..0.24 rows=50 loops=1)
  Bitmap Heap Scan on inventory_lot (actual time=0.029..0.194 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=50 loops=1)
Planning Time: 0.633 ms
Execution Time: 0.294 ms
```

### After index, run 2

```text
Sort (actual time=0.234..0.236 rows=50 loops=1)
  Bitmap Heap Scan on inventory_lot (actual time=0.029..0.194 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=50 loops=1)
Planning Time: 0.578 ms
Execution Time: 0.289 ms
```

### After index, run 3

```text
Sort (actual time=0.36..0.363 rows=50 loops=1)
  Bitmap Heap Scan on inventory_lot (actual time=0.042..0.293 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.02..0.02 rows=50 loops=1)
Planning Time: 1.012 ms
Execution Time: 0.458 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ishmael_Victor_301904616_P2_Queries.sql, then Ishmael_Victor_301904616_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ishmael_Victor_301904616_P2_QueryResults.png) · [Index comparison](screenshots/Ishmael_Victor_301904616_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

