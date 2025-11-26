pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Ultimate Docker Test') {
            steps {
                script {
                    echo "🔍 Testing ALL Docker paths..."
                    sh '''
                        echo "=== Testing all Docker paths ==="
                        echo "1. Testing 'docker' command:"
                        docker --version 2>&1 && echo "✅ WORKS: docker" || echo "❌ FAILED: docker"
                        
                        echo "2. Testing '/usr/bin/docker':"
                        /usr/bin/docker --version 2>&1 && echo "✅ WORKS: /usr/bin/docker" || echo "❌ FAILED: /usr/bin/docker"
                        
                        echo "3. Testing '/usr/local/bin/docker':"
                        /usr/local/bin/docker --version 2>&1 && echo "✅ WORKS: /usr/local/bin/docker" || echo "❌ FAILED: /usr/local/bin/docker"
                        
                        echo "=== PATH and permissions ==="
                        echo "PATH: $PATH"
                        echo "User: $(whoami)"
                        echo "Groups: $(groups)"
                        ls -la /var/run/docker.sock
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
                    echo "🐳 Building with working Docker path..."
                    sh '''
                        # Utiliser la méthode qui fonctionne
                        if docker --version >/dev/null 2>&1; then
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        elif /usr/local/bin/docker --version >/dev/null 2>&1; then
                            /usr/local/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        else
                            /usr/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        fi
                        
                        echo "✅ Build completed"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo "📸 For submission, provide:"
            echo "   - Dockerfile"
            echo "   - Jenkinsfile" 
            echo "   - Maven build success screenshots"
            echo "   - Docker installation proof"
        }
    }
}
