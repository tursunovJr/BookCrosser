from extensions import db


class Transactions(db.Model):
    index = db.Column(db.Integer, primary_key=True)
    sender = db.Column(db.String, nullable=False)
    receiver = db.Column(db.String, nullable=False)
    bookID = db.Column(db.Integer, nullable=False)

class Blockchain(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    bookID = db.Column(db.String, nullable=False)
    index = db.Column(db.Integer, nullable=True)
    timestamp = db.Column(db.String, nullable=True)
    transactions = db.Column(db.String, nullable=True)
    proof = db.Column(db.Integer, nullable=False)
    prev_hash = db.Column(db.String, nullable=False)