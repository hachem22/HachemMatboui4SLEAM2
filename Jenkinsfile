pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Verify Docker Access') {
            steps {
                script {
                    echo "🔍 Verifying Docker access..."
                    sh '''
                        sudo -u jenkins /usr/bin/docker --version
                        echo "✅ Docker version check passed"
                        sudo -u jenkins /usr/bin/docker images
                        echo "✅ Docker access verified successfully!"
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
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh """
                        sudo -u jenkins /usr/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        sudo -u jenkins /usr/bin/docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Docker image built successfully"
                        
                        # Afficher les images créées
                        sudo -u jenkins /usr/bin/docker images | grep ${DOCKER_IMAGE} || echo "No images found yet"
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
                            echo \"\${DOCKER_PASSWORD}\" | sudo -u jenkins /usr/bin/docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            sudo -u jenkins /usr/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            sudo -u jenkins /usr/bin/docker push ${DOCKER_IMAGE}:latest
                            echo "✅ ✅ ✅ SUCCESS: Pushed ${DOCKER_IMAGE}:${DOCKER_TAG} to Docker Hub!"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE COMPLETED SUCCESSFULLY!"
            echo "Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
            echo "📸 Screenshots ready for submission!"
        }
        failure {
            echo "❌ Pipeline failed - check logs above"
        }
    }
}
