pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_PATH = '/usr/bin/docker'  // Chemin absolu garanti
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    sh """
                        echo "=== UTILISATION DOCKER AVEC CHEMIN ABSOLU ==="
                        
                        # Vérification avec chemin absolu
                        ${DOCKER_PATH} --version
                        echo "✅ Docker accessible via chemin absolu"
                        
                        # Construction de l'image
                        ${DOCKER_PATH} build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        ${DOCKER_PATH} tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        
                        echo "✅ Image Docker construite: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    """
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            # Connexion à Docker Hub
                            ${DOCKER_PATH} login -u \$DOCKER_USER -p \$DOCKER_PASS
                            
                            # Push des images
                            ${DOCKER_PATH} push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            ${DOCKER_PATH} push ${DOCKER_IMAGE}:latest
                            
                            echo "🎉 🎉 🎉 SUCCÈS COMPLET! 🎉 🎉 🎉"
                            echo "📦 Image poussée sur Docker Hub: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ ✅ ✅ PIPELINE COMPLÈTEMENT RÉUSSI! ✅ ✅ ✅"
            echo "🌐 Votre image est disponible sur: https://hub.docker.com/r/lhech24/student-management"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
