pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/spring-app'  // Remplacez par votre nom Docker Hub
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        // Stage 1: Checkout du code
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "✅ Code récupéré depuis GitHub"
                    sh 'ls -la'  // Vérifier le contenu du workspace
                }
            }
        }
        
        // Stage 2: Build de l'application Spring Boot
        stage('Build Application') {
            steps {
                script {
                    echo "🔨 Building Spring Boot application..."
                    sh 'mvn clean compile'
                }
            }
        }
        
        // Stage 3: Exécution des tests
        stage('Run Tests') {
            steps {
                script {
                    echo "🧪 Running tests..."
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        // Stage 4: Packaging de l'application
        stage('Package') {
            steps {
                script {
                    echo "📦 Packaging application..."
                    sh 'mvn clean package -DskipTests'
                    sh 'ls -la target/'  // Vérifier le JAR généré
                }
            }
        }
        
        // Stage 5: Build de l'image Docker
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    sh """
                        docker images
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker images
                    """
                }
            }
        }
        
        // Stage 6: Push vers Docker Hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "📤 Pushing Docker image to Docker Hub..."
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            echo \"\${DOCKER_PASSWORD}\" | docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            echo "✅ Image pushed successfully!"
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "🏁 Pipeline execution completed - Build ${env.BUILD_NUMBER}"
            // cleanWs()  // Retiré car cause des erreurs
        }
        success {
            echo '✅ ✅ ✅ Pipeline succeeded! Docker image built and pushed.'
        }
        failure {
            echo '❌ ❌ ❌ Pipeline failed! Check logs above.'
        }
    }
}
