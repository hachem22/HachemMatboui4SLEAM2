pipeline {
    agent any

    tools {
        maven 'Maven-3.6'
        jdk 'JDK-17'
    }

    environment {
        GITHUB_CREDENTIALS = 'github-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '===== Récupération du code depuis GitHub ====='
                git branch: 'main',
                    credentialsId: "${GITHUB_CREDENTIALS}",
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git'
            }
        }

        stage('Build') {
            steps {
                echo '===== Build Maven : clean + package (skip tests) ====='
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo '===== Archivage du JAR ====='
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '===== ✅ Build réussi ! ====='
        }
        failure {
            echo '===== ❌ Build échoué ! ====='
        }
    }
}