// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("inventory_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("inventory_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "receipt",
                    "issue"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "stock_movement"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "movement_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("inventory_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "receipt",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "stock_movement",
            "key": {
                "movement_id": 1004
            },
            "snapshot": {
                "movement_id": 1004,
                "lot_id": 1003,
                "occurred_at": "2026-10-02T09:30:00Z",
                "movement_type": "receipt",
                "quantity_delta": 80
            }
        },
        "embedded": {
            "inventory_lot": [
                {
                    "key": {
                        "lot_id": 1003
                    },
                    "snapshot": {
                        "lot_id": 1003,
                        "medicine_id": 1001,
                        "supplier_id": 1002,
                        "received_date": "2026-10-01",
                        "expiry_date": "2028-10-01",
                        "quantity_on_hand": 80,
                        "unit_cost": 2.5
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot"
                    ]
                }
            ],
            "medicine": [
                {
                    "key": {
                        "medicine_id": 1001
                    },
                    "snapshot": {
                        "medicine_id": 1001,
                        "sku_code": "SYN-MED-001",
                        "name": "Synthetic saline solution",
                        "category": "Fluid",
                        "requires_cold_storage": false,
                        "reorder_level": 20
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot.medicine_id → medicine"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 1002
                    },
                    "snapshot": {
                        "supplier_id": 1002,
                        "supplier_name": "Example Medical Supply",
                        "contact_email": "supply@example.test"
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "issue",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "stock_movement",
            "key": {
                "movement_id": 1004
            },
            "snapshot": {
                "movement_id": 1004,
                "lot_id": 1003,
                "occurred_at": "2026-10-02T09:30:00Z",
                "movement_type": "receipt",
                "quantity_delta": 80
            }
        },
        "embedded": {
            "inventory_lot": [
                {
                    "key": {
                        "lot_id": 1003
                    },
                    "snapshot": {
                        "lot_id": 1003,
                        "medicine_id": 1001,
                        "supplier_id": 1002,
                        "received_date": "2026-10-01",
                        "expiry_date": "2028-10-01",
                        "quantity_on_hand": 80,
                        "unit_cost": 2.5
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot"
                    ]
                }
            ],
            "medicine": [
                {
                    "key": {
                        "medicine_id": 1001
                    },
                    "snapshot": {
                        "medicine_id": 1001,
                        "sku_code": "SYN-MED-001",
                        "name": "Synthetic saline solution",
                        "category": "Fluid",
                        "requires_cold_storage": false,
                        "reorder_level": 20
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot.medicine_id → medicine"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 1002
                    },
                    "snapshot": {
                        "supplier_id": 1002,
                        "supplier_name": "Example Medical Supply",
                        "contact_email": "supply@example.test"
                    },
                    "via": [
                        "stock_movement.lot_id → inventory_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "reason": "illustrative reason",
                "emergency_reference": "illustrative emergency_reference",
                "recorded_by": "illustrative recorded_by",
                "metadata": "illustrative metadata"
            }
        }
    }
]));
  await db.getCollection("inventory_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("inventory_events").find({"eventType":"receipt"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("inventory_events").find({"source.key.movement_id":1004}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("inventory_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "receipt",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "stock_movement",
        "key": {
            "movement_id": 1004
        },
        "snapshot": {
            "movement_id": 1004,
            "lot_id": 1003,
            "occurred_at": "2026-10-02T09:30:00Z",
            "movement_type": "receipt",
            "quantity_delta": 80
        }
    },
    "embedded": {
        "inventory_lot": [
            {
                "key": {
                    "lot_id": 1003
                },
                "snapshot": {
                    "lot_id": 1003,
                    "medicine_id": 1001,
                    "supplier_id": 1002,
                    "received_date": "2026-10-01",
                    "expiry_date": "2028-10-01",
                    "quantity_on_hand": 80,
                    "unit_cost": 2.5
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot"
                ]
            }
        ],
        "medicine": [
            {
                "key": {
                    "medicine_id": 1001
                },
                "snapshot": {
                    "medicine_id": 1001,
                    "sku_code": "SYN-MED-001",
                    "name": "Synthetic saline solution",
                    "category": "Fluid",
                    "requires_cold_storage": false,
                    "reorder_level": 20
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot.medicine_id → medicine"
                ]
            }
        ],
        "supplier": [
            {
                "key": {
                    "supplier_id": 1002
                },
                "snapshot": {
                    "supplier_id": 1002,
                    "supplier_name": "Example Medical Supply",
                    "contact_email": "supply@example.test"
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot.supplier_id → supplier"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("inventory_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "receipt",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "stock_movement",
        "key": {
            "movement_id": 1004
        },
        "snapshot": {
            "movement_id": 1004,
            "lot_id": 1003,
            "occurred_at": "2026-10-02T09:30:00Z",
            "movement_type": "receipt",
            "quantity_delta": 80
        }
    },
    "embedded": {
        "inventory_lot": [
            {
                "key": {
                    "lot_id": 1003
                },
                "snapshot": {
                    "lot_id": 1003,
                    "medicine_id": 1001,
                    "supplier_id": 1002,
                    "received_date": "2026-10-01",
                    "expiry_date": "2028-10-01",
                    "quantity_on_hand": 80,
                    "unit_cost": 2.5
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot"
                ]
            }
        ],
        "medicine": [
            {
                "key": {
                    "medicine_id": 1001
                },
                "snapshot": {
                    "medicine_id": 1001,
                    "sku_code": "SYN-MED-001",
                    "name": "Synthetic saline solution",
                    "category": "Fluid",
                    "requires_cold_storage": false,
                    "reorder_level": 20
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot.medicine_id → medicine"
                ]
            }
        ],
        "supplier": [
            {
                "key": {
                    "supplier_id": 1002
                },
                "snapshot": {
                    "supplier_id": 1002,
                    "supplier_name": "Example Medical Supply",
                    "contact_email": "supply@example.test"
                },
                "via": [
                    "stock_movement.lot_id → inventory_lot.supplier_id → supplier"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("inventory_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
