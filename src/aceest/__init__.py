import os
from flask import Flask
from .routes import bp
from . import db


def create_app(test_config=None):
    # Set instance path to project root 'instance' folder, not inside src
    instance_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'instance'))
    app = Flask(__name__, instance_path=instance_path, instance_relative_config=True)

    if test_config is None:
        # Load configuration from config.py (if available) or defaults
        try:
            from config import Config
            app.config.from_object(Config)
        except ImportError:
            # Fallback defaults
            app.config.from_mapping(
                SECRET_KEY='dev',
                DATABASE=os.path.join(app.instance_path, 'aceest_fitness.sqlite'),
            )
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    db.init_app(app)
    app.register_blueprint(bp)

    # Auto-initialize DB tables on startup
    with app.app_context():
        db.init_db()

    return app
