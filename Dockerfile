# Utilise une image OpenJDK légère
FROM openjdk:17-jre-slim

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le fichier JAR depuis le target Maven
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Expose le port 8080 pour l'application Spring Boot
EXPOSE 8080

# Point d'entrée pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
