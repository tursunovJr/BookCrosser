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

    @pre_dump
    def group(self, data, many):
        return {
            "uuid": data.uuid,
            "holderID": data.holderID,
            "name": data.name,
            "author": data.author,
            "genre": data.genre,
            "city": data.city,
            "description": data.description,
            "image": "book",
            "rating": round(random.uniform(1.0, 5.0), 2) 
        }

book_info_schema = BookInfoSchema()
books_schema = BookInfoSchema(many=True)
