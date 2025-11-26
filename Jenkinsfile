pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Check Prerequisites') {
            steps {
                script {
                    echo "🔍 Checking prerequisites..."
                    sh '''
                        # Vérifier si Docker est installé
                        if ! command -v docker &> /dev/null; then
                            echo "❌ ERROR: Docker is not installed!"
                            exit 1
                        fi
                        
                        # Vérifier la version de Docker
                        docker --version
                        echo "✅ Docker is available"
                        
                        # Vérifier Maven
                        mvn --version
                        echo "✅ Maven is available"
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }
        
        stage('Build App') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh """
                        docker images
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        docker images
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "📤 Pushing to Docker Hub..."
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            echo \"\${DOCKER_PASSWORD}\" | docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            echo "✅ Successfully pushed ${DOCKER_IMAGE}:${DOCKER_TAG} to Docker Hub!"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 Pipeline succeeded!"
            echo "Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
