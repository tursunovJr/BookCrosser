from flask import request
from flask_restful import Resource
from marshmallow import ValidationError
from sqlalchemy.sql import func
from api.blockchain.models import Transactions, Blockchain
from api.utils import make_response
from extensions import db
from sqlalchemy import exc
from api.blockchain.parsers import TransactionSchema
from api.blockchain.fields import block_schema
import hashlib
import json
import time

from time import time


class BlockchainTransaction(Resource):
    
    @staticmethod
    def post():
        """Create a new transaction"""
        try:
            args = TransactionSchema().load(request.json)
            print(args)
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
            add_first_block(last_transaction["bookID"])

        chain = db.session.query(Blockchain.bookID.label("bookID"),
                                 Blockchain.index.label("index"),
                                 Blockchain.timestamp.label("timestamp"),
                                 Blockchain.transactions.label("transactions"),
                                 Blockchain.prev_hash.label("prev_hash"),
                                 Blockchain.proof.label("proof")).filter(Blockchain.bookID.like(last_transaction["bookID"])).all()

        proof = proof_of_work(chain[-1])
        previous_hash = hash(chain[-1])

        args = {
            'bookID': last_transaction["bookID"],
            'index': len(chain) + 1,
            'timestamp': str(time()),
            'transactions': str(last_transaction),
            'proof': proof,
            'prev_hash': str(previous_hash)
        }


        block = Blockchain(**args)
        print(args)
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
        

        return make_response(200, block = block_schema.dump(block))
    
def delete_transaction(bookID):
    transaction = db.session.query(Transactions).filter(Transactions.bookID.like(bookID)).one()
    try:
        db.session.delete(transaction)
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database delete error")

    try:
        db.session.commit()
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database commit error")
    

def add_first_block(bookID):
    args = {'bookID': bookID, 'prev_hash': 1, 'proof': 100}
    first_chain = Blockchain(**args)
    try:
        db.session.add(first_chain)
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database add first block to blockchain error")

    try:
        db.session.commit()
    except exc.SQLAlchemyError:
        db.session.rollback()
        return make_response(500, message="Database commit error while adding first block to blockchain ")
    
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

    # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
    # block_string = json.dumps(block, sort_keys=True).encode()
    print(block)
    return hashlib.sha256(repr(block).encode()).hexdigest()
