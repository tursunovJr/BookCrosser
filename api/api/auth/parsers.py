from marshmallow import Schema, fields

class UserSchema(Schema):
    name = fields.String(attribute="name", required=True)
    surname = fields.String(attribute="surname", required=True)
    email = fields.Email(attribute="email", required=True)
    city = fields.String(attribute="city", required=True)
