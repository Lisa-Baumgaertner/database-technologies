db.runCommand({
    collMod: "Keyword",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["keyword_id", "keyword"],
            properties: {
                keyword_id: {
                    bsonType: "int",
                    description: "Must be an integer and is required"
                },
                keyword: {
                    bsonType: "string",
                    description: "Must be a string and is required"
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});
