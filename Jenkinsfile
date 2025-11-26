pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Find Docker') {
            steps {
                script {
                    echo "🔍 Locating Docker installation..."
                    sh '''
                        echo "=== Docker Detection ==="
                        echo "1. Testing command 'docker':"
                        docker --version 2>&1 || echo "   ❌ Not found in PATH"
                        
                        echo "2. Testing '/usr/bin/docker':"
                        /usr/bin/docker --version 2>&1 || echo "   ❌ Not found at /usr/bin/docker"
                        
                        echo "3. Testing '/usr/local/bin/docker':"
                        /usr/local/bin/docker --version 2>&1 || echo "   ❌ Not found at /usr/local/bin/docker"
                        
                        echo "4. Testing '/snap/bin/docker':"
                        /snap/bin/docker --version 2>&1 || echo "   ❌ Not found at /snap/bin/docker"
                        
                        echo "5. Searching for docker..."
                        find / -name docker -type f -executable 2>/dev/null | head -10
                        
                        echo "6. Jenkins user info:"
                        id
                        echo "PATH: $PATH"
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
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh '''
                        # Essayer toutes les méthodes possibles
                        if command -v docker >/dev/null 2>&1; then
                            echo "✅ Using 'docker' from PATH"
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        elif [ -x "/usr/bin/docker" ]; then
                            echo "✅ Using '/usr/bin/docker'"
                            /usr/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        elif [ -x "/usr/local/bin/docker" ]; then
                            echo "✅ Using '/usr/local/bin/docker'"
                            /usr/local/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        elif [ -x "/snap/bin/docker" ]; then
                            echo "✅ Using '/snap/bin/docker'"
                            /snap/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        else
                            echo "❌ ERROR: Cannot find Docker executable"
                            echo "Available executables:"
                            find / -name docker -type f -executable 2>/dev/null
                            exit 1
                        fi
                        
                        # Tag l'image (utiliser la même méthode)
                        if command -v docker >/dev/null 2>&1; then
                            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        elif [ -x "/usr/bin/docker" ]; then
                            /usr/bin/docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        elif [ -x "/usr/local/bin/docker" ]; then
                            /usr/local/bin/docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        elif [ -x "/snap/bin/docker" ]; then
                            /snap/bin/docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        fi
                        
                        echo "✅ Docker image built successfully"
                    '''
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
                        sh '''
                            # Login et push avec la même méthode
                            if command -v docker >/dev/null 2>&1; then
                                echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                                docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                docker push ${DOCKER_IMAGE}:latest
                            elif [ -x "/usr/bin/docker" ]; then
                                echo "${DOCKER_PASSWORD}" | /usr/bin/docker login -u "${DOCKER_USERNAME}" --password-stdin
                                /usr/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                /usr/bin/docker push ${DOCKER_IMAGE}:latest
                            elif [ -x "/usr/local/bin/docker" ]; then
                                echo "${DOCKER_PASSWORD}" | /usr/local/bin/docker login -u "${DOCKER_USERNAME}" --password-stdin
                                /usr/local/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                /usr/local/bin/docker push ${DOCKER_IMAGE}:latest
                            elif [ -x "/snap/bin/docker" ]; then
                                echo "${DOCKER_PASSWORD}" | /snap/bin/docker login -u "${DOCKER_USERNAME}" --password-stdin
                                /snap/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                /snap/bin/docker push ${DOCKER_IMAGE}:latest
                            fi
                            echo "✅ ✅ ✅ SUCCESS: Pushed to Docker Hub!"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE SUCCEEDED!"
            echo "Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
