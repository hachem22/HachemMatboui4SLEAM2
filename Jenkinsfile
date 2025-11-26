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
                        echo "=== ÉTAPE 1: Vérification de Docker avec sudo ==="
                        sudo docker --version
                        echo "✅ Docker est accessible"
                        
                        echo "=== ÉTAPE 2: Vérification du JAR ==="
                        ls -la target/*.jar
                        echo "✅ JAR trouvé"
                        
                        echo "=== ÉTAPE 3: Construction Docker ==="
                        sudo docker build -t lhech24/student-management:${BUILD_NUMBER} .
                        sudo docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
                        echo "✅ Image Docker construite: lhech24/student-management:${BUILD_NUMBER}"
                    '''
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            echo "=== ÉTAPE 4: Connexion Docker Hub ==="
                            sudo docker login -u $DOCKER_USER -p $DOCKER_PASS
                            echo "✅ Connecté à Docker Hub"
                            
                            echo "=== ÉTAPE 5: Push des images ==="
                            sudo docker push lhech24/student-management:${BUILD_NUMBER}
                            sudo docker push lhech24/student-management:latest
                            echo "✅ Images poussées avec succès"
                            
                            echo "🎉 🎉 🎉 SUCCÈS COMPLET! 🎉 🎉 🎉"
                            echo "📦 Votre image est disponible sur Docker Hub!"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ ✅ ✅ PIPELINE COMPLÈTEMENT RÉUSSI! ✅ ✅ ✅"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
