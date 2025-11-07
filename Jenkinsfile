pipeline {
    agent any

    environment {
        VIRTUAL_ENV = '.venv'
        DOCKER_IMAGE = 'python-app'  // You can customize the image name here
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Bilaalofficial/slms.git'  // Change to your repository
            }
        }

        stage('Set Up Virtual Environment') {
            steps {
                script {
                    // Set up the virtual environment and install dependencies
                    sh 'python3 -m venv $VIRTUAL_ENV'
                    sh './$VIRTUAL_ENV/bin/pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests using pytest
                    sh './$VIRTUAL_ENV/bin/pytest --maxfail=1 --disable-warnings -v'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                script {
                    // Stop and remove the existing container if it exists
                    sh 'docker ps -q -f name=python-app | xargs -r docker stop'
                    sh 'docker ps -a -q -f name=python-app | xargs -r docker rm'

                    // Run the Docker container
                    sh 'docker run -d -p 80:8000 --name python-app $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up the workspace after the job
            echo 'Pipeline finished!'
        }
    }
}
