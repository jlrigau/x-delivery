FROM ubuntu:12.04

MAINTAINER Jean-Louis Rigau <jlrigau@xebia.fr>

RUN apt-get update

RUN sudo apt-get install openjdk-7-jdk

RUN echo deb http://pkg.jenkins-ci.org/debian binary/ >> /etc/apt/sources.list
RUN apt-get install -y wget
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN apt-get update
RUN apt-get install -y jenkins=1.550

ENTRYPOINT exec su jenkins -c "java -jar /usr/share/jenkins/jenkins.war"
