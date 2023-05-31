from marshmallow import fields, Schema, pre_dump
import random

class BookInfoSchema(Schema):
    uuid = fields.String(attribute="uuid")
    holderID = fields.Integer(attribute="holderID")
    name = fields.String(attribute="name")
    author = fields.String(attribute="author")
    genre = fields.String(attribute="genre")
    city = fields.String(attribute="city")
    description = fields.String(attribute="description")
    image = fields.String(attribute="image")
    rating = fields.Float(attribute="rating")
    state = fields.Integer(attribute="state")

    @pre_dump
    def group(self, data, many):
        return {
            "uuid": data.uuid,
            "holderID": data.holderID,
            "name": data.name,
            "author": data.author,
            "genre": random.sample(["Техническая", "Художественная", "Научная"], 1)[0],
            "city": data.city,
            "description": data.description,
            "image": data.image,
            "rating": round(random.uniform(3.0, 5.0), 2),
            "state": data.state
        }

book_info_schema = BookInfoSchema()
books_schema = BookInfoSchema(many=True)
