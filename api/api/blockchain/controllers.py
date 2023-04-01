from flask import request
from flask_restful import Resource, abort
from marshmallow import ValidationError
from api.blockchain.models import Transactions, Blockchain
from api.utils import make_response
from extensions import db
from sqlalchemy import exc
from api.blockchain.parsers import TransactionSchema
from api.blockchain.fields import blockchain_schema
import hashlib
from time import time
import random

class BlockchainTransaction(Resource):
    
    @staticmethod
    def post():
        """Create a new transaction"""
        try:
            args = TransactionSchema().load(request.json)
        except ValidationError as error:
            return make_response(400, message="Bad JSON format")
        
        transaction = Transactions(**args)
        try:
            db.session.add(transaction)
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database add error")

        try:
            db.session.commit()
        except exc.SQLAlchemyError:
            db.session.rollback()
            return make_response(500, message="Database commit error")
        return make_response(201, message="Transaction will be added to Block")
    
class BlockchainAction(Resource):

    @staticmethod
    def get(bookID):

        """ Get a blockchain of bookID """

        chain = db.session.query(Blockchain.bookID.label("bookID"),
                                 Blockchain.timestamp.label("timestamp"),
                                 Blockchain.transactions.label("transactions")).filter(Blockchain.bookID.like(bookID)).all()
        
        if chain is None or bookID is None:
            abort(404, message="Book info with uuid={} not found"
                  .format(bookID))
            
        return make_response(200, chain = blockchain_schema.dump(chain))
    
class BlockchainMine(Resource):

    @staticmethod
    def get():
        """Mine a new transaction """

        transaction = db.session.query(Transactions.bookID.label("bookID"),
                                       Transactions.sender.label("sender"), 
                                       Transactions.receiver.label("receiver")).all()
        
        last_transaction = transaction[-1]
        delete_transaction(last_transaction["bookID"])

        chain = db.session.query(Blockchain.bookID.label("bookID"),
                                 Blockchain.index.label("index"),
                                 Blockchain.timestamp.label("timestamp"),
                                 Blockchain.transactions.label("transactions"),
                                 Blockchain.prev_hash.label("prev_hash"),
                                 Blockchain.proof.label("proof")).filter(Blockchain.bookID.like(last_transaction["bookID"])).all()
        
        if chain is None or len(chain) == 0:
            args = {'bookID': last_transaction["bookID"], 'prev_hash': 1, 'proof':  random.randint(20, 100)}
            add_block(args)

        chain = db.session.query(Blockchain.bookID.label("bookID"),
                                 Blockchain.index.label("index"),
                                 Blockchain.timestamp.label("timestamp"),
                                 Blockchain.transactions.label("transactions"),
                                 Blockchain.prev_hash.label("prev_hash"),
                                 Blockchain.proof.label("proof")).filter(Blockchain.bookID.like(last_transaction["bookID"])).all()

        proof = proof_of_work(chain[-1])
        previous_hash = hash(chain[-1])

        block = {
            'bookID': last_transaction["bookID"],
            'index': len(chain) + 1,
            'timestamp': str(time()),
            'transactions': str(last_transaction),
            'proof': proof,
            'prev_hash': str(previous_hash)
        }

        add_block(block)
        return make_response(200, message="Block was successfully mined")
    
    
def delete_transaction(bookID):
    transaction = db.session.query(Transactions).filter(Transactions.bookID.like(bookID)).all()
    try:
        db.session.delete(transaction[-1])
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database delete block error")
    try:
        db.session.commit()
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database commit block error")
    
def add_block(args):
    block = Blockchain(**args)
    try:
        db.session.add(block)
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database add block to blockchain error")
    try:
        db.session.commit()
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database commit error while adding block to blockchain ")
    
def proof_of_work(last_block):
    """
    Simple Proof of Work Algorithm:

        - Find a number p' such that hash(pp') contains leading 4 zeroes
        - Where p is the previous proof, and p' is the new proof
        
    :param last_block: <dict> last Block
    :return: <int>
    """

    last_proof = last_block["proof"]
    last_hash = hash(last_block)

    proof = 0
    while valid_proof(last_proof, proof, last_hash) is False:
        proof += 1

    return proof

def valid_proof(last_proof, proof, last_hash):
    """
    Validates the Proof

    :param last_proof: <int> Previous Proof
    :param proof: <int> Current Proof
    :param last_hash: <str> The hash of the Previous Block
    :return: <bool> True if correct, False if not.

    """

    guess = f'{last_proof}{proof}{last_hash}'.encode()
    guess_hash = hashlib.sha256(guess).hexdigest()
    return guess_hash[:4] == "0000"

def hash(block):
    """
    Creates a SHA-256 hash of a Block

    :param block: Block
    """
    return hashlib.sha256(repr(block).encode()).hexdigest()
