pipeline {
    agent any

    environment {
        VIRTUALENV = 'venv'
        IMAGE_NAME = 'staff-leave-management'
        REGISTRY = 'your-docker-repo'  // Replace with your Docker registry if using one
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Python 3') {
            steps {
                script {
                    // Install Python 3 on the Jenkins agent
                    sh 'sudo apt-get update'
                    sh 'sudo apt-get install -y python3 python3-pip python3-venv'
                }
            }
        }

        stage('Set up Python Environment') {
            steps {
                script {
                    // Create a virtual environment and install dependencies
                    sh 'python3 -m venv $VIRTUALENV'
                    sh './$VIRTUALENV/bin/pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests
                    sh './$VIRTUALENV/bin/python manage.py test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Build the Docker image from the Dockerfile
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "Running Docker container..."
                    // Run the Docker container
                    sh 'docker run -d -p 8000:8000 $IMAGE_NAME'
                }
            }
        }

        stage('Push Docker Image to Registry') {
            when {
                branch 'main' // Push the image only when on the main branch
            }
            steps {
                script {
                    echo "Pushing Docker image to registry..."
                    // Log in to the Docker registry (for Docker Hub, use your Docker Hub credentials)
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    
                    // Tag the Docker image with the latest tag
                    sh 'docker tag $IMAGE_NAME $REGISTRY/$IMAGE_NAME:latest'
                    
                    // Push the Docker image to your registry
                    sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying Docker container..."
                    // Optionally, restart the container (if necessary) or deploy it to a remote server
                    sh 'docker stop $(docker ps -q --filter "name=$IMAGE_NAME")'  // Stop the existing container
                    sh 'docker rm $(docker ps -a -q --filter "name=$IMAGE_NAME")'  // Remove the old container
                    sh 'docker run -d -p 8000:8000 $IMAGE_NAME'  // Run the new container
                }
            }
        }
    }
}
