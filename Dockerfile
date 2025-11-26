# Utiliser une image OpenJDK officielle
FROM openjdk:11-jre-slim

# Installer Maven pour builder l'application
FROM maven:3.8.4-openjdk-11 as builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier pom.xml
COPY pom.xml .

# Télécharger les dépendances (cette étape est mise en cache)
RUN mvn dependency:go-offline

# Copier le code source
COPY src ./src

# Builder l'application
RUN mvn clean package -DskipTests

# Deuxième stage pour l'image finale
FROM openjdk:11-jre-slim

# Installer des outils utiles pour le debugging
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root pour plus de sécurité
RUN groupadd -r spring && useradd -r -g spring spring

# Définir le répertoire de travail
WORKDIR /app

# Copier le JAR depuis le stage builder
COPY --from=builder /app/target/*.jar app.jar

# Changer les permissions
RUN chown spring:spring app.jar

# Utiliser l'utilisateur spring
USER spring

# Exposer le port de l'application
EXPOSE 8080

# Variables d'environnement
ENV JAVA_OPTS=""

# Commande de démarrage
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
