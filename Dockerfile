# Use a Maven build image to compile the app
FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Use a lightweight OpenJDK runtime image for the final container
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the packaged jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the default port the app listens on
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
