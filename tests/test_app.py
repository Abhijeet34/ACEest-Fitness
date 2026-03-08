from app.data import programs

# --- Programs ---

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

# --- Clients ---

def test_get_clients_empty(client):
    rv = client.get('/clients')
    assert rv.status_code == 200
    assert rv.json == []

def test_add_client(client):
    rv = client.post('/clients', json={"name": "John Doe", "age": 30, "program": "Fat Loss (FL)"})
    assert rv.status_code == 201
    rv = client.get('/clients')
    assert len(rv.json) == 1
    assert rv.json[0]['name'] == "John Doe"

def test_add_client_duplicate(client):
    client.post('/clients', json={"name": "John Doe"})
    rv = client.post('/clients', json={"name": "John Doe"})
    assert rv.status_code == 409

def test_add_client_missing_name(client):
    rv = client.post('/clients', json={"age": 25})
    assert rv.status_code == 400

# --- Workouts ---

def test_add_workout(client):
    client.post('/clients', json={"name": "Jane"})
    rv = client.post('/workouts', json={
        "client_name": "Jane",
        "date": "2026-03-08",
        "workout_type": "Strength",
        "duration_min": 60
    })
    assert rv.status_code == 201

def test_add_workout_missing_fields(client):
    rv = client.post('/workouts', json={"client_name": "Jane"})
    assert rv.status_code == 400
