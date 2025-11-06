pipeline {
    agent { docker 'python:3.9' }

    environment {
        VIRTUALENV = 'venv'
        IMAGE_NAME = 'staff-leave-management'
        REGISTRY = 'bilaaaall/staff-leave-management'  // Replace with your Docker registry
        EC2_IP = '13.232.91.247'  // Your EC2 public IP address
        EC2_USER = 'ubuntu'  // EC2 username
        SSH_KEY_PATH = '/home/ubuntu/my-key.pem'  // Path to your private key
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Set up Python Environment') {
            steps {
                script {
                    if (fileExists('requirements.txt')) {
                        sh 'python3 -m venv $VIRTUALENV'
                        sh './$VIRTUALENV/bin/pip install -r requirements.txt'
                    } else {
                        error 'requirements.txt not found!'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh './$VIRTUALENV/bin/python manage.py test --verbosity=2'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (fileExists('Dockerfile')) {
                        echo "Building Docker image..."
                        sh 'docker build -t $IMAGE_NAME .'
                    } else {
                        error 'Dockerfile not found!'
                    }
                }
            }
        }

        stage('Push Docker Image to Registry') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Pushing Docker image to registry..."
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker tag $IMAGE_NAME $REGISTRY/$IMAGE_NAME:latest'
                    sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    echo "Deploying Docker container to AWS EC2..."
                    sh """
                        ssh -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_IP} <<EOF
                        echo "Stopping and removing old container..."
                        docker stop ${IMAGE_NAME} || true
                        docker rm ${IMAGE_NAME} || true

                        echo "Pulling the latest Docker image..."
                        docker pull ${REGISTRY}/${IMAGE_NAME}:latest

                        echo "Running the Docker container..."
                        docker run -d -p 8000:8000 --name ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}:latest
                        EOF
                    """
                }
            }
        }
    }
}
