FROM maven:3.5.2-jdk-8-alpine AS MAVEN_BUILD_ENVIRONMENT

COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

RUN mvn clean package

FROM openjdk:8-jre

ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME /tmp
COPY --from=MAVEN_BUILD_ENVIRONMENT /tmp/target/api-catalogue.jar app.jar

RUN sh -c 'touch /app.jar'
CMD java -jar app.jar