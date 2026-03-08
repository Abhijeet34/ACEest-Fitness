# ACEest Fitness & Gym - DevOps Pipeline

## Architecture

```
Developer Machine
  |- Git Push --------> GitHub Repo
                            |
                            |--> GitHub Actions (CI/CD)
                            |       |- Install Dependencies
                            |       |- Lint (flake8)
                            |       |- Build Docker Image
                            |       |- Run Pytest inside Docker
                            |       |- Push to GHCR
                            |
                            |--> Jenkins (Build Gate)
                                    |- Checkout SCM
                                    |- Install Dependencies
                                    |- Lint
                                    |- Build Docker
                                    |- Test in Docker
```

## Project Structure

```
.
|-- app/
|   |-- __init__.py   # Application factory (create_app)
|   |-- routes.py     # Flask Blueprint with API routes
|   |-- data.py       # Fitness program data
|-- tests/
|   |-- test_app.py   # Pytest test suite
|-- jenkins/
|   |-- Dockerfile.jenkins  # Custom Jenkins with Docker+Python
|   |-- docker-compose.yml  # Jenkins local server
|-- .github/workflows/
|   |-- main.yml      # GitHub Actions CI/CD pipeline
|-- Dockerfile        # Application Docker image
|-- docker-compose.yml # Application deployment
|-- Jenkinsfile       # Declarative Jenkins pipeline
|-- deploy.sh         # Manual deployment script
|-- run.py            # Application entry point
|-- requirements.txt
```

## Prerequisites

- Python 3.9+
- Docker & Docker Compose
- Git

## 1. Local Development

```bash
git clone <repo-url> && cd ACEest-Fitness
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python run.py
```

**API Endpoints:**
- `GET /` - Welcome message
- `GET /programs` - List all programs
- `GET /programs/<name>` - Get program details (supports fuzzy name match)

## 2. Running Tests

```bash
python -m pytest
```

Expected output: `5 passed`

## 3. Docker Deployment

### Build and run with Docker Compose (recommended):
```bash
docker compose up --build -d
```
App available at `http://localhost:5000`.

### Manual Docker Commands:
```bash
docker build -t aceest-fitness:latest .
docker run -d -p 5000:5000 --name aceest-app aceest-fitness:latest
```

### Automated deployment script:
```bash
./deploy.sh
```

## 4. Jenkins Setup (Local)

1. Start the Jenkins server:
   ```bash
   cd jenkins && docker compose up -d
   ```
2. Open `http://localhost:8080` in a browser.
3. Get initial admin password:
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
4. Install suggested plugins.
5. Create a new **Pipeline** job.
6. Under **Pipeline Definition**, select **Pipeline script from SCM**.
7. Set SCM to **Git** and provide the repository URL.
8. The `Jenkinsfile` in the root of the repo defines the pipeline stages:
   - **Checkout** -> **Install Dependencies** -> **Lint** -> **Build Docker** -> **Test in Docker**

## 5. GitHub Actions

The `.github/workflows/main.yml` pipeline triggers on every `push` or `pull_request` to `main`.

Stages:
1. `Install dependencies`: Sets up Python 3.9, installs `requirements.txt`.
2. `Lint with flake8`: Catches syntax errors and undefined names.
3. `Build Docker image`: Builds the image to validate the `Dockerfile`.
4. `Run tests inside Docker`: Runs `pytest` inside the container.
5. `Push to GHCR` (requires `GITHUB_TOKEN` secret): Pushes the image to GitHub Container Registry.
