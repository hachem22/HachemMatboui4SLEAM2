FROM openjdk:11-jre-slim

WORKDIR /app

# Copier le JAR de l'application
COPY target/myapp.jar app.jar

# Exposer le port
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
