pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                    branch: 'main',
                    credentialsId: 'f3eb5fc8-6933-4bb8-b3e3-6751d8521693'
                )
            }
        }

        stage('Build') {
            steps {
                // Utiliser le script Windows
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
