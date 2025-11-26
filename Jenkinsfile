pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Debug Environment') {
            steps {
                script {
                    echo "🔍 Debugging environment..."
                    sh '''
                        echo "=== ENVIRONMENT INFO ==="
                        echo "User: $(whoami)"
                        echo "Working directory: $(pwd)"
                        echo "PATH: $PATH"
                        echo "=== DOCKER INFO ==="
                        sudo docker --version
                        echo "✅ Docker is available via sudo"
                        echo "=== FILES ==="
                        ls -la
                        echo "=== DOCKERFILE ==="
                        cat Dockerfile
                    '''
                }
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
                    echo "🐳 Building Docker image with SUDO..."
                    sh """
                        sudo docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        sudo docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Docker image built successfully"
                        
                        # Afficher les images
                        sudo docker images | grep ${DOCKER_IMAGE} || echo "No images found yet"
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "📤 Pushing to Docker Hub with SUDO..."
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            echo \"\${DOCKER_PASSWORD}\" | sudo docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            sudo docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            sudo docker push ${DOCKER_IMAGE}:latest
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
            echo "📸 Take final screenshots for submission!"
        }
        failure {
            echo "❌ Pipeline failed - check logs above"
        }
    }
}
