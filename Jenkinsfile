pipeline {
    agent any
    parameters {
        string(name: 'AWS_INSTANCE_IP', defaultValue: '', description: 'Enter the Public IP of your AWS EC2 instance')
    }

    environment {
        // Docker image name on DockerHub or local registry
        DOCKER_IMAGE = 'bilaaaall/staff-leave-management'  // Replace with your Docker image name
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the GitHub repository
                git branch: 'main', url: 'https://github.com/Bilaalofficial/slms.git'  // Replace with your repo URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for the Python app
                    sh """
                    docker build -t ${DOCKER_IMAGE} .
                    """
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                script {
                    // Stop and remove any existing container named 'python-app'
                    sh """
                    docker ps -q -f name=python-app | xargs -r docker stop
                    docker ps -a -q -f name=python-app | xargs -r docker rm
                    """
                    
                    // Run the Docker container for the Python app
                    sh """
                    docker run -d -p 80:8000 --name python-app ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy to AWS EC2 (SSH via Jenkins Credential)') {
            steps {
                script {
                    // Using SSH credentials in Jenkins to deploy to EC2 instance
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-credentials', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'AWS_USER')]) {
                        // SSH commands to stop and remove any existing 'python-app' container on the EC2 instance
                        sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ${AWS_USER}@${params.AWS_INSTANCE_IP} \
                        'docker ps -q -f name=python-app | xargs -r docker stop && \
                        docker ps -a -q -f name=python-app | xargs -r docker rm'
                        """

                        // Pull the Docker image and run a new container on the EC2 instance
                        sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ${AWS_USER}@${params.AWS_INSTANCE_IP} \
                        'docker pull ${DOCKER_IMAGE} && \
                        docker run -d -p 80:8000 --name python-app ${DOCKER_IMAGE}'
                        """
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Test if the app is running by accessing the EC2 public IP
                    def response = sh(script: "curl -s http://${params.AWS_INSTANCE_IP}", returnStdout: true).trim()
                    
                    // Check if the container is responding with "Welcome to the Python App" or similar in the response
                    if (response.contains('Welcome to the Python App')) {  // Replace this with a string specific to your app
                        echo "Python App is running successfully!"
                    } else {
                        error "Deployment failed. Python App is not running."
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up any resources if needed
            echo 'Pipeline finished!'
        }
    }
}
