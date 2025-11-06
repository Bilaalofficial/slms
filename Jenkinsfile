pipeline {
    agent { docker 'python:3.9' }  // Use the official Python Docker image for the entire pipeline

    environment {
        VIRTUALENV = 'venv'
        IMAGE_NAME = 'staff-leave-management'
        REGISTRY = 'your-docker-repo'  // Replace with your Docker registry if using one
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout the code from GitHub (This assumes Jenkins is set up with the appropriate credentials)
                checkout scm
            }
        }

        stage('Set up Python Environment') {
            steps {
                script {
                    if (fileExists('requirements.txt')) {
                        // Create a virtual environment and install dependencies
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
                    // Run tests (Ensure the Django or relevant test environment is properly set up)
                    sh './$VIRTUALENV/bin/python manage.py test --verbosity=2'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (fileExists('Dockerfile')) {
                        echo "Building Docker image..."
                        // Build the Docker image from the Dockerfile
                        sh 'docker build -t $IMAGE_NAME .'
                    } else {
                        error 'Dockerfile not found!'
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "Running Docker container..."
                    // Stop the existing container (if running) and remove it
                    def containerId = sh(script: 'docker ps -q --filter "name=$IMAGE_NAME"', returnStdout: true).trim()
                    if (containerId) {
                        sh 'docker stop $containerId'  // Stop the existing container
                        sh 'docker rm $containerId'  // Remove the old container
                    }
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
                    def containerId = sh(script: 'docker ps -q --filter "name=$IMAGE_NAME"', returnStdout: true).trim()
                    if (containerId) {
                        sh 'docker stop $containerId'  // Stop the existing container
                        sh 'docker rm $containerId'  // Remove the old container
                    }
                    // Run the new container
                    sh 'docker run -d -p 8000:8000 $IMAGE_NAME'
                }
            }
        }
    }
}
