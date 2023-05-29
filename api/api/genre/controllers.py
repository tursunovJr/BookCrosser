from flask import request
from flask_restful import Resource, abort
from marshmallow import ValidationError
from api.genre.models import Genres
from api.book.models import BookInfo
from api.utils import make_response, make_empty
from extensions import db
from sqlalchemy import exc
from api.genre.parsers import GenreSchema
from api.genre.fields import genre_schema, genres_schema


class Genre(Resource):
    @staticmethod
    def post():
        """Create a genre info"""
        try:
            args = GenreSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        genre = Genres(**args)
        try:
            db.session.add(genre)
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database add error")

        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_response(201, message="New genre added")
    
    @staticmethod
    def get():
         """Get all genre namespaces"""

         genres = db.session.query(Genres.uuid.label("uuid"), 
                                   Genres.name.label("name"))\
        .all()
         return make_response(200, genres = genres_schema.dump(genres))
    
class GenresActions(Resource):
    @staticmethod
    def get(genre_uuid):
        """Get genre name"""

        genre = db.session.query(Genres.uuid.label("uuid"),
                                 Genres.name.label("name"))\
            .filter(Genres.uuid.like(str(genre_uuid)))\
            .one_or_none()

        if genre is None or genre_uuid is None:
            abort(404, message="Genre with uuid={} not found"
                  .format(genre_uuid))

        return make_response(200, **genre_schema.dump(genre))
    
    @staticmethod
    def delete(genre_uuid):
        """Delete a genre with uuid"""
        if db.session.query(Genres).filter(Genres.uuid.like(str(genre_uuid)))\
                .one_or_none() is None:
            abort(404, message="Genre with uuid={} not found"
                  .format(genre_uuid))

        book = db.session.query(Genres).filter(Genres.uuid.like(str(genre_uuid))).one()
        try:
            db.session.delete(book)
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database delete error")

        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_empty(200)
    

    @staticmethod
    # @login_required
    def patch(genre_uuid):
        """Update a genre name with uuid"""
        if db.session.query(Genres).filter(Genres.uuid.like(str(genre_uuid))) \
                .one_or_none() is None:
            abort(404, message="Genre with uuid={} not found"
                  .format(genre_uuid))
        try:
            args = request.json
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")

        book = db.session.query(Genres).filter(Genres.uuid.like(str(genre_uuid))).one()
        for key in args:
            if args[key] is not None:
                setattr(book, key, args[key])
        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_empty(200)