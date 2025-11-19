pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = '0397d01c-e799-4d43-943e-5e46c329ca7a'  // Remplace par l’ID réel de tes credentials dans Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                    credentialsId: "${env.GIT_CREDENTIALS_ID}"
                )
            }
        }

        stage('Build') {
            steps {
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
