from flask import request
from flask_restful import Resource, abort
from marshmallow import ValidationError
from sqlalchemy.sql import func
from api.book.models import BookInfo
from api.utils import make_response, make_empty
from extensions import db
from sqlalchemy import exc
from api.book.parsers import BookInfoSchema
from api.book.fields import book_info_schema, books_schema


class Books(Resource):
    @staticmethod
    def post():
        """Create a book info"""
        try:
            args = BookInfoSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        user = BookInfo(**args)
        try:
            db.session.add(user)
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database add error")

        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_response(201, message="Book info added")
    
    @staticmethod
    def get():
         """Получить информацию о всех книгах"""

         books = db.session.query(BookInfo.uuid.label("uuid"), 
                                  BookInfo.holderID.label("holderID"),
                                  BookInfo.name.label("name"),
                                  BookInfo.author.label("author"), 
                                  BookInfo.genre.label("genre"),
                                  BookInfo.city.label("city"), 
                                  BookInfo.description.label("description"))\
        .all()
         return make_response(200, books = books_schema.dump(books))


class BooksActions(Resource):
    @staticmethod
    def get(book_uuid):
        """Получить информацию о книге"""

        book_info = db.session.query(BookInfo.uuid.label("uuid"), 
                                     BookInfo.holderID.label("holderID"),
                                     BookInfo.name.label("name"),
                                     BookInfo.author.label("author"), 
                                     BookInfo.genre.label("genre"),
                                     BookInfo.city.label("city"), 
                                     BookInfo.description.label("description"))\
            .filter(BookInfo.uuid.like(str(book_uuid)))\
            .one_or_none()

        if book_info is None or book_uuid is None:
            abort(404, message="Book info with uuid={} not found"
                  .format(book_uuid))

        return make_response(200, **book_info_schema.dump(book_info))
    
    @staticmethod
    def delete(book_uuid):
        """Delete book info with uuid"""
        if db.session.query(BookInfo).filter(BookInfo.uuid.like(str(book_uuid)))\
                .one_or_none() is None:
            abort(404, message="Book with uuid={} not found"
                  .format(book_uuid))

        book = db.session.query(BookInfo).filter(BookInfo.uuid.like(str(book_uuid))).one()
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
    def patch(book_uuid):
        """Update book info with uuid"""
        if db.session.query(BookInfo).filter(BookInfo.uuid.like(str(book_uuid))) \
                .one_or_none() is None:
            abort(404, message="Book with uuid={} not found"
                  .format(book_uuid))
        try:
            args = request.json
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")

        book = db.session.query(BookInfo).filter(BookInfo.uuid.like(str(book_uuid))).one()
        for key in args:
            if args[key] is not None:
                setattr(book, key, args[key])
        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_empty(200)