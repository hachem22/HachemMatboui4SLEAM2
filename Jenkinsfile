pipeline {
    agent any
    
    tools {
        jdk 'jdk-17'
        maven 'maven-3.6.3'
    }
    
    environment {
        DOCKER_IMAGE = 'lhech24/student-management:latest'
    }
    
    stages {
        stage('Checkout Git') {
            steps {
                echo ' Récupération du code depuis GitHub...'
                git credentialsId: 'github-credentials', 
                    url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git', 
                    branch: 'main'
            }
        }
        
        stage('Build Maven') {
            steps {
                echo ' Construction du projet Maven...'
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Archive Artifact') {
            steps {
                echo ' Archivage du livrable JAR...'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        
        stage('Fix Docker Permissions') {
            steps {
                echo ' Correction des permissions Docker...'
                script {
                    sh 'sudo chmod 666 /var/run/docker.sock || true'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo ' Construction de l image Docker...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo ' Envoi de l image vers Docker Hub...'
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push hachemmatboui/student-management:latest
                            docker logout
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo '  Build réussi! Le livrable est disponible et l image Docker est publiée.'
        }
        failure {
            echo '  Build échoué! Consultez les logs pour plus de détails.'
        }
    }
}
