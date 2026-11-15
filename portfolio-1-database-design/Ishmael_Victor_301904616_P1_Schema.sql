-- Smart Medical Inventory and Emergency Supply Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."medicine" (
  "medicine_id" bigint NOT NULL,
  "sku_code" text NOT NULL,
  "name" text NOT NULL,
  "category" text NOT NULL,
  "requires_cold_storage" boolean NOT NULL,
  "reorder_level" bigint NOT NULL,
  CONSTRAINT "pk_medicine" PRIMARY KEY ("medicine_id"),
  CONSTRAINT "uq_medicine_0" UNIQUE ("sku_code")
);
CREATE TABLE portfolio."supplier" (
  "supplier_id" bigint NOT NULL,
  "supplier_name" text NOT NULL,
  "contact_email" text NOT NULL,
  CONSTRAINT "pk_supplier" PRIMARY KEY ("supplier_id"),
  CONSTRAINT "uq_supplier_0" UNIQUE ("contact_email")
);
CREATE TABLE portfolio."inventory_lot" (
  "lot_id" bigint NOT NULL,
  "medicine_id" bigint NOT NULL,
  "supplier_id" bigint NOT NULL,
  "received_date" date NOT NULL,
  "expiry_date" date NOT NULL,
  "quantity_on_hand" bigint NOT NULL,
  "unit_cost" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_inventory_lot" PRIMARY KEY ("lot_id")
);
CREATE TABLE portfolio."stock_movement" (
  "movement_id" bigint NOT NULL,
  "lot_id" bigint NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "movement_type" text NOT NULL,
  "quantity_delta" bigint NOT NULL,
  CONSTRAINT "pk_stock_movement" PRIMARY KEY ("movement_id")
);
ALTER TABLE portfolio."inventory_lot" ADD CONSTRAINT "fk_inventory_lot_0" FOREIGN KEY ("medicine_id") REFERENCES portfolio."medicine" ("medicine_id");
ALTER TABLE portfolio."inventory_lot" ADD CONSTRAINT "fk_inventory_lot_1" FOREIGN KEY ("supplier_id") REFERENCES portfolio."supplier" ("supplier_id");
ALTER TABLE portfolio."stock_movement" ADD CONSTRAINT "fk_stock_movement_0" FOREIGN KEY ("lot_id") REFERENCES portfolio."inventory_lot" ("lot_id");
ALTER TABLE portfolio."inventory_lot" ADD CONSTRAINT "lot_nonnegative" CHECK ("quantity_on_hand" >= 0);
ALTER TABLE portfolio."stock_movement" ADD CONSTRAINT "movement_nonzero" CHECK (("quantity_delta" < 0) OR ("quantity_delta" > 0));
COMMIT;
