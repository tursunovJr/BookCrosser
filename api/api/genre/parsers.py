from marshmallow import Schema, fields

class GenreSchema(Schema):
    name = fields.String(attribute="name")
