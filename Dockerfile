# build the application with gradle
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17 AS build
WORKDIR /project
ADD build.gradle /project
COPY . .
# Sonar Setup
ARG SONARQUBE_TOKEN
ENV SONARQUBE_TOKEN=${SONARQUBE_TOKEN}
ARG SONARQUBE_URL
ENV SONARQUBE_URL=${SONARQUBE_URL}
ARG SONARQUBE_ENV
ENV SONARQUBE_ENV=${SONARQUBE_ENV}
RUN ./gradlew clean build
RUN if [ "${SONARQUBE_ENV}" = "prod" ] ; then ./gradlew sonar -Dsonar.host.url=${SONARQUBE_URL} -Dsonar.login=${SONARQUBE_TOKEN}; else echo "${SONARQUBE_ENV} no envia a sonar"; fi
ENV SONARQUBE_TOKEN=''
ENV SONARQUBE_URL=''
# end sonar setup
ENTRYPOINT ["./gradlew", "bootRun"]