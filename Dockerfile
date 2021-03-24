FROM maven:3.6.3-jdk-11

WORKDIR /usr/src/app

COPY pom.xml /usr/src/app

COPY . /usr/src/app