pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'web-app'
        REMOTE_DOCKER_HOST = '3.93.51.143'
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
                    docker.withRegistry('https://registry.hub.docker.com', credentialsId: '0e44a166-b430-4a73-97c4-11d28fc113d6') {
                        def customImage = docker.build(env.DOCKER_IMAGE_NAME)
                    }
                }
            }
        }

        stage('Transfer Docker Image to EC2') {
            steps {
                script {
                    sshagent(['newkey.pem']) {
                        // Copy the Docker image to EC2
                        sh "scp -i newkey.pem -o StrictHostKeyChecking=no \${DOCKER_IMAGE_NAME}.tar.gz ec2-user@${REMOTE_DOCKER_HOST}:/tmp"
                    }
                }
            }
        }

        stage('Load Docker Image on EC2') {
            steps {
                script {
                    // Load the Docker image on EC2
                    sshagent(['newkey.pem']) {
                        sh "ssh -i newkey.pem ec2-user@${REMOTE_DOCKER_HOST} 'docker load -i /tmp/${DOCKER_IMAGE_NAME}.tar.gz'"
                    }
                }
            }
        }

        stage('Run Docker Container on EC2') {
            steps {
                script {
                    // Run the Docker container on EC2
                    sshagent(['newkey.pem']) {
                        sh "ssh -i newkey.pem ec2-user@${REMOTE_DOCKER_HOST} 'docker run -d -p 3000:3000 ${DOCKER_IMAGE_NAME}'"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Docker image built and container is running successfully on EC2!"
        }

        failure {
            echo "Failed to build Docker image or run the container on EC2."
        }
    }
}
