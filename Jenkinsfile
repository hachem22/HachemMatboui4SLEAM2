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
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        echo "🐳 Construction de l'image Docker..."
                        docker build -t lhech24/student-management:${BUILD_NUMBER} .
                        docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
                        echo "✅ Image Docker construite: lhech24/student-management:${BUILD_NUMBER}"
                    '''
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',  // ✅ CORRECT: vos credentials existent
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh '''
                            echo "🔐 Connexion à Docker Hub..."
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            
                            echo "📤 Envoi des images vers Docker Hub..."
                            docker push lhech24/student-management:${BUILD_NUMBER}
                            docker push lhech24/student-management:latest
                            
                            echo "✅ ✅ ✅ SUCCÈS COMPLET!"
                            echo "📦 Images disponibles sur:"
                            echo "   https://hub.docker.com/r/lhech24/student-management"
                            echo "🔗 Lien direct: https://hub.docker.com/r/lhech24/student-management/tags"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 🎉 🎉 PIPELINE RÉUSSI!"
            echo "✨ Toutes les étapes terminées avec succès"
            echo "📸 Prenez ces captures d'écran pour la soumission:"
            echo "   1. Vue d'ensemble du repository sur Docker Hub"
            echo "   2. Liste des tags avec vos images"
            echo "   3. Logs Jenkins montrant le succès"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
