pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        # Vérifier que le JAR existe
                        if [ ! -f "target/*.jar" ]; then
                            echo "❌ ERREUR: Fichier JAR non trouvé"
                            exit 1
                        fi
                        
                        # Construire l'image Docker
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        echo "✅ Image Docker construite: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            # Se connecter à Docker Hub
                            echo \"\${DOCKER_PASSWORD}\" | docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            
                            # Pousser l'image
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            
                            echo "✅ ✅ ✅ IMAGE PUSHÉE AVEC SUCCÈS!"
                            echo "📦 Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                            echo "🌐 Disponible sur: https://hub.docker.com/r/lhech24/student-management"
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE RÉUSSI!"
            echo "📸 Prenez les captures d'écran pour la soumission"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
