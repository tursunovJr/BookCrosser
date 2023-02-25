from extensions import db
from uuid import uuid4
from datetime import datetime
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash



class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(20), nullable=False, unique=True)
    email = db.Column(db.String(20), nullable=False, unique=True)
    password = db.Column(db.String(20), nullable=False)
    city = db.Column(db.String(20), nullable=True)

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password, password)

    def __repr__(self):
	    return "<{}:{}>".format(self.id, self.username)

    # def __repr__(self):
    #     return "<User: username={}, email={}, city=\"{}\">\n"\
    #         .format(self.username, self.email, self.city)
