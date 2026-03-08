# ACEest Fitness & Gym - DevOps Pipeline

## Architecture

```
Developer Machine
│
└── Git Push ────────────────► GitHub Repository
                                │
                                ├── GitHub Actions (CI/CD)
                                │   ├── Install Dependencies
                                │   ├── Lint (flake8)
                                │   ├── Build Docker Image
                                │   ├── Run Pytest inside Docker
                                │   └── Push Image to GHCR
                                │
                                └── Jenkins (Build Gate)
                                    ├── Checkout SCM
                                    ├── Install Dependencies
                                    ├── Lint
                                    ├── Build Docker
                                    └── Test in Docker
```

## Project Structure

```
.
├── src/
│   └── aceest/
│       ├── __init__.py        # Application factory (create_app)
│       ├── routes.py          # Flask Blueprint with API routes
│       ├── data.py            # Fitness program data (static plans)
│       └── db.py              # SQLite initialization and connection helpers
│
├── scripts/
│   └── deploy.sh              # Deployment automation script
│
├── infrastructure/
│   └── jenkins/               # Local Jenkins server configuration
│
├── docs/
│   └── reports/               # Test reports
│
├── tests/                     # Pytest suite
│
├── .github/
│   └── workflows/             # GitHub Actions CI/CD
│
├── config.py                  # Application configuration
├── docker-compose.yml         # Main application deployment
├── Dockerfile                 # Production Docker image
├── Jenkinsfile                # CI/CD Pipeline definition
├── Makefile                   # Developer commands
├── pyproject.toml             # Python project configuration
├── run.py                     # Local development entry point
└── requirements.txt           # Dependencies (legacy/docker)
```

## Prerequisites

- Python 3.9+
- Docker & Docker Compose
- Git
- Make (optional but recommended)

## 1. Local Development (Standard Workflow)

1. **Install Dependencies:**
   ```bash
   python -m venv .venv && source .venv/bin/activate
   make install
   ```
   This installs the project in editable mode (`pip install -e .`).

2. **Run Application:**
   ```bash
   python run.py
   ```

   **API Endpoints:**
   - `GET /` - Welcome message
   - `GET /programs` - List programs
   - `GET /clients` - List clients
   - `POST /clients` - Add client
   - `POST /workouts` - Add workout

3. **Run Tests:**
   ```bash
   make test
   ```
   or `pytest` directly.

## 2. Docker Deployment

### Using Make (Recommended)
```bash
make build
make deploy
```

### Using Docker Compose Directly
```bash
docker compose up --build -d
```
App available at `http://localhost:5001`.

## 3. Jenkins CI/CD Setup

To fulfill the requirement for a Jenkins build server, we have containerized the entire Jenkins environment. This ensures a consistent, reproducible build server setup without polluting your local machine.

1. **Start Jenkins:**
   ```bash
   cd infrastructure/jenkins
   docker compose up -d
   ```
2. **Access Jenkins:**
   Open `http://localhost:8080`.
3. **Unlock Jenkins:**
   Get the initial admin password:
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
4. **Create Pipeline:**
   - New Item -> Pipeline -> Name: `ACEest-CI`
   - Definition: `Pipeline script from SCM`
   - SCM: `Git` -> Repository URL: `file:///absolute/path/to/ACEest-Fitness` (or your GitHub URL)
   - Script Path: `Jenkinsfile`
5. **Run Build:**
   Click "Build Now". The pipeline will:
   - Checkout code
   - Install dependencies
   - Lint code
   - Build Docker image
   - Run tests inside the container

## 4. GitHub Actions

The `.github/workflows/main.yml` file defines the CI pipeline for GitHub. It runs on every push to `main` and performs:
- Linting (flake8)
- Unit Testing
- Docker Build
- Image Push (to GHCR)
