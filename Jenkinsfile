pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "TONDOCKERUSER/ton-repo"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/TONUSER/TONREPO.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "=== BUILD DOCKER IMAGE ==="
                sh 'docker --version'
                sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                sh 'docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "=== PUSH IMAGE TO DOCKER HUB ==="
                withCredentials([usernamePassword(credentialsId: "${env.DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                    sh 'docker push ${DOCKER_IMAGE}:latest'
                }
            }
        }
    }

    post {
        success {
            echo "Build terminé avec succès"
        }
        failure {
            echo "Build échoué"
        }
    }
}
