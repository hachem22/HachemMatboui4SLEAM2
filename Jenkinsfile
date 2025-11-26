pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Find Docker Anywhere') {
            steps {
                script {
                    echo "🔍 Ultimate Docker detection..."
                    sh '''
                        echo "=== ULTIMATE DOCKER SEARCH ==="
                        
                        # Méthode 1: Command standard
                        echo "1. Testing 'docker' command:"
                        docker --version 2>&1 && echo "   ✅ FOUND: docker" || echo "   ❌ Not found"
                        
                        # Méthode 2: Snap
                        echo "2. Testing Snap Docker:"
                        /snap/bin/docker --version 2>&1 && echo "   ✅ FOUND: /snap/bin/docker" || echo "   ❌ Not found"
                        
                        # Méthode 3: Standard paths
                        echo "3. Testing standard paths:"
                        [ -x "/usr/bin/docker" ] && echo "   ✅ FOUND: /usr/bin/docker" || echo "   ❌ Not /usr/bin/docker"
                        [ -x "/usr/local/bin/docker" ] && echo "   ✅ FOUND: /usr/local/bin/docker" || echo "   ❌ Not /usr/local/bin/docker"
                        
                        # Méthode 4: Find all docker executables
                        echo "4. ALL DOCKER EXECUTABLES:"
                        find / -name docker -type f -executable 2>/dev/null | while read path; do
                            echo "   📍 $path"
                            $path --version 2>&1 | head -1
                        done
                        
                        echo "=== JENKINS USER INFO ==="
                        echo "User: $(whoami)"
                        echo "Groups: $(groups)"
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
                    echo "🐳 Building with detected Docker..."
                    sh '''
                        # Essayer toutes les méthodes possibles
                        DOCKER_CMD=""
                        
                        if command -v docker >/dev/null 2>&1; then
                            DOCKER_CMD="docker"
                            echo "✅ Using: docker (from PATH)"
                        elif [ -x "/snap/bin/docker" ]; then
                            DOCKER_CMD="/snap/bin/docker"
                            echo "✅ Using: /snap/bin/docker"
                        elif [ -x "/usr/bin/docker" ]; then
                            DOCKER_CMD="/usr/bin/docker"
                            echo "✅ Using: /usr/bin/docker"
                        elif [ -x "/usr/local/bin/docker" ]; then
                            DOCKER_CMD="/usr/local/bin/docker"
                            echo "✅ Using: /usr/local/bin/docker"
                        else
                            echo "❌ CRITICAL: No Docker executable found!"
                            echo "=== INSTALL DOCKER ON JENKINS SERVER ==="
                            echo "Run: sudo apt install -y docker.io"
                            echo "Or: sudo snap install docker"
                            exit 1
                        fi
                        
                        # Construire l'image
                        $DOCKER_CMD build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        $DOCKER_CMD tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Docker image built successfully!"
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
                            # Utiliser la même méthode détectée
                            if command -v docker >/dev/null 2>&1; then
                                echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                                docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            elif [ -x "/snap/bin/docker" ]; then
                                echo "${DOCKER_PASSWORD}" | /snap/bin/docker login -u "${DOCKER_USERNAME}" --password-stdin
                                /snap/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            elif [ -x "/usr/bin/docker" ]; then
                                echo "${DOCKER_PASSWORD}" | /usr/bin/docker login -u "${DOCKER_USERNAME}" --password-stdin
                                /usr/bin/docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            fi
                            echo "✅ ✅ ✅ SUCCESS: Image pushed to Docker Hub!"
                        '''
                    }
                }
            }
        }
    }
}
