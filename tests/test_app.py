import pytest
from app import create_app
from app.data import programs

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home(client):
    rv = client.get('/')
    assert rv.status_code == 200
    assert b"Welcome to ACEest Fitness API" in rv.data

def test_get_programs(client):
    rv = client.get('/programs')
    assert rv.status_code == 200
    assert len(rv.json) == len(programs)

def test_get_program_details(client):
    rv = client.get('/programs/Fat Loss (FL)')
    assert rv.status_code == 200
    assert "workout" in rv.json

def test_get_program_fuzzy(client):
    rv = client.get('/programs/fat')
    assert rv.status_code == 200
    assert "workout" in rv.json

def test_program_not_found(client):
    rv = client.get('/programs/unknown')
    assert rv.status_code == 404
