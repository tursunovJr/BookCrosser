from flask import Blueprint, json
from flask_restful import Api
from werkzeug.exceptions import HTTPException
from api.user.controllers import UserRegister, UserAuth, UserLogout

from api.book.controllers import Books


api_users_bp = Blueprint("api", __name__)
api_users = Api(api_users_bp)

# Add resources
api_users.add_resource(UserRegister, "/register")
api_users.add_resource(UserAuth, "/auth")
api_users.add_resource(UserLogout, "/logout")

api_users.add_resource(Books, "/book")
api_users.add_resource(Books, "/book/<uuid:book_uuid>",
                        endpoint="book_info")


# JSON format for error
@api_users_bp.errorhandler(HTTPException)
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
