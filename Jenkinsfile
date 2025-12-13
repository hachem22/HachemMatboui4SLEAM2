pipeline {
    agent any

    environment {
        APP_NAME = "springboot-app"
        K8S_NAMESPACE = "devops"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📥 Récupération du code source"
                checkout scm
            }
        }

        stage('Build Spring Boot (Maven)') {
            steps {
                echo "🔨 Build Maven"
                sh '''
                  chmod +x mvnw
                  ./mvnw clean package -DskipTests
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Build image Docker dans Minikube"
                sh '''
                  eval $(minikube docker-env)
                  docker build -t ${APP_NAME} .
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 Déploiement Kubernetes"
                sh '''
                  kubectl config set-context --current --namespace=${K8S_NAMESPACE}
                  kubectl apply -f k8s/mysql-secret.yaml --validate=false
                  kubectl apply -f k8s/mysql-pvc.yaml --validate=false
                  kubectl apply -f k8s/mysql-deployment.yaml --validate=false
                  kubectl apply -f k8s/mysql-service.yaml --validate=false

                  kubectl apply -f k8s/springboot-deployment.yaml --validate=false
                  kubectl apply -f k8s/springboot-service.yaml --validate=false
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "✅ Vérification des pods"
                sh '''
                  kubectl get pods
                  kubectl get svc
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline terminé avec SUCCÈS"
        }
        failure {
            echo "❌ Pipeline ÉCHOUÉ – Vérifier les logs"
        }
    }
}
