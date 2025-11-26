pipeline {
    agent any
    
    environment {
        // Récupérer les credentials Docker Hub
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        // Nom de votre image Docker
        DOCKER_IMAGE = 'votredockerhub/your-spring-app:latest'
        // Tag avec le numéro de build
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        // Stage 1: Récupération du code
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "Récupération du code depuis GitHub réussie"
                }
            }
        }
        
        // Stage 2: Build de l'application Spring Boot
        stage('Build Application') {
            steps {
                script {
                    echo "Building Spring Boot application..."
                    sh 'mvn clean compile'
                }
            }
        }
        
        // Stage 3: Tests
        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests..."
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        // Stage 4: Package JAR
        stage('Package') {
            steps {
                script {
                    echo "Packaging application..."
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        // Stage 5: Build de l'image Docker
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}-${DOCKER_TAG}
                    """
                }
            }
        }
        
        // Stage 6: Push vers Docker Hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            echo \"\${DOCKER_PASSWORD}\" | docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            docker push ${DOCKER_IMAGE}
                            docker push ${DOCKER_IMAGE}-${DOCKER_TAG}
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed'
            cleanWs()
        }
        success {
            echo '✅ Pipeline succeeded! Docker image built and pushed.'
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Le build ${env.BUILD_URL} a réussi",
                to: "votre-email@example.com"
            )
        }
        failure {
            echo '❌ Pipeline failed!'
            emailext (
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Le build ${env.BUILD_URL} a échoué",
                to: "votre-email@example.com"
            )
        }
    }
}
