from marshmallow import Schema, fields

class TransactionSchema(Schema):
    sender = fields.String(attribute="sender")
    receiver = fields.String(attribute="receiver")
    bookID = fields.String(attribute="bookID")
