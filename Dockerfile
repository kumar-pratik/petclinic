FROM openjdk:8-alpine
WORKDIR /code
ADD ./target/spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar /code
ENV spring_profiles_active=mysql
EXPOSE 8080
CMD java -jar spring-petclinic-2.3.0.BUILD-SNAPSHOT.jar