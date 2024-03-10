FROM alpine:latest

LABEL maintainer="SushiBox <ikaproxy@sushibox.dev>"

# Install Squid and other necessary tools
RUN apk add --no-cache ca-certificates bash curl squid sed \
    # Create and set proper permissions for Squid log directory
    && mkdir -p /var/spool/squid /var/log/squid \
    && chown -R squid:squid /var/spool/squid /var/log/squid \
    # Ensure Squid cache directories are created
    && squid -z

# Add Squid configuration and entrypoint script
COPY squid.conf /etc/squid/squid.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3128/tcp

# Set the entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
