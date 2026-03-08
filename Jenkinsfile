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
        
        stage('Test') {
            steps {
                sh 'python -m pytest'
            }
        }
        
        stage('Build Docker') {
            steps {
                sh 'docker build -t aceest-fitness:${BUILD_NUMBER} .'
            }
        }
    }
}
