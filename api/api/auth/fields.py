from marshmallow import fields, Schema, pre_dump

class UserInfoSchema(Schema):
    name = fields.String(attribute="name")
    surname = fields.String(attribute="surname")
    email = fields.Email(attribute="email")
    city = fields.String(attribute="city")

    @pre_dump
    def group(self, data):
        return {
            "name": data["name"],
            "surname": data["surname"],
            "email": data["email"],
            "city": data["city"]
        }

user_info_schema = UserInfoSchema()

