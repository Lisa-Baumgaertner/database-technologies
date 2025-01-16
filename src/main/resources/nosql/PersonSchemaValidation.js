db.runCommand({
    collMod: "Person",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["userId", "role", "personalDetails", "address", "contact"],
            properties: {
                userId: {
                    bsonType: "int",
                    description: "Must be an integer value"
                },
                role: {
                    bsonType: "string",
                    description: "Must be a string (e.g., 'borrower' or 'worker')"
                },
                personalDetails: {
                    bsonType:  "object",
                    required: ["firstName", "lastName", "dateOfBirth", "gender"],
                    properties: {
                        firstName: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        lastName: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        dateOfBirth: {
                            bsonType: "string",
                            description: "Must be a valid date string (e.g., '22-03-1999')"
                        },
                        gender: {
                            enum: ["M", "F"],
                            description: "Must be either 'M' or 'F'"
                        }
                    }
                },
                address: {
                    bsonType: "object",
                    required: ["street", "houseNumber", "city", "zipCode"],
                    properties: {
                        street: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        houseNumber: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        city: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        zipCode: {
                            bsonType: "string",
                            description: "Must be a string value"
                        }
                    }
                },
                contact: {
                    bsonType:  "object",
                    required: ["phone", "mobile", "email"],
                    properties: {
                        phone: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        mobile: {
                            bsonType: "string",
                            description: "Must be a string"
                        },
                        email: {
                            bsonType: "string",
                            description: "Must be a string"
                        }
                    }
                },
                reviews: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["reviewId", "bookId", "text", "date", "rating"],
                        properties: {
                            reviewId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            bookId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            text: {
                                bsonType: "string",
                                description: "Must be a string"
                            },
                            date: {
                                bsonType: "string",
                                description: "Must be a valid date format"
                            },
                            rating: {
                                bsonType: "int",
                                description: "Must be an integer between 1 and 5"
                            }
                        }
                    }
                },
                lendings: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["lendingId", "bookId", "workerId", "status", "checkoutDate", "dueDate"],
                        properties: {
                            lendingId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            bookId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            workerId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            status: {
                                bsonType: "string",
                                description: "Must be a string (e.g., 'borrowed', 'returned')"
                            },
                            checkoutDate: {
                                bsonType: "string",
                                description: "Must be a valid date"
                            },
                            returnDate: {
                                bsonType: ["string", "null"],
                                description: "Can be null if the book has not been returned"
                            },
                            dueDate: {
                                bsonType: "string",
                                description: "Must be a valid date"
                            }
                        }
                    },
                    description: "Must be an array of lending objects"
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});