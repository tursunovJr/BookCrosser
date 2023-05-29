from marshmallow import Schema, fields

class BookInfoSchema(Schema):
    holderID = fields.Integer(attribute="holderID")
    name = fields.String(attribute="name")
    author = fields.String(attribute="author")
    genre = fields.String(attribute="genre")
    city = fields.String(attribute="city")
    image = fields.String(attribute="image")
    description = fields.String(attribute="description")
