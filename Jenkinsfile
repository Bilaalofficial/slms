pipeline {
    agent any  // Use any available Jenkins agent

    environment {
        VIRTUAL_ENV = '.venv'  // Virtual environment directory
        DOCKER_IMAGE = 'python-app'  // Docker image name
    }

    stages {
        // Stage 1: Checkout Code
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bilaalofficial/slms.git'  // Clone your Git repo
            }
        }

        // Stage 2: Set up Python & Virtual Environment
        stage('Set Up Python and Virtual Environment') {
            steps {
                script {
                    // Install virtual environment and dependencies
                    sh 'python3 -m venv $VIRTUAL_ENV'
                    sh './$VIRTUAL_ENV/bin/pip install --upgrade pip'  // Upgrade pip
                    sh './$VIRTUAL_ENV/bin/pip install -r requirements.txt'  // Install dependencies
                    sh './$VIRTUAL_ENV/bin/pip install pytest'  // Install pytest for running tests
                }
            }
        }

        // Stage 3: Run Django Tests (using pytest)
        stage('Run Tests') {
            steps {
                script {
                    // Run Django tests using pytest
                    sh './$VIRTUAL_ENV/bin/pytest --maxfail=1 --disable-warnings -v'
                }
            }
        }

        // Stage 4: Collect Static Files (if applicable)
        stage('Collect Static Files') {
            steps {
                script {
                    // Collect static files for production (if you use static files)
                    sh './$VIRTUAL_ENV/bin/python manage.py collectstatic --noinput'
                }
            }
        }

        // Stage 5: Build Docker Image (if Dockerfile is present)
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image for deployment
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        // Stage 6: Deploy to Docker
        stage('Deploy to Docker') {
            steps {
                script {
                    // Stop and remove any existing container if it exists
                    sh 'docker ps -q -f name=python-app | xargs -r docker stop'
                    sh 'docker ps -a -q -f name=python-app | xargs -r docker rm'

                    // Run the new Docker container
                    sh 'docker run -d -p 80:8000 --name python-app $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up the workspace after the job finishes
            echo 'Pipeline finished!'
        }
    }
}
