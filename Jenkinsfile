pipeline {
    agent any

    stages {

        stage('Build Project') {
            steps {
                echo "=== Compilation du projet ==="
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "=== Construction de l\'image Docker ==="
                sh """
                    docker build -t lhech24/student-management:${BUILD_NUMBER} .
                    docker tag lhech24/student-management:${BUILD_NUMBER} lhech24/student-management:latest
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "=== Push de l\'image sur DockerHub ==="
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker push lhech24/student-management:${BUILD_NUMBER}
                        docker push lhech24/student-management:latest
                    '''
                }
            }
        }
    }
}
