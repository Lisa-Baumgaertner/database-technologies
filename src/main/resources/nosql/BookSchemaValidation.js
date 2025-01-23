db.runCommand({
    collMod: "Book",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["bookId", "isbn", "copies", "metadata", "keywords", "reviews", "lendings", "waitlist"],
            properties: {
                bookId: {
                    bsonType: "int",
                    description: "Must be an integer and is required"
                },
                isbn: {
                    bsonType: "object",
                    required: ["isbn_long", "isbn_short"],
                    properties: {
                        isbn_long: {
                            bsonType: "string",
                            description: "Must be a string and is required"
                        },
                        isbn_short: {
                            bsonType: "string",
                            description: "Optional, must be a string if provided"
                        }
                    }
                },
                copies: {
                    bsonType: "int",
                    minimum: 0,
                    description: "Must be a non-negative integer"
                },
                metadata: {
                    bsonType: "object",
                    required: ["title", "author", "publisher", "description", "yearPublished"],
                    properties: {
                        title: {
                            bsonType: "string",
                            description: "Must be an string and is required"
                        },
                        author: {
                            bsonType: "string",
                            description: "Must be a string if provided"
                        },
                        publisher: {
                            bsonType: "string",
                            description: "Must be a string if provided"
                        },
                        description: {
                            bsonType: "string",
                            description: "Optional, must be a string if provided"
                        },
                        yearPublished: {
                            bsonType: "int",
                            minimum: 1000,
                            maximum: 9999,
                            description: "Must be a non-negative integer"
                        }
                    }
                },
                keywords: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["keywordId"],
                        properties: {
                            keywordId: {
                                bsonType: "int",
                                description: "Must be an integer and is required"
                            }
                        }
                    },
                    description: "Must be an array of keyword objects, each containing a keywordId"
                },
                reviews: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["reviewId", "borrowerId", "text", "date", "rating"],
                        properties: {
                            reviewId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            borrowerId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            text: {
                                bsonType: "string",
                                description: "Optional, must be a string if provided"
                            },
                            date: {
                                bsonType: "string",
                                pattern: "^\\d{2}-\\d{2}-\\d{4}$",
                                description: "Must be a date and is required"
                            },
                            rating: {
                                bsonType: "int",
                                minimum: 1,
                                maximum: 5,
                                description: "Must be an integer"
                            }
                        }
                    },
                    description: "Must be an array of review objects"
                },
                lendings: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["lendingId", "borrowerId", "workerId", "status", "checkoutDate", "dueDate", "returnDate"],
                        properties: {
                            lendingId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            borrowerId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            workerId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            status: {
                                bsonType: "string",
                                enum: ["borrowed", "returned"],
                                description: "Must be either 'borrowed' or 'returned'"
                            },
                            checkoutDate: {
                                bsonType: "string",
                                pattern: "^\\d{2}-\\d{2}-\\d{4}$",
                                description: "Must be a date"
                            },
                            dueDate: {
                                bsonType: "string",
                                pattern: "^\\d{2}-\\d{2}-\\d{4}$",
                                description: "Must be a date"
                            },
                            returnDate: {
                                bsonType: ["string", "null"],
                                description: "Optional field. Can be a string representing a date or null"
                            }
                        }

                    },
                    description: "Must be an array of lending objects"
                },
                waitlist: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["waitlistId", "borrowerId", "checkoutDate", "status", "returnDate"],
                        properties: {
                            waitlistId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            borrowerId: {
                                bsonType: "int",
                                description: "Must be an integer"
                            },
                            checkoutDate: {
                                bsonType: "string",
                                pattern: "^\\d{2}-\\d{2}-\\d{4}$",
                                description: "Must be a date and is required"
                            },
                            status: {
                                bsonType: "string",
                                enum: ["borrowed", "returned"],
                                "description": "Must be a string and is required"
                            },
                            returnDate: {
                                bsonType: ["string", "null"],
                                description: "Optional field. Can be a string representing a date or null"
                            }
                        }
                    },
                    description: "Must be an array of lending objects"
                }
            }
        }
    },
    validationLevel: "moderate",
    validationAction: "error"
});
