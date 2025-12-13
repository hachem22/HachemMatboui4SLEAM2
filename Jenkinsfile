pipeline {
    agent any

    tools {
        maven 'Maven-3.6'
        jdk 'JDK-17'
    }

    environment {
        GITHUB_CREDENTIALS = 'github-credentials'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        DOCKERHUB_USERNAME = 'VOTRE_USERNAME_DOCKERHUB'
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/springboot-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '===== Récupération du code depuis GitHub ====='
                git branch: 'main',
                    credentialsId: "${GITHUB_CREDENTIALS}",
                    url: 'https://github.com/VOTRE_USERNAME/nom_prenom_classe.git'
            }
        }

        stage('Build Maven') {
            steps {
                echo '===== Build Maven : clean + package (skip tests) ====='
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '===== Construction de l\'image Docker ====='
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKERHUB_CREDENTIALS}") {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Deploy MySQL to Kubernetes') {
            steps {
                echo '===== Déploiement MySQL sur Kubernetes ====='
                sh '''
                    kubectl apply -f k8s/mysql-secret.yaml
                    kubectl apply -f k8s/mysql-pvc.yaml
                    kubectl apply -f k8s/mysql-deployment.yaml
                    kubectl rollout status deployment/mysql --timeout=300s
                '''
            }
        }

        stage('Deploy Spring Boot to Kubernetes') {
            steps {
                echo '===== Déploiement Spring Boot sur Kubernetes ====='
                sh '''
                    kubectl apply -f k8s/springboot-deployment.yaml
                    kubectl rollout status deployment/springboot-app --timeout=300s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '===== Vérification du déploiement ====='
                sh '''
                    echo "=== Pods ==="
                    kubectl get pods
                    echo "=== Services ==="
                    kubectl get svc
                    echo "=== Secrets ==="
                    kubectl get secrets
                '''
            }
        }
    }

    post {
        success {
            echo '===== ✅ Pipeline complété avec succès ! ====='
            sh '''
                echo "Application accessible via:"
                minikube service springboot-service --url
            '''
        }
        failure {
            echo '===== ❌ Pipeline échoué ! ====='
        }
        always {
            echo '===== Nettoyage des images Docker locales ====='
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
        }
    }
}
