pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/repositories/madhunath'
        DOCKER_IMAGE_NAME = 'web-app'
        DOCKER_IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker registry
                    sh "docker login -u <madhunath> -p <Madhunath@007> ${DOCKER_REGISTRY_URL}"

                    // Push Docker image
                    sh "docker push ${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            // Cleanup: Logout from Docker registry
            sh "docker logout ${DOCKER_REGISTRY_URL}"
        }
    }
}
