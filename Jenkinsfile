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
                        echo "=== CONSTRUCTION DOCKER ==="
                        
                        # Test sudo sans mot de passe
                        sudo whoami
                        
                        # Construction Docker
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
                            echo "=== PUSH DOCKER HUB ==="
                            
                            # Login Docker Hub
                            echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
                            
                            # Push images
                            sudo docker push lhech24/student-management:${BUILD_NUMBER}
                            sudo docker push lhech24/student-management:latest
                            
                            echo "🎉 🎉 🎉 SUCCÈS COMPLET! 🎉 🎉 🎉"
                            echo "📦 Image disponible: lhech24/student-management:${BUILD_NUMBER}"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ ✅ ✅ PIPELINE RÉUSSI! ✅ ✅ ✅"
            echo "🌐 Voir sur: https://hub.docker.com/r/lhech24/student-management"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
