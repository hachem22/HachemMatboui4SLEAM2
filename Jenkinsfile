pipeline {
    agent any
    
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -la target/'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo '⚠️  Docker non installé - étape ignorée'
                    echo 'Pour activer cette étape, installez Docker sur le serveur Jenkins'
                    echo 'JAR construit avec succès: target/student-management-0.0.1-SNAPSHOT.jar'
                }
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline terminé'
        }
        success {
            echo '✅ Application construite avec succès!'
            echo '📦 JAR disponible dans: target/student-management-0.0.1-SNAPSHOT.jar'
        }
        failure {
            echo '❌ Pipeline échoué'
        }
    }
}
