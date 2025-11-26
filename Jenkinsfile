pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'lhech24/student-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Build') { steps { sh 'mvn clean package -DskipTests' } }
        stage('Docker Build') { steps { sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .' } }
        stage('Docker Push') { steps { 
            withCredentials([usernamePassword(
                credentialsId: 'docker-hub-credentials',
                usernameVariable: 'DOCKER_USER', 
                passwordVariable: 'DOCKER_PASS'
            )]) {
                sh '''
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    echo "SUCCÈS!"
                '''
            }
        } }
    }
}
