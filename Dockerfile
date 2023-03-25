# Use an official Nginx runtime as a base image
FROM nginx:latest

# Set the working directory to the Nginx document root
WORKDIR /usr/share/nginx/html

# Copy the index.html file and any other static assets to the working directory
COPY index.html .
