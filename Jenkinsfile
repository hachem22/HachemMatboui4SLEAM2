pipeline {
  agent any
  
  tools {
    maven 'M2_HOME'      // TON Maven correct
    jdk 'JAVA_HOME'      // TON Java correct
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
        sh 'mvn -B clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          echo "🚧 Construction de l'image Docker: ${FULL_IMAGE_NAME}"
          sh "docker build -t ${FULL_IMAGE_NAME} ."
          sh "docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest"
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: env.DOCKER_CREDENTIALS,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${FULL_IMAGE_NAME}"
          sh "docker push ${IMAGE_NAME}:latest"
        }
      }
    }
  }

  post {
    success {
      echo '✓ Pipeline réussi ! Image envoyée sur Docker Hub avec succès.'
    }
    failure {
      echo '✗ Échec du pipeline. Vérifie les logs.'
    }
  }
}
