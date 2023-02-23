from extensions import db
from uuid import uuid4
from datetime import datetime


class BookInfo(db.Model):
    uuid = db.Column(db.String(36), primary_key=True,
                     default=lambda: str(uuid4()))
    # holderID = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(36), nullable=False)
    author = db.Column(db.String(36), nullable=False)
    genre = db.Column(db.String(36), nullable=False)
    city = db.Column(db.String(36), nullable=False)
    description = db.Column(db.String(200), nullable=False)