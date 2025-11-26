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
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        # Test simple de Docker
                        docker --version || echo "Docker non accessible"
                        
                        # Construction de l'image
                        docker build -t lhech24/student-management:${BUILD_NUMBER} .
                        docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
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
                            docker login -u $DOCKER_USER -p $DOCKER_PASS
                            docker push lhech24/student-management:${BUILD_NUMBER}
                            docker push lhech24/student-management:latest
                            echo "SUCCÈS!"
                        '''
                    }
                }
            }
        }
    }
}
