from marshmallow import Schema, fields

class UserSchema(Schema):
    name = fields.String(attribute="name", required=True)
    surname = fields.String(attribute="surname", required=True)
    email = fields.String(attribute="email", required=True)
    city = fields.String(attribute="city", required=True)

class UserFavouriteBookSchema(Schema):
    email = fields.String(attribute="email", required=True)
    uuid = fields.String(attribute="book_uuid", required=True)
