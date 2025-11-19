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

        stage('Verify Files') {
            steps {
                sh 'ls -la'       // Vérifie que pom.xml et mvnw sont présents
                sh './mvnw -v'    // Vérifie que Maven Wrapper fonctionne
            }
        }
        stage('Set Executable') {
    steps {
        sh 'chmod +x mvnw'
    }
}

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'  // Build Maven sur Linux
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
