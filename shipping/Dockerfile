# syntax=docker/dockerfile:experimental
FROM maven:3-jdk-11 as build
WORKDIR /tmp

copy src /tmp/src
copy pom.xml /tmp/

run --mount=type=cache,id=maven,target=/root/.m2,sharing=shared mvn clean package
<<<<<<< HEAD
=======
run chmod a+rx /tmp/target/shipping.jar
>>>>>>> 690ff1159e47e201cfbfb6c34da6f966d207bfda

from adoptopenjdk/openjdk11:alpine

COPY --from=build /tmp/target/shipping.jar /shipping.jar
<<<<<<< HEAD

run chmod a+rx ./shipping.jar
=======
>>>>>>> 690ff1159e47e201cfbfb6c34da6f966d207bfda

USER ${SERVICE_USER}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG COMMIT

LABEL org.label-schema.vendor="bryandollery" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${BUILD_VERSION}" \
  org.label-schema.name="Socks Shop: Shipping" \
  org.label-schema.description="REST API for Shipping service" \
  org.label-schema.url="https://github.com/microservices-demo/shipping" \
  org.label-schema.vcs-url="github.com:microservices-demo/shipping.git" \
  org.label-schema.vcs-ref="${COMMIT}" \
  org.label-schema.schema-version="1.0"

<<<<<<< HEAD
ENTRYPOINT ["/opt/java/openjdk/bin/java","-jar","./shipping.jar", "--port=80"]

=======
ENTRYPOINT ["/opt/java/openjdk/bin/java","-jar","./shipping.jar", "--port=8080"]
>>>>>>> 690ff1159e47e201cfbfb6c34da6f966d207bfda
