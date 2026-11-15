# Smart Medical Inventory and Emergency Supply Management System — ER diagram

```mermaid
erDiagram
    direction LR
    medicine {
        bigint medicine_id PK
        text sku_code UK
        text name
        text category
        boolean requires_cold_storage
        integer reorder_level
    }
    supplier {
        bigint supplier_id PK
        text supplier_name
        text contact_email UK
    }
    inventory_lot {
        bigint lot_id PK
        bigint medicine_id FK
        bigint supplier_id FK
        date received_date
        date expiry_date
        integer quantity_on_hand
        numeric unit_cost
    }
    stock_movement {
        bigint movement_id PK
        bigint lot_id FK
        timestamptz occurred_at
        text movement_type
        integer quantity_delta
    }
    medicine ||--o{ inventory_lot : "medicine_id"
    supplier ||--o{ inventory_lot : "supplier_id"
    inventory_lot ||--o{ stock_movement : "lot_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ishmael_Victor_301904616_ERDiagram.png)
