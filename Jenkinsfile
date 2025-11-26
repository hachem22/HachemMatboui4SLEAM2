pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Verify Docker Running') {
            steps {
                script {
                    echo "🔍 Verifying Docker service..."
                    sh '''
                        # Vérifier que Docker est en cours d'exécution
                        docker --version
                        echo "✅ Docker is running!"
                        docker run --rm hello-world
                        echo "✅ Docker containers work!"
                    '''
                }
            }
        }
        
        stage('Build App') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Docker image built"
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
                            echo "✅ ✅ ✅ SUCCESS: Image pushed to Docker Hub!"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE COMPLETED SUCCESSFULLY!"
        }
    }
}
