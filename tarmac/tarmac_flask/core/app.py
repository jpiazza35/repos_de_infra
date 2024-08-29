from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from core.route import *

app = Flask(__name__)

app.config.from_envvar('TARMAC_FLASK_SETTINGS')
db = SQLAlchemy(app)

# register routes
app.register_blueprint(routes)


@app.cli.command('initdb')
def initdb_command():

    # important to import all models so the db get's created
    import core.model as models    # DON'T COMMENT
    models = models                # DON'T COMMENT

    db.create_all()
    print('Database initialized!')
