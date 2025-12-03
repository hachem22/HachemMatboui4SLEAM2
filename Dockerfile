# Étape 1 : Utiliser une image JDK
FROM openjdk:17-jdk-slim

# Étape 2 : Copier le JAR généré par Maven
COPY target/*.jar app.jar

# Étape 3 : Exposer le port de ton application
EXPOSE 8080

# Étape 4 : Commande de lancement
ENTRYPOINT ["java", "-jar", "/app.jar"]
