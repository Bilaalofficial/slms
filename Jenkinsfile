pipeline {
    agent any

    environment {
        VIRTUALENV = 'venv'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set up Python Environment') {
            steps {
                script {
                    sh 'python3 -m venv $VIRTUALENV'
                    sh './$VIRTUALENV/bin/pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh './$VIRTUALENV/bin/python manage.py test'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying to production..."
                    // Add your deployment commands here (e.g., Docker, AWS, etc.)
                }
            }
        }
    }
}
