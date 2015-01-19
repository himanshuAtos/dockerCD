FROM ubuntu:trusty
MAINTAINER Himanshu Shekhar Upadhyay <himanshu.serendipity@gmail.com>


RUN DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

# Update to latest
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

RUN apt-get update
RUN apt-get upgrade -y

# Install basics
RUN apt-get install -y unzip


# Install Java, auto-accepting the license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Install different Java versions
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-java7-installer 

# Set environment variables pointing to different Java installations
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV JAVA7_HOME /usr/lib/jvm/java-7-oracle


# Ensure Java 7 is the default version
RUN update-java-alternatives -s java-7-oracle

# Install JBoss-as-7.1.1.Final
RUN wget -O jboss.zip http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
RUN unzip jboss.zip && mv jboss-as-7.1.1.Final /opt
RUN cd /opt/jboss-as-7.1.1.Final/bin && chmod +x *.sh



# Your webapp file must be at the same location as your Dockerfile
#ADD testDockerWeb.war /opt/jboss-as-7.1.1.Final/server/default/deploy/
ADD target/HelloDocker.war /opt/jboss-as-7.1.1.Final/standalone/deployments/

# Clean-up to reduce the image size
RUN apt-get clean

#EXPOSE 8080
CMD ["/opt/jboss-as-7.1.1.Final/bin/standalone.sh","-b", "0.0.0.0"]
