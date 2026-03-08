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
                    sh "docker stop aceest-app || true"
                    sh "docker rm aceest-app || true"
                    sh "docker run -d -p 5001:5000 --name aceest-app --restart always aceest-fitness:${BUILD_NUMBER}"
                }
            }
        }
    }
}
