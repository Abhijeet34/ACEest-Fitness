import sqlite3
from flask import Blueprint, jsonify, request
from .data import programs
from .db import get_db

bp = Blueprint('api', __name__)


@bp.route("/")
def home():
    return jsonify({
        "message": "Welcome to ACEest Fitness API",
        "endpoints": [
            "/programs",
            "/programs/<name>",
            "/clients (GET, POST)",
            "/workouts (GET, POST)"
        ]
    })


@bp.route("/programs")
def get_programs():
    return jsonify(list(programs.keys()))


@bp.route("/programs/<name>")
def get_program(name):
    if name in programs:
        return jsonify(programs[name])

    for key in programs:
        if name.lower() in key.lower():
            return jsonify(programs[key])

    return jsonify({"error": "Program not found"}), 404


@bp.route("/clients", methods=["GET"])
def get_clients():
    db = get_db()
    clients = db.execute('SELECT * FROM clients').fetchall()
    return jsonify([dict(row) for row in clients])


@bp.route("/clients", methods=["POST"])
def add_client():
    data = request.get_json()
    if not data or "name" not in data:
        return jsonify({"error": "Name is required"}), 400

    db = get_db()
    try:
        db.execute(
            'INSERT INTO clients (name, age, height, weight, program, membership_status)'
            ' VALUES (?, ?, ?, ?, ?, ?)',
            (data['name'], data.get('age'), data.get('height'),
             data.get('weight'), data.get('program'), 'Active')
        )
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "Client already exists"}), 409

    return jsonify({"message": "Client added successfully"}), 201


@bp.route("/workouts", methods=["POST"])
def add_workout():
    data = request.get_json()
    required = ["client_name", "date", "workout_type"]
    if not all(k in data for k in required):
        return jsonify({"error": "Missing required fields"}), 400

    db = get_db()
    db.execute(
        'INSERT INTO workouts (client_name, date, workout_type, duration_min, notes)'
        ' VALUES (?, ?, ?, ?, ?)',
        (data['client_name'], data['date'], data['workout_type'],
         data.get('duration_min', 60), data.get('notes', ''))
    )
    db.commit()
    return jsonify({"message": "Workout logged"}), 201
