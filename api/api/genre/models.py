from extensions import db
from uuid import uuid4
from datetime import datetime

class Genres(db.Model):
    uuid = db.Column(db.String(36), primary_key=True,
                     default=lambda: str(uuid4()))
    name = db.Column(db.String(36), nullable=False)