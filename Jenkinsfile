pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Madhunath/Jiitak-inc.git'
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'fb8f184e-a702-45af-b9a8-a64d0f7955f5', toolName: 'docker') {
                        
                        sh "docker build -t web-app -f Dockerfile ."
                        sh "docker tag  web-app madhunath/web-app:latest"
                        sh "docker push madhunath/web-app:latest"
                    }
                }
            }
        }
    
        stage('Docker Deploy to Container') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'fb8f184e-a702-45af-b9a8-a64d0f7955f5', toolName: 'docker') {
                    sh "docker run -d -p 3000:3000 web-app:latest" }
                }                
            }
        }
    }
}
