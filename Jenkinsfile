pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'ihech24/student-management'
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
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        # Vérifier l'installation de Docker
                        echo "🔍 Vérification de Docker..."
                        docker --version || echo "❌ Docker non installé"
                        
                        # Vérifier le fichier JAR
                        echo "🔍 Vérification du fichier JAR..."
                        if ls target/*.jar 1> /dev/null 2>&1; then
                            echo "✅ Fichier JAR trouvé: $(ls target/*.jar)"
                        else
                            echo "❌ Aucun fichier JAR trouvé dans target/"
                            exit 1
                        fi
                        
                        # Construire l'image Docker
                        echo "🐳 Construction de l'image Docker..."
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                        
                        echo "✅ Image Docker construite avec succès"
                        echo "📦 Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
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
                            # Connexion à Docker Hub
                            echo "🔐 Connexion à Docker Hub..."
                            echo \"\${DOCKER_PASSWORD}\" | docker login -u \"\${DOCKER_USERNAME}\" --password-stdin
                            
                            # Push des images
                            echo "📤 Envoi des images vers Docker Hub..."
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            
                            echo "✅ ✅ ✅ SUCCÈS COMPLET!"
                            echo "📦 Images envoyées:"
                            echo "   - ${DOCKER_IMAGE}:${DOCKER_TAG}"
                            echo "   - ${DOCKER_IMAGE}:latest"
                            echo "🌐 Lien: https://hub.docker.com/r/ihech24/student-management"
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "📊 Pipeline terminé - Build #${env.BUILD_NUMBER}"
        }
        success {
            echo "🎉 🎉 🎉 PIPELINE RÉUSSI!"
            echo "✨ Toutes les étapes terminées avec succès"
            echo "📸 Prenez des captures d'écran pour la soumission"
        }
        failure {
            echo "❌ Pipeline échoué"
            echo "🔍 Vérifiez les logs pour identifier le problème"
        }
    }
}
