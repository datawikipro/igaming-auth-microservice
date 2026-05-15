# ---------- build auth-base (shared library) ----------
FROM ghcr.io/datawikipro/igaming-build-base:latest AS build-base
WORKDIR /base
COPY auth-base/pom.xml .
COPY auth-base/src ./src
RUN mvn install -DskipTests -B

# ---------- build igaming-auth-microservice ----------
FROM ghcr.io/datawikipro/igaming-build-base:latest AS build
COPY --from=build-base /root/.m2/repository/pro/datawiki /root/.m2/repository/pro/datawiki
WORKDIR /app
COPY igaming-auth-microservice/pom.xml .
RUN mvn dependency:go-offline -B
COPY igaming-auth-microservice/src ./src
RUN mvn clean package -DskipTests -B

# ---------- runtime ----------
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8000
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
