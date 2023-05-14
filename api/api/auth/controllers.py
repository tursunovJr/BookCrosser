from flask import request
from flask_restful import Resource
from marshmallow import ValidationError
from api.auth.parsers import UserSchema
from api.auth.models import Users
from api.utils import make_response, make_empty
from extensions import db
from sqlalchemy import exc
from api.auth.fields import user_info_schema


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
    