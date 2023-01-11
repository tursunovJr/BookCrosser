from app import create_app
from os import getenv

app = create_app(getenv("FLASK_ENV", "development"))
if __name__ == "__main__":
    app.run()