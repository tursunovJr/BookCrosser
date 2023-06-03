from marshmallow import Schema, fields

class BookInfoSchema(Schema):
    holder = fields.String(attribute="holder")
    name = fields.String(attribute="name")
    author = fields.String(attribute="author")
    genre = fields.String(attribute="genre")
    city = fields.String(attribute="city")
    image = fields.String(attribute="image")
    description = fields.String(attribute="description")
    state = fields.Integer(attribute="state")
