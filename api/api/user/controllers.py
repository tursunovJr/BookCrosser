from flask import request
from flask_restful import Resource
from marshmallow import ValidationError
from api.user.parsers import UserSchema, UserAuthSchema
from api.user.models import User
from api.utils import make_response, make_empty
from extensions import db, login_manager
from sqlalchemy import exc
from werkzeug.security import generate_password_hash
from flask_login import login_user, login_required, logout_user


class UserRegister(Resource):
    @staticmethod
    def post():
        """Create a user"""
        try:
            args = UserSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")

        args['password'] = generate_password_hash(str(args['password']))
        username = db.session.query(User).filter(User.username.like(args['username'])).first()
        email = db.session.query(User).filter(User.email.like(args['email'])).first()
        if username or email:
            return make_response(401, message="User with username or email already exist")
        user = User(**args)
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

class UserAuth(Resource):
    @staticmethod
    def post():
        """Auth user"""
        try:
            args = UserAuthSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        user = db.session.query(User).filter(User.username.like(args['username'])).first()
        if user and user.check_password(args['password']):
            login_user(user)
            return make_response(200, message="Successful Auth")
        return make_response(401, message="Auth error")
    
class UserLogout(Resource):

    @login_manager.user_loader
    def load_user(user):
        return User.query.get(int(user))

    @staticmethod
    @login_required
    def post():
        try:
            args = UserAuthSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        user = db.session.query(User).filter(User.username.like(args['username'])).first()
        if user and user.check_password(args['password']):
            logout_user()
            return make_response(200,message="Successful Logout")
        return make_response(401, message="Auth error")
    
        
    