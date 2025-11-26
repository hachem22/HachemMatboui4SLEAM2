pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'Lhech24/student-management'
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
                        # Vérifier l installation de Docker
                        echo "🔍 Vérification de Docker..."
                        docker --version
                        
                        # Vérifier le fichier JAR
                        echo "🔍 Vérification du fichier JAR..."
                        ls -la target/*.jar
                        
                        # Construire l image Docker
                        echo "🐳 Construction de l image Docker..."
                        docker build -t Lhech24/student-management:${BUILD_NUMBER} .
                        docker tag Lhech24/student-management:${BUILD_NUMBER} Lhech24/student-management:latest
                        
                        echo "✅ Image Docker construite avec succès"
                        echo "📦 Image: Lhech24/student-management:${BUILD_NUMBER}"
                    '''
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
                        sh '''
                            # Connexion à Docker Hub
                            echo "🔐 Connexion à Docker Hub..."
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            
                            # Push des images
                            echo "📤 Envoi des images vers Docker Hub..."
                            docker push Lhech24/student-management:${BUILD_NUMBER}
                            docker push Lhech24/student-management:latest
                            
                            echo "✅ ✅ ✅ SUCCÈS COMPLET!"
                            echo "📦 Images envoyées:"
                            echo "   - Lhech24/student-management:${BUILD_NUMBER}"
                            echo "   - Lhech24/student-management:latest"
                            echo "🌐 Lien: https://hub.docker.com/r/Lhech24/student-management"
                        '''
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
            echo "📸 Prenez des captures d écran pour la soumission"
        }
        failure {
            echo "❌ Pipeline échoué"
            echo "🔍 Vérifiez les logs pour identifier le problème"
        }
    }
}
