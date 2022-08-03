FROM nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/backend-not-found.html /var/www/html/backend-not-found.html
COPY ./nginx/ssl/ /etc/ssl/certs/nginx/
COPY ./nginx/includes/ /etc/nginx/includes/
# RUN ./nginx/ssl/generate-keys.sh # RUN command is to start the container not to actually run a command inside the container
RUN /docker-entrypoint.sh