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
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/*.jar'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                        echo "=== ÉTAPE 1: Vérification Docker avec Sudo ==="
                        sudo docker --version
                        echo "✅ Docker accessible via sudo"
                        
                        echo "=== ÉTAPE 2: Construction de l'image ==="
                        sudo docker build -t lhech24/student-management:${BUILD_NUMBER} .
                        sudo docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
                        echo "✅ Image Docker construite: lhech24/student-management:${BUILD_NUMBER}"
                    '''
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
                        sh '''
                            echo "=== ÉTAPE 3: Connexion Docker Hub ==="
                            echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
                            echo "✅ Connecté à Docker Hub"
                            
                            echo "=== ÉTAPE 4: Push des images ==="
                            sudo docker push lhech24/student-management:${BUILD_NUMBER}
                            sudo docker push lhech24/student-management:latest
                            
                            echo "🎉 🎉 🎉 SUCCÈS COMPLET! 🎉 🎉 🎉"
                            echo "📦 Image disponible sur: https://hub.docker.com/r/lhech24/student-management"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ ✅ ✅ PIPELINE COMPLÈTEMENT RÉUSSI! ✅ ✅ ✅"
            echo "🎊 Toutes les étapes terminées avec succès!"
            echo "📸 Prenez des captures d'écran pour la soumission:"
            echo "   - Vue d'ensemble du pipeline Jenkins"
            echo "   - Logs de build montrant le succès"
            echo "   - Repository Docker Hub avec votre image"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
