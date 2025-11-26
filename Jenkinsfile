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
                        echo "=== CONSTRUCTION DE L'IMAGE DOCKER ==="
                        sudo docker --version
                        sudo docker build -t lhech24/student-management:${BUILD_NUMBER} .
                        sudo docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
                        echo "✅ Image Docker construite"
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
                            echo "=== PUSH VERS DOCKER HUB ==="
                            echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
                            sudo docker push lhech24/student-management:${BUILD_NUMBER}
                            sudo docker push lhech24/student-management:latest
                            echo "🎉 IMAGES PUSHÉES AVEC SUCCÈS!"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ ✅ ✅ PIPELINE RÉUSSI! ✅ ✅ ✅"
            echo "🌐 Votre image est disponible sur: https://hub.docker.com/r/lhech24/student-management"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}
