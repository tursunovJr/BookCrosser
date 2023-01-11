from marshmallow import Schema, fields

class UserSchema(Schema):
    id = fields.Integer(attribute="id", required=True)
    username = fields.String(attribute="username", required=True)
    email = fields.Email(attribute="email", required=True)
    password = fields.String(attribute="password", required=True)
    city = fields.String(attribute="city", required=True)
