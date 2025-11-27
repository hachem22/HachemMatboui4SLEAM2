pipeline { // *FIXED SYNTAX HERE*
    agent any

    tools {
        jdk 'JAVA_HOME'
        maven 'M2_HOME'
    }

    environment {
        // You should use withCredentials instead of exposing a PAT in an environment variable that way.
        // Also, the Docker Password variable name must be consistent.
        GIT_CREDENTIALS = 'Sudo_Git'
    }

    stages {

        stage('Clone Project') {
            steps {
                git branch: 'main',
                    credentialsId: "${GIT_CREDENTIALS}",
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git'
            }
        }

        stage('Build: clean & package') {
            steps {
                sh 'mvn clean package -DskipTests'
                echo 'Build finished! JAR is available in target/.'
            }
        }
        
        stage('Docker Build') { // *STAGE ORDER CORRECTED*
            steps {
                script {
                    sh "docker build -t lhech24/student-management:1.0 ."
                }
            }
        }
        
        stage('Docker Push') { // *STAGE ORDER CORRECTED*
            steps {
                // Using 'withCredentials' is the standard secure way to handle Docker login
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials', // Your Docker Credential ID
                    passwordVariable: 'DOCKER_PASSWORD',
                    usernameVariable: 'DOCKER_USERNAME')]) {
                    
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    sh "docker push lhech24/student-management:1.0"
                }
            }
        }
    }
}
