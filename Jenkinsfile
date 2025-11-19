
pipeline {
    agent any

    environment {
        // Met ici l'ID de tes credentials GitHub configurés dans Jenkins
        GIT_CREDENTIALS_ID = 'f3eb5fc8-6933-4bb8-b3e3-6751d8521693'
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupère le projet depuis GitHub
                git(
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                    branch: 'main',
                    credentialsId: "${env.GIT_CREDENTIALS_ID}"
                )
            }
        }

        stage('Build') {
            steps {
                // Build Maven en Linux, en sautant les tests
                sh './mvnw clean package -DskipTests'
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
