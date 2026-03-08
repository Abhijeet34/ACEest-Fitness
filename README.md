# ACEest Fitness & Gym - DevOps Pipeline

## Overview
This repository contains the source code and DevOps configuration for the ACEest Fitness & Gym application. The application provides fitness programs (Workout and Diet plans) via a RESTful API.

## Architecture
- **Application**: Python Flask
- **Containerization**: Docker
- **CI/CD**: GitHub Actions (Cloud) & Jenkins (On-Premise simulation)
- **Testing**: Pytest

## Local Setup

### Prerequisites
- Python 3.9+
- Docker

### Installation
1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd ACEest-Fitness
   ```
2. Create virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

### Running the Application
```bash
python app.py
```
The API will be available at `http://localhost:5000`.
- List Programs: `http://localhost:5000/programs`
- Get Program: `http://localhost:5000/programs/Fat Loss (FL)`

### Running Tests
To execute the unit test suite:
```bash
python -m pytest
```

## Docker Instructions
1. Build the image:
   ```bash
   docker build -t aceest-fitness:latest .
   ```
2. Run the container:
   ```bash
   docker run -p 5000:5000 aceest-fitness:latest
   ```

## CI/CD Pipeline

### GitHub Actions
The `.github/workflows/main.yml` pipeline runs on every push to `main`:
1. **Build & Test**: Sets up Python, installs dependencies, runs `pytest`.
2. **Docker Build**: Builds the Docker image to ensure containerization integrity.

### Jenkins
The `Jenkinsfile` defines a declarative pipeline:
1. **Checkout**: Pulls code from SCM.
2. **Install Dependencies**: Installs Python requirements.
3. **Test**: Runs the Pytest suite.
4. **Build Docker**: Builds the Docker image tagged with the build number.
