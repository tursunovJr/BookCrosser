from marshmallow import fields, Schema, pre_dump

class UserInfoSchema(Schema):
    name = fields.String(attribute="name")
    surname = fields.String(attribute="surname")
    email = fields.String(attribute="email")
    city = fields.String(attribute="city")

    @pre_dump
    def group(self, data, many=False):
        if many:
            return [self.group(d) for d in data]
        return {
            "name": data["name"],
            "surname": data["surname"],
            "email": data["email"],
            "city": data["city"]
        }
    

class UsersFavBookSchema(Schema):
    email = fields.String(attribute="email")
    book_uuid = fields.String(attribute="book_uuid")

    @pre_dump
    def group(self, data, many):
        return {
            "book_uuid": data["book_uuid"]
        }

user_info_schema = UserInfoSchema()
user_fav_books_schema = UsersFavBookSchema(many=True)