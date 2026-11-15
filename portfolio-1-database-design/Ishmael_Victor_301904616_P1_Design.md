# Smart Medical Inventory and Emergency Supply Management System — database design

My case study records medicine, supplier, inventory_lot, stock_movement.

## Users

- Inventory coordinators monitoring stock and expiry dates
- Emergency supply staff recording issues and adjustments

## Main operations

- Record received lots and their suppliers
- Record stock movements and review available quantities
- Identify lots approaching expiry and summarize usage

## Entities

| Entity | Information stored |
| --- | --- |
| medicine | Catalog of medical supplies managed by the system. |
| supplier | Supplier directory for medical inventory lots. |
| inventory_lot | Received batch of one medicine from one supplier, with its dates, cost, and current quantity. |
| stock_movement | Timestamped record of a receipt, issue, or adjustment affecting one inventory lot. |

## medicine

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| medicine_id | BIGINT | PK | Yes |
| sku_code | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| category | TEXT |  | Yes |
| requires_cold_storage | BOOLEAN |  | Yes |
| reorder_level | INTEGER |  | Yes |
- Unique key: (sku_code).

## supplier

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| supplier_id | BIGINT | PK | Yes |
| supplier_name | TEXT |  | Yes |
| contact_email | TEXT | Unique | Yes |
- Unique key: (contact_email).

## inventory_lot

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| lot_id | BIGINT | PK | Yes |
| medicine_id | BIGINT | FK | Yes |
| supplier_id | BIGINT | FK | Yes |
| received_date | DATE |  | Yes |
| expiry_date | DATE |  | Yes |
| quantity_on_hand | INTEGER |  | Yes |
| unit_cost | NUMERIC(18,2) |  | Yes |
- medicine_id → medicine.medicine_id
- supplier_id → supplier.supplier_id

## stock_movement

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| movement_id | BIGINT | PK | Yes |
| lot_id | BIGINT | FK | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| movement_type | TEXT |  | Yes |
| quantity_delta | INTEGER |  | Yes |
- lot_id → inventory_lot.lot_id

## Relationships and business rules

- Each medicine has a distinct synthetic SKU code.
- Each supplier contact email is unique in the exercise data.
- Every inventory lot references an existing medicine through medicine_id.
- Every inventory lot references an existing supplier through supplier_id.
- Every stock movement references an existing inventory lot through lot_id.
- A lot's current quantity_on_hand must be zero or greater.
- A recorded stock movement must change quantity by a nonzero amount.

## Assumptions

- Each lot refers to one medicine and one supplier; their descriptive details are stored in their respective parent entities.
- Normalization example: inventory_lot stores medicine_id and supplier_id as foreign keys, while medicine and supplier descriptions remain in their parent entities rather than being repeated in the lot.
- A stock movement refers to one lot, and quantity_delta is positive for receipts and negative for issues.
- A lot's quantity_on_hand is maintained as its current balance; the exercise does not require deriving balances from the full movement history.
- Each entity's single-column primary key is generated from a global identifier namespace so identifiers do not overlap across entities.
- All names, identifiers, contact details, dates, and quantities used in the exercise are synthetic.

