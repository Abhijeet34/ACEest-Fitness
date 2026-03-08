from flask import Blueprint, jsonify
from .data import programs

bp = Blueprint('api', __name__)

@bp.route("/")
def home():
    return jsonify({"message": "Welcome to ACEest Fitness API", "endpoints": ["/programs", "/programs/<name>"]})

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
