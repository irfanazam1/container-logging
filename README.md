# Problem
You haven't configured a logging service for your container in the service code or any other logging service, e.g. Datadog, and you are just logging on the console.
In that case, the logs will stay with the container and then you need to exec/ssh into the container to read the logs.
This could situation could be pretty annoying, especially when you are doing this in shared environment like, development, staging, or production.
It will be very hard to debug in case of errors because the logs are scatterred here and there without any context and you might need to connect to multiple containers to correlate the request to debug it.

# Solution
The proper solution is to use a commercial logging service like Elastic Search, Datadog, Sentry, etc. Write a logging service in your solution or a library that would log into Elactic Search, Datadog, or Sentry, etc.
But, if you don't want to change your service code but still want to collect the containers console logs at a central place, from where you could search the logs easily, or move the logs to some logging service like Datadog, Elastic Search, or move them to a cloud storage like Amazon S3 or Azure Storage Account, or any other service. Then, you can use a service which can integrate with the container, collect the console logs, and export them to a central place.

## Fluentd
This repository will provide the details about using the Fluentd service, it integrates with the containers and can export the logs at the destination of your choice using a configuration file, where you can use different plugins to export, copy, or push logs at different places, like Disk, Amazon S3, Datadog, Azure Storage Account, or using a REST API. 

## Implementation
- Create a fluentd project.
- Create a Dockerfile to pull the fluentd image and set up the container with necessary permissions and files.
- Mount a data/log folder to collect logs from the services on the host machine.
- Create fluent.conf file.
- Create a logrotate file. (It is because logs will be written to the disk and fluentd does not provide log rotation capabilities)
- Create a script that would make sure fluentd service has been started correctly before any other container service depending upon fluentd logging does not break.
- Create a docker-compose file to define a couple of service that would use the fluentd service to export logs at the central logging folder.

### Fluentd project
The project structure will look like the following.
fluentd/
├── Dockerfile
├── fluentd-check.sh
└── config/
    ├── fluent.conf
    └── logrotate.conf






