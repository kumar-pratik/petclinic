FROM openjdk:8-alpine

# Maintainer: Kumar Pratik

WORKDIR /code

COPY ./target/spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar /code

# This allows Spring to use mysql as its database
ENV spring_profiles_active=mysql

EXPOSE 8080

CMD java -jar spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar
