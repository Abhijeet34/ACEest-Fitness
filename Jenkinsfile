pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker') {
            steps {
                sh 'docker build -t aceest-fitness:${BUILD_NUMBER} .'
            }
        }

        stage('Lint inside Docker') {
            steps {
                sh "docker run --rm aceest-fitness:${BUILD_NUMBER} flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics"
                sh "docker run --rm aceest-fitness:${BUILD_NUMBER} flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics"
            }
        }
        
        stage('Test inside Docker') {
            steps {
                sh 'docker run --rm aceest-fitness:${BUILD_NUMBER} python -m pytest'
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Stop any existing containers using port 5001 or named aceest-app
                    sh "docker rm -f aceest-app || true"
                    sh "docker rm -f aceest-fitness-aceest-app-1 || true"
                    
                    // Deploy new container
                    sh "docker run -d -p 5001:5000 --name aceest-app --restart always aceest-fitness:${BUILD_NUMBER}"
                }
            }
        }
    }
}
