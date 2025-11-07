pipeline {
    agent any

    environment {
        VIRTUAL_ENV = '.venv'
        DOCKER_IMAGE = 'python-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Bilaalofficial/slms.git'
            }
        }

        stage('Set Up Virtual Environment') {
            steps {
                script {
                    sh 'python3 -m venv $VIRTUAL_ENV'
                    sh './$VIRTUAL_ENV/bin/pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh './$VIRTUAL_ENV/bin/pytest --maxfail=1 --disable-warnings -v'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                script {
                    sh 'docker ps -q -f name=python-app | xargs -r docker stop'
                    sh 'docker ps -a -q -f name=python-app | xargs -r docker rm'
                    sh 'docker run -d -p 80:8000 --name python-app-${BUILD_NUMBER} $DOCKER_IMAGE:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
            echo 'Pipeline finished!'
        }
    }
}
