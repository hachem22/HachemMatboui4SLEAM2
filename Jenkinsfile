pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Verify Docker') {
            steps {
                script {
                    echo "✅ Checking Docker installation..."
                    sh '''
                        # Utiliser le chemin complet
                        /usr/bin/docker --version
                        echo "✅ Docker is ready!"
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build App') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh """
                        /usr/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        /usr/bin/docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Docker image built successfully"
                        
                        # Afficher les images
                        /usr/bin/docker images | grep ${DOCKER_IMAGE} || echo "No images found yet"
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
                            echo \"\${DOCKER_PASSWORD}\" | /usr/bin/docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            /usr/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            /usr/bin/docker push ${DOCKER_IMAGE}:latest
                            echo "✅ ✅ ✅ SUCCESS: Image ${DOCKER_IMAGE}:${DOCKER_TAG} pushed to Docker Hub!"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE COMPLETED SUCCESSFULLY!"
            echo "📦 Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
        }
        failure {
            echo "❌ Pipeline failed - check logs above"
        }
    }
}
