# Use the official Fluentd image as the base image
FROM fluent/fluentd:v1.14

USER root

# Expose the Fluentd listening port (24224)
EXPOSE 24224

# copy configurations
COPY ./config/fluent.conf /fluentd/etc/fluent.conf
COPY ./config/logrotate.conf /fluentd/etc/logrotate.conf
COPY fluentd-check.sh /fluentd
COPY entrypoint.sh /fluentd

# set permissions
# adjust permissions accordingly
RUN chmod -R 664 /fluentd/log

# Install logrotate
RUN apk update
RUN apk add logrotate

# schedule a cron job for log rotation. Runs every 2 mins.
RUN echo '*/2 * * * * /usr/sbin/logrotate /fluentd/etc/logrotate.conf' > /var/spool/cron/crontabs/root

# entry point command
CMD ["/bin/sh", "/fluentd/entrypoint.sh"]
