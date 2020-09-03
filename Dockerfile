FROM nginx:mainline
LABEL maintainer="Tobias Derksen <tobias.derksen@codecentric.de>"

EXPOSE 8080
EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]

# Work as root
# User is overwritten by Openshift afterwards
USER root

# Remove obsolete files & create folders
RUN rm -f /etc/nginx/conf.d/default.conf && \
    rm -rf /usr/share/nginx/html && \
    mkdir -p /usr/share/nginx/html && \
    mkdir -p /usr/share/nginx/secure

# Set permissions
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    chgrp -R root /var/cache/nginx && \
    chmod -R go+w /usr/share/nginx/

# Copy index files
COPY html/ /usr/share/nginx/html
COPY secure/ /usr/share/nginx/secure

#add nginx config files
COPY nginx.conf /etc/nginx/
COPY conf.d/*.conf /etc/nginx/conf.d/

WORKDIR /usr/share/nginx/html
