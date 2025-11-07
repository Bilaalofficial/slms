pipeline {
    agent any

    environment {
        VIRTUAL_ENV = '.venv'
        DOCKER_IMAGE = 'python-app'

        DJANGO_SETTINGS_MODULE = 'slms.slms.settings'
        PYTHONPATH = "${WORKSPACE}/staffleave"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bilaalofficial/slms.git'
            }
        }

        stage('Set Up Python and Virtual Environment') {
            steps {
                sh '''
                    python3 -m venv $VIRTUAL_ENV
                    ./$VIRTUAL_ENV/bin/pip install --upgrade pip
                    ./$VIRTUAL_ENV/bin/pip install -r requirements.txt
                    ./$VIRTUAL_ENV/bin/pip install pytest pytest-django
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    set -e

                    export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
                    export PYTHONPATH=$PYTHONPATH

                    echo "DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE"
                    echo "PYTHONPATH=$PYTHONPATH"

                    find . -name settings.py -print

                    ./$VIRTUAL_ENV/bin/pytest tests/ \
                        --ds=slms.slms.settings \
                        --maxfail=1 \
                        --disable-warnings \
                        -v
                '''
            }
        }

        stage('Build Docker Image') {
            when { expression { fileExists('Dockerfile') } }
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Deploy to Docker') {
            when { expression { fileExists('Dockerfile') } }
            steps {
                sh '''
                    docker ps -q -f name=python-app | xargs -r docker stop
                    docker ps -a -q -f name=python-app | xargs -r docker rm
                    docker run -d -p 80:8000 --name python-app $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
            echo "Pipeline finished!"
        }
    }
}
