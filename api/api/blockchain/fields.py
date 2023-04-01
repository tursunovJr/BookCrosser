from marshmallow import fields, Schema, pre_dump

class BlockSchema(Schema):
    index = fields.Integer(attribute="index")
    timestamp = fields.String(attribute="timestamp")
    transactions = fields.String(attribute="transactions")
    proof = fields.Integer(attribute="proof")
    prev_hash = fields.String(attribute="prev_hash")

    @pre_dump
    def group(self, data, many):
        return {
            "index": data.index,
            "timestamp": data.timestamp,
            "transactions": data.transactions,
            "proof": data.proof,
            "prev_hash": data.prev_hash
        }
    
block_schema = BlockSchema()
