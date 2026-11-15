# Portfolio 1 — Database Design and Modelling

I organised the data into medicine, supplier, inventory_lot, stock_movement. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| medicine | 1 |
| supplier | 1 |
| inventory_lot | 1 |
| stock_movement | 1 |

The 12 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Ishmael_Victor_301904616_P1_Design.md)
- [ER diagram](Ishmael_Victor_301904616_P1_ERDiagram.md)
- [Normalisation](Ishmael_Victor_301904616_P1_Normalisation.md)
- [Schema](Ishmael_Victor_301904616_P1_Schema.sql)
- [Sample data](Ishmael_Victor_301904616_P1_SampleData.sql)
- [Constraint tests](Ishmael_Victor_301904616_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Ishmael_Victor_301904616_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

