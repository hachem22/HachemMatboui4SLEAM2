pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME'
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Build Artifact') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
    }

    post {
        success {
            echo "Build SUCCESS ✔️"
        }
        failure {
            echo "Build FAILED ❌"
        }
    }
}
