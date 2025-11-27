# Image de base Java 17
FROM openjdk:17-slim

# Répertoire de travail
WORKDIR /app

# Copier le jar généré par Maven
COPY target/student-management.jar /app/student-management.jar

# Commande pour exécuter l'application
ENTRYPOINT ["java", "-jar", "student-management.jar"]
