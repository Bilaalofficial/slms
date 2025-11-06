pipeline {
    agent any
    parameters {
        string(name: 'AWS_INSTANCE_IP', defaultValue: '', description: 'Enter the Public IP of your AWS EC2 instance')
    }

    environment {
        DOCKER_IMAGE = 'bilaaaall/staff-leave-management'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bilaalofficial/slms.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE} .
                    """
                }
            }
        }

        stage('Deploy to Local Docker') {
            steps {
                script {
                    sh """
                    docker ps -q -f name=python-app | xargs -r docker stop
                    docker ps -a -q -f name=python-app | xargs -r docker rm
                    """
                    sh """
                    docker run -d -p 80:8000 --name python-app ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy to AWS EC2 (SSH via Jenkins Credential)') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-credentials', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'AWS_USER')]) {
                        // Check if Docker is installed on EC2
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_KEY_PATH \$AWS_USER@${params.AWS_INSTANCE_IP} \
                            'docker --version || (echo "Docker is not installed" && exit 1)'
                        """
                        // Stop and remove existing container on EC2
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_KEY_PATH \$AWS_USER@${params.AWS_INSTANCE_IP} \
                            'docker ps -q -f name=python-app | xargs -r docker stop && \
                            docker ps -a -q -f name=python-app | xargs -r docker rm'
                        """
                        // Pull the Docker image from Docker Hub and run it on EC2
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_KEY_PATH \$AWS_USER@${params.AWS_INSTANCE_IP} \
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
                    def response = sh(script: "curl -s http://${params.AWS_INSTANCE_IP}", returnStdout: true).trim()
                    if (response.contains('Welcome to the Python App')) {
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
            echo 'Pipeline finished!'
        }
    }
}
