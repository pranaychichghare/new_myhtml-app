# Use the official httpd image from the Docker Hub
FROM httpd:latest

# Copy the index.html file to the default directory of the Apache server
COPY ./index.html /usr/local/apache2/htdocs/

# Expose port 80
EXPOSE 80

# Start the httpd server
CMD ["httpd-foreground"]
