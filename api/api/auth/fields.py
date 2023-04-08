from marshmallow import fields, Schema, pre_dump

class UserInfoSchema(Schema):
    id = fields.String(attribute="id")
    username = fields.String(attribute="username")
    email = fields.String(attribute="email")
    city = fields.String(attribute="city")

    @pre_dump
    def group(self, data, many):
        print("Serik", data)
        return {
            "id": data["id"],
            "username": data["username"],
            "email": data["email"],
            "city": data["city"]
        }

user_info_schema = UserInfoSchema()

