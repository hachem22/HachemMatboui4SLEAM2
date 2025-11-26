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
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                        # Test sudo
                        sudo whoami
                        
                        # Construction Docker
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
                            # Login Docker Hub
                            echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
                            
                            # Push images
                            sudo docker push lhech24/student-management:${BUILD_NUMBER}
                            sudo docker push lhech24/student-management:latest
                            
                            echo "🎉 SUCCÈS COMPLET!"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ PIPELINE RÉUSSI!"
        }
    }
}
