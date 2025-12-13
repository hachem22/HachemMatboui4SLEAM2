pipeline {
    agent any

    tools {
        maven 'Maven-3.6'
        jdk 'JDK-17'
    }

    environment {
        GITHUB_CREDENTIALS = 'github-credentials'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        DOCKERHUB_USERNAME = 'lhech24'
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/springboot-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '===== Récupération du code depuis GitHub ====='
                git branch: 'main',
                    credentialsId: "${GITHUB_CREDENTIALS}",
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git'
            }
        }

        stage('Build Maven') {
            steps {
                echo '===== Build Maven : clean + package (skip tests) ====='
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '===== Construction de l\'image Docker ====='
                script {
                    // Build the Docker image
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '===== Push de l\'image sur Docker Hub ====='
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKERHUB_CREDENTIALS}") {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }


    post {
        success {
            echo '===== ✅ Pipeline complété avec succès ! ====='
            sh '''
                echo "Application accessible via:"
                minikube service springboot-service --url
            '''
        }
        failure {
            echo '===== ❌ Pipeline échoué ! ====='
        }
        always {
            echo '===== Nettoyage des images Docker locales ====='
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
            sh "docker rmi ${IMAGE_NAME}:latest || true"
        }
    }
}