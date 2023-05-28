from flask import request
from flask_restful import Resource
from marshmallow import ValidationError
from api.auth.parsers import UserSchema, UserFavouriteBookSchema
from api.auth.models import Users, UsersFavouriteBooks
from api.utils import make_response, make_empty
from extensions import db
from sqlalchemy import exc
from api.auth.fields import user_info_schema, user_fav_books_schema


class User(Resource):
    @staticmethod
    def post():
        """Create a user"""
        try:
            args = UserSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        user = Users(**args)
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

        return make_empty(201)
    
class UserInfo(Resource):
    @staticmethod    
    def get(email):
        """Получить информацию о пользователе"""

        user_info = db.session.query(Users.name.label("name"),
                                     Users.surname.label("surname"),
                                     Users.email.label("email"),
                                     Users.city.label("city"))\
            .filter(Users.email.like(str(email)))\
            .one_or_none()

        if user_info is None or id is None:
            abort(404, message="Book info with email={} not found"
                  .format(email))

        return make_response(200, **user_info_schema.dump(user_info))

class UserFavouriteBook(Resource):
    @staticmethod
    def post():
        """Add book to favourite"""
        try:
            args = UserFavouriteBookSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        userBooks = UsersFavouriteBooks(**args)
        fav_book = db.session.query(UsersFavouriteBooks).filter(UsersFavouriteBooks.email.like(str(userBooks.email)), UsersFavouriteBooks.book_uuid.like(str(userBooks.book_uuid))).all()
        if fav_book is None or len(fav_book) == 0:
            try:
                db.session.add(userBooks)
            except exc.SQLAlchemyError:
                db.session.rollback()
                return make_response(500, message="Database add error")
            try:
                db.session.commit()
            except exc.SQLAlchemyError:
                db.session.rollback()
                return make_response(500, message="Database commit error")

            return make_empty(201)
    
class UserFavouriteBookInfo(Resource):
    @staticmethod    
    def get(email):
        """Получить информацию о любимых книгах пользователя"""

        user_fav_book_info = db.session.query(UsersFavouriteBooks.email.label("email"),
                                              UsersFavouriteBooks.book_uuid.label("book_uuid"))\
            .filter(UsersFavouriteBooks.email.like(str(email)))\
            .all()

        if user_fav_book_info is None or id is None:
            abort(404, message="User's fav books with email={} not found"
                  .format(email))

        return make_response(200, favBooks = user_fav_books_schema.dump(user_fav_book_info))
    
    @staticmethod
    def delete(email, uuid):
        """Delete a user's fav book with uuid"""
        if db.session.query(UsersFavouriteBooks).filter(UsersFavouriteBooks.email.like(str(email)))\
                .all() is None:
            abort(404, message="User with email={} not found"
                  .format(email))

        fav_book = db.session.query(UsersFavouriteBooks).filter(UsersFavouriteBooks.email.like(str(email)), UsersFavouriteBooks.book_uuid.like(str(uuid))).one()
        try:
            db.session.delete(fav_book)
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database delete error")

        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")

        return make_empty(200)
            
    