pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics'
                sh 'flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics'
            }
        }
        
        stage('Build Docker') {
            steps {
                sh 'docker build -t aceest-fitness:${BUILD_NUMBER} .'
            }
        }
        
        stage('Test inside Docker') {
            steps {
                sh 'docker run --rm aceest-fitness:${BUILD_NUMBER} python -m pytest'
            }
        }
    }
}
