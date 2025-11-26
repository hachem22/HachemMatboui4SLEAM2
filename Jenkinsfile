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
                    // Vérifier si Docker est installé
                    sh '''
                        if ! command -v docker &> /dev/null; then
                            echo "❌ Docker n'est pas installé"
                            exit 1
                        fi
                        
                        docker --version
                    '''
                    
                    // Vérifier l'existence du JAR
                    sh 'ls -la target/student-management-0.0.1-SNAPSHOT.jar'
                    echo '✅ Fichier JAR trouvé, construction de l\'image Docker...'
                    
                    // Construire l'image Docker (remplacez par votre vrai tag)
                    sh 'docker build -t hachem22/student-management:latest .'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Se connecter à Docker Hub (configurez vos credentials Jenkins)
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh 'docker push hachem22/student-management:latest'
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline terminé'
        }
        success {
            echo '✅ Pipeline réussi!'
        }
        failure {
            echo '❌ Pipeline échoué'
        }
    }
}
