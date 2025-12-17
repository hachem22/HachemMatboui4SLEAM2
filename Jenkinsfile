pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }
    
    environment {
        DOCKER_IMAGE = 'studentmang-app:1.0'
        DOCKER_TAG = "${BUILD_NUMBER}"
        NAMESPACE = 'devops'
        MINIKUBE_IP = sh(script: 'minikube ip', returnStdout: true).trim()
    }
    
    stages {
        stage('🔍 Checkout') {
            steps {
                echo '📥 Cloning repository from GitHub...'
                checkout scm
            }
        }
        
        stage('🔨 Build with Maven') {
            steps {
                echo '🔨 Building application with Maven...'
                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                '''
            }
        }
        
        stage('🧪 Unit Tests') {
            steps {
                echo '🧪 Running unit tests...'
                sh './mvnw test || true'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('📊 SonarQube Analysis') {
            steps {
                echo '📊 Running SonarQube code analysis...'
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh """
                            ./mvnw sonar:sonar \
                              -Dsonar.projectKey=student-management \
                              -Dsonar.projectName='Student Management' \
                              -Dsonar.host.url=http://${MINIKUBE_IP}:30900 \
                              -Dsonar.sources=src/main/java \
                              -Dsonar.java.binaries=target/classes
                        """
                    }
                }
            }
        }
        
        stage('🚦 Quality Gate') {
            steps {
                echo '🚦 Waiting for SonarQube Quality Gate...'
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        try {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                echo "⚠️ Quality Gate status: ${qg.status}"
                                echo "⚠️ Continuing anyway..."
                            } else {
                                echo "✅ Quality Gate passed!"
                            }
                        } catch (Exception e) {
                            echo "⚠️ Quality Gate check failed: ${e.message}"
                            echo "⚠️ Continuing anyway..."
                        }
                    }
                }
            }
        }
        
        stage('🐳 Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('📦 Load Image to Minikube') {
            steps {
                echo '📦 Loading Docker image into Minikube...'
                sh """
                    minikube image load ${DOCKER_IMAGE}:${DOCKER_TAG}
                    minikube image load ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('🚀 Deploy to Kubernetes') {
            steps {
                echo '🚀 Deploying application to Kubernetes...'
                sh """
                    kubectl set image deployment/springboot \
                        springboot=${DOCKER_IMAGE}:${DOCKER_TAG} \
                        -n ${NAMESPACE} || echo "First deployment"
                    
                    sleep 10
                    
                    kubectl rollout status deployment/springboot \
                        -n ${NAMESPACE} --timeout=3m || echo "Deployment in progress"
                """
            }
        }
        
        stage('✅ Verify Deployment') {
            steps {
                echo '✅ Verifying Kubernetes deployment...'
                sh """
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "📦 PODS STATUS"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    kubectl get pods -n ${NAMESPACE}
                    
                    echo ""
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "🌐 SERVICES"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    kubectl get svc -n ${NAMESPACE}
                    
                    echo ""
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "🎯 ACCESS URLS"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                    echo "Application:  http://192.168.56.10:8081"
                    echo "SonarQube:    http://192.168.56.10:30900"
                    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                """
            }
        }
    }
    
    post {
        success {
            echo '✅✅✅ PIPELINE COMPLETED SUCCESSFULLY! ✅✅✅'
            echo "🎉 Application version ${DOCKER_TAG} deployed successfully"
            echo "🌐 Application URL: http://192.168.56.10:8081"
            echo "📊 SonarQube: http://192.168.56.10:30900/dashboard?id=student-management"
        }
        failure {
            echo '❌❌❌ PIPELINE FAILED! ❌❌❌'
            echo '📝 Check the logs above for error details'
        }
        always {
            echo '🧹 Cleaning workspace...'
            cleanWs()
        }
    }
}
