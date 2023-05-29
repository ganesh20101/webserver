# Use a base image
FROM tomcat:latest



# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container launches
CMD ["catalina.sh", "run", ">", "/dev/null"]
