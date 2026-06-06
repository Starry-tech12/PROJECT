# Use the official Nginx base image
FROM nginx:alpine

# Remove the default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy your local application files into the Nginx directory
# Make sure your files are in a 'dist' or 'build' folder in your project
COPY ./my-app /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]