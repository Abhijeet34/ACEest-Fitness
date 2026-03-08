import os
import tempfile
import pytest
from app import create_app
from app.db import init_db

@pytest.fixture
def client():
    db_fd, db_path = tempfile.mkstemp()
    app = create_app({
        'TESTING': True,
        'DATABASE': db_path,
    })

    with app.app_context():
        init_db()

    with app.test_client() as c:
        yield c

    os.close(db_fd)
    os.unlink(db_path)
