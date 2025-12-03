pipeline {
    agent any

    tools {
        // Maven installé automatiquement dans Jenkins
        maven 'MAVEN_HOME'
    }

    environment {
        // Nom de ton image Docker Hub
        DOCKER_IMAGE = "lhech24/student-management"
    }

    stages {

        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t $DOCKER_IMAGE:latest .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',  // <-- ID des credentials DockerHub
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $DOCKER_IMAGE:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🚀 Pipeline réussi ! Image poussée sur Docker Hub ✔️"
        }
        failure {
            echo "❌ Pipeline échoué."
        }
    }
}
