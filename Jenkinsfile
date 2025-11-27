pipeline {
    agent any
    tools {
        jdk 'JAVA_HOME'
        maven 'M2_HOME'
    }
    environment {
        GIT_CREDENTIALS = '12dca24c-9c9b-463d-9216-3098b14c0819'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
        DOCKER_USERNAME = 'lhech24'
        IMAGE_NAME = "${env.DOCKER_USERNAME}/student-management"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        FULL_IMAGE_NAME = "${env.IMAGE_NAME}:${env.IMAGE_TAG}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/hachem22/HachemMatboui4SLEAM2.git',
                        credentialsId: env.GIT_CREDENTIALS
                    ]]
                ])
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Verify Docker Setup') {
            steps {
                script {
                    echo '=== Checking Docker availability ==='
                    sh 'docker --version'
                    sh 'docker info || echo "WARNING: Docker daemon not accessible"'
                    
                    echo '=== Verifying Dockerfile ==='
                    sh 'test -f Dockerfile && echo "✓ Dockerfile found" || (echo "✗ Dockerfile NOT found" && exit 1)'
                    sh 'cat Dockerfile'
                    
                    echo '=== Checking workspace contents ==='
                    sh 'ls -la'
                }
            }
        }
        
        stage('Docker Build') {
    steps {
        script {
            sh "/usr/local/bin/docker build -t ${FULL_IMAGE_NAME} ."
            sh "/usr/local/bin/docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest"
        }
    }
}

stage('Docker Push') {
    steps {
        script {
            withCredentials([usernamePassword(
                credentialsId: env.DOCKER_CREDENTIALS,
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )]) {
                sh 'echo $DOCKER_PASS | /usr/local/bin/docker login -u $DOCKER_USER --password-stdin'
                sh "/usr/local/bin/docker push ${FULL_IMAGE_NAME}"
                sh "/usr/local/bin/docker push ${IMAGE_NAME}:latest"
                sh "/usr/local/bin/docker logout"
            }
        }
    }
}

    post {
        always {
            script {
                // Cleanup: remove dangling images
                sh 'docker image prune -f || true'
            }
        }
        success {
            echo "✓ Pipeline succeeded! Image pushed: ${FULL_IMAGE_NAME}"
        }
        failure {
            echo '✗ Pipeline failed - check logs above for details'
        }
    }
}
