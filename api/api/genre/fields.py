from marshmallow import fields, Schema, pre_dump

class GenreInfoSchema(Schema):
    uuid = fields.String(attribute="uuid")
    name = fields.String(attribute="name")

    @pre_dump
    def group(self, data, many):
        return {
            "uuid": data.uuid,
            "name": data.name
        }

genre_schema = GenreInfoSchema()
genres_schema = GenreInfoSchema(many=True)
