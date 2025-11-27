pipeline {
    agent any

    stages {

        stage('Build App') {
            steps {
                echo "=== BUILD DU PROJET ==="
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "=== CONSTRUCTION DE L'IMAGE DOCKER ==="
                sh "docker build -t hachem22/student-management:${env.BUILD_NUMBER} ."
                sh "docker tag hachem22/student-management:${env.BUILD_NUMBER} hachem22/student-management:latest"
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "=== PUSH DOCKER HUB ==="
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push hachem22/student-management:${env.BUILD_NUMBER}"
                    sh "docker push hachem22/student-management:latest"
                }
            }
        }
    }
}
