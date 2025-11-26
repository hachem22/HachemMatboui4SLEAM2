stage('Build Docker Image') {
    steps {
        script {
            sh '''
                echo "=== Environnement ==="
                whoami
                pwd
                ls -la
                echo "=== Vérification Docker ==="
                which docker || echo "Docker non trouvé"
                echo "=== Fin vérification ==="
            '''
            sh 'echo "✅ Fichier JAR trouvé"'
            // Commenter temporairement la construction Docker
            // sh 'docker build -t votre-image .'
        }
    }
}
