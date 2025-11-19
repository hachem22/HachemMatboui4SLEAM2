pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = '12dca24c-9c9b-463d-9216-3098b14c0819'
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                    branch: 'main',
                    credentialsId: GIT_CREDENTIALS_ID
                )
            }
        }

        stage('Build') {
            steps {
                // Sur Windows, build Maven en sautant les tests
                bat 'mvnw.cmd clean package -DskipTests'
            }
        }
    }

    post {
        success {
            echo 'Build réussi ✅'
        }
        failure {
            echo 'Build échoué ❌'
        }
    }
}
