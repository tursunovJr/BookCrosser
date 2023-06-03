from marshmallow import fields, Schema, pre_dump

class BlockSchema(Schema):
    bookID = fields.String(attribute="bookID")
    timestamp = fields.String(attribute="timestamp")
    transactions = fields.String(attribute="transactions")

    @pre_dump
    def group(self, data, many):
        return {
            "bookID": data.bookID,
            "timestamp": data.timestamp,
            "transactions": data.transactions
        }
    
blockchain_schema = BlockSchema(many=True)