from extensions import db

class Users(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    surname = db.Column(db.String, nullable=False)
    email = db.Column(db.String(20), nullable=False, unique=True)
    city = db.Column(db.String, nullable=True)