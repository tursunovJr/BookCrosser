from flask import Blueprint, json
from flask_restful import Api
from werkzeug.exceptions import HTTPException
from api.auth.controllers import UserRegister, UserAuth, UserLogout, UserInfo
from api.book.controllers import Books, BooksActions
from api.genre.controllers import Genre, GenresActions
from api.blockchain.controllers import BlockchainTransaction, BlockchainMine, BlockchainAction


api_bp = Blueprint("api", __name__)
api = Api(api_bp)

# Add resources

# Auth API Module
api.add_resource(UserRegister, "/register")
api.add_resource(UserAuth, "/auth")
api.add_resource(UserLogout, "/logout")
api.add_resource(UserInfo, "/user")

# Book API Module
api.add_resource(Books, "/book")
api.add_resource(BooksActions, "/book/<uuid:book_uuid>", endpoint="book_info")


#Genre API Module
api.add_resource(Genre, "/genre")
api.add_resource(GenresActions, "/genre/<uuid:genre_uuid>", endpoint="genre_info")

#Blockchain API Module
api.add_resource(BlockchainTransaction, "/transaction/new")
api.add_resource(BlockchainMine, "/mine")
api.add_resource(BlockchainAction, "/chain/<int:bookID>", endpoint="chain")

# JSON format for error
@api_bp.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    response = e.get_response()
    response.data = json.dumps({
        "code": e.code,
        "name": e.name,
        "description": e.description,
    })
    response.content_type = "application/json"
    return response
