from flask import Blueprint, json
from flask_restful import Api
from werkzeug.exceptions import HTTPException
from api.auth.controllers import UserInfo, User, UserFavouriteBook, UserFavouriteBookInfo
from api.book.controllers import Books, BooksActions, BookGenres
from api.genre.controllers import Genre, GenresActions
from api.blockchain.controllers import BlockchainTransaction, BlockchainMine, BlockchainAction


api_bp = Blueprint("api", __name__)
api = Api(api_bp)

# Add resources

# Auth API Module
api.add_resource(User, "/user")
api.add_resource(UserInfo, "/user/<string:email>", endpoint="email")
api.add_resource(UserFavouriteBook, "/addFav")
api.add_resource(UserFavouriteBookInfo, "/favBook/<string:email>")
api.add_resource(UserFavouriteBookInfo, "/favBook/<string:email>/<string:uuid>", endpoint="fav_book")


# Book API Module
api.add_resource(Books, "/book/")
api.add_resource(BooksActions, "/book/<uuid:book_uuid>", endpoint="book_info")
api.add_resource(BookGenres, "/book/genre/<uuid:genre_uuid>")


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
