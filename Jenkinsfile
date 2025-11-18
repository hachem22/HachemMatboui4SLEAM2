pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/hachem22/HachemMatboui4SLEAM2.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}
