pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'   // Java installé : /usr/lib/jvm/java-17-openjdk-amd64
    maven 'M2_HOME'   // Maven installé : /usr/share/maven
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

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${FULL_IMAGE_NAME} ."
                    sh "docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest"
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
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push ${FULL_IMAGE_NAME}"
                        sh "docker push ${IMAGE_NAME}:latest"
                        sh "docker logout"
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✓ Pipeline réussi et image poussée sur Docker Hub !'
        }
        failure {
            echo '✗ Échec du pipeline'
        }
    }
