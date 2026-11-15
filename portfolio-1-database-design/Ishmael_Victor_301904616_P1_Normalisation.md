# Smart Medical Inventory and Emergency Supply Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| medicine_id | inventory_lot records (list) |
| --- | --- |
| 1001 | [1003] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| inventory_lot.lot_id | inventory_lot.medicine_id | inventory_lot.supplier_id | medicine.medicine_id | medicine.sku_code | supplier.supplier_id | supplier.supplier_name |
| --- | --- | --- | --- | --- | --- | --- |
| 1003 | 1001 | 1002 | 1001 | SYN-MED-001 | 1002 | Example Medical Supply |

Key: lot_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## inventory_lot_example

| inventory_lot.lot_id | inventory_lot.medicine_id | inventory_lot.supplier_id | medicine.medicine_id | medicine.sku_code | supplier.supplier_id | supplier.supplier_name |
| --- | --- | --- | --- | --- | --- | --- |
| 1003 | 1001 | 1002 | 1001 | SYN-MED-001 | 1002 | Example Medical Supply |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## medicine

| medicine_id | sku_code | name | category | requires_cold_storage | reorder_level |
| --- | --- | --- | --- | --- | --- |
| 1001 | SYN-MED-001 | Synthetic saline solution | Fluid | false | 20 |

## supplier

| supplier_id | supplier_name | contact_email |
| --- | --- | --- |
| 1002 | Example Medical Supply | supply@example.test |

## inventory_lot

| lot_id | medicine_id | supplier_id | received_date | expiry_date | quantity_on_hand | unit_cost |
| --- | --- | --- | --- | --- | --- | --- |
| 1003 | 1001 | 1002 | 2026-10-01 | 2028-10-01 | 80 | 2.5 |

## stock_movement

| movement_id | lot_id | occurred_at | movement_type | quantity_delta |
| --- | --- | --- | --- | --- |
| 1004 | 1003 | 2026-10-02T09:30:00+00:00 | receipt | 80 |

## Dependencies

- medicine: (medicine_id) → sku_code, name, category, requires_cold_storage, reorder_level
- supplier: (supplier_id) → supplier_name, contact_email
- inventory_lot: (lot_id) → medicine_id, supplier_id, received_date, expiry_date, quantity_on_hand, unit_cost
- stock_movement: (movement_id) → lot_id, occurred_at, movement_type, quantity_delta

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
