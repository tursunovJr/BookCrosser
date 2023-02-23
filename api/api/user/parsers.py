from marshmallow import Schema, fields

class UserSchema(Schema):
    username = fields.String(attribute="username", required=True)
    email = fields.Email(attribute="email", required=True)
    password = fields.String(attribute="password", required=True)

class UserAuthSchema(Schema):
    username = fields.String(attribute="username", required=True)
    password = fields.String(attribute="password", required=True)
