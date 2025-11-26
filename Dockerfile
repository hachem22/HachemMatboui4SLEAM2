FROM openjdk:17-jre-slim

WORKDIR /app

# Copier le fichier JAR (utilisation de wildcard corrigée)
COPY target/student-management-*.jar app.jar

# Créer un utilisateur non-root pour plus de sécurité
RUN useradd -m myapp
USER myapp

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
