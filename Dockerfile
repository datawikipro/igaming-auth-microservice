# ---------- build ----------
FROM ghcr.io/datawikipro/igaming-build-base:latest AS build
WORKDIR /app

# 1. Build and install auth-base in cache mount
COPY auth-base /app/auth-base
RUN --mount=type=cache,target=/root/.m2 mvn -f auth-base/pom.xml install -DskipTests -B

# 2. Resolve microservice dependencies
COPY igaming-auth-microservice/pom.xml /app/igaming-auth-microservice/
RUN --mount=type=cache,target=/root/.m2 mvn -f igaming-auth-microservice/pom.xml dependency:go-offline -B

# 3. Build microservice
COPY igaming-auth-microservice/src /app/igaming-auth-microservice/src
RUN --mount=type=cache,target=/root/.m2 mvn -f igaming-auth-microservice/pom.xml clean package -DskipTests -B

# ---------- runtime ----------
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/igaming-auth-microservice/target/*.jar app.jar
EXPOSE 8000
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
