# Use the official Tomcat base image with JDK 11
FROM tomcat:9.0-jdk11-openjdk

# Optionally remove the default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your StudentSurvey.war file to the webapps directory in the container
COPY StudentSurvey.war /usr/local/tomcat/webapps/

# Tomcat listens on port 8080
EXPOSE 8080

# Run Tomcat server
CMD ["catalina.sh", "run"]