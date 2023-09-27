# Problem
You are running your applications in a containerized environment, but the applications aren't utilizing a distributed logging service, such as Datadog, Sentry, etc. Instead, your application code is simply logging to the console. In this scenario, the logs will remain within the container, necessitating the need to execute commands or establish an SSH connection to the container in order to access them.

This situation can become quite cumbersome, especially in shared environments such as development, staging, or production. Debugging errors can prove to be extremely challenging since the logs are scattered without any context. You might find yourself needing to connect to multiple containers to correlate requests and effectively debug issues.

# Solution
The optimal solution is to implement a distributed logging service like Datadog or Sentry, or to ingest logs into Elasticsearch, among other options. To achieve this, you would either need to create a logging service within your system or develop a common library that can route logs to the chosen distributed logging service(s).

However, if you prefer not to modify your service code but still want to centralize the collection of container console logs, allowing for easier log searching or the transfer of logs to a logging service like Datadog or Elasticsearch, or even to store them in cloud storage like Amazon S3 or an Azure Storage Account. You can employ a service that integrates with your containers, capture console logs, and export them to a centralized location. We shall explore Fluentd for this purpose.

## Fluentd
Fluentd is an open-source data collection and log management tool that serves as a essential component in the logging and data analytics pipeline. Its primary functions include collecting, processing, and forwarding log data and event streams. Fluentd empowers applications to harmonize log and data collection from diverse sources, standardize them into a common format, and dispatch them to various destinations for analysis and storage. This flexibility is achieved through Fluentd's extensive support for plugins and integrations, making it highly adaptable to different data sources and storage solutions. Commonly utilized in DevOps and system administration, Fluentd excels at centralizing and efficiently managing log data.

## Proof of Concept
This repository provides detailed instructions on using the Fluentd file output plugin. In this setup, Fluentd operates as a service within a Docker compose environment, working in tandem with other services to capture logs. It seamlessly integrates with containerized services, enabling the collection of console logs from those services and storing them in a centralized location on the host machine, formatted as JSON. While I am currently using Docker Compose for orchestration, Fluentd can also be employed in Kubernetes (K8s) environments. In K8s, you can run Fluentd as a DaemonSet, allowing it to aggregate logs from each POD running on worker nodes for efficient log management. 
## Fluentd POC project structure
The project structure will look like the following.
```plaintext
container-logging/
├── Dockerfile
├── fluentd-check.sh
├── entrypoint.sh
├── docker-compose.yml
└── config/
    ├── fluent.conf
    └── logrotate.conf
```

## Implementation
### Fluentd Project (Repository - container-logging): 
This is the project repository which manages all the relevant files and configurations for Fluentd and log management.

### Dockerfile: 
This file is used to define how the Fluentd container image should be built. It specifies the base image, sets up necessary permissions, and includes configuration files.

### docker-compose.yml: 
This YAML file defines your Docker Compose services. It includes configurations for running the Fluentd container and other services (like busybox containers) that generate and collect logs. It also specifies volume mounts for log collection on the host machine.

### Mounting Data/Log Volume: 
Fluentd service will mount a volume (data/log) to collect logs from the busybox services. This allows logs to be written to the host machine, ensuring persistence and ease of access. Since the Logs are in JSON, they be ingested or exported to any other logs analysis or storage platform easily.

### fluent.conf: 
This is the Fluentd configuration file. It specifies how Fluentd should collect, process, and output logs. In this case, it using the file output plugin to write logs to a local file, but Fluentd supports various output plugins for different destinations.

### logrotate.conf: 
Log rotation is important to manage disk space efficiently. Since Fluentd doesn't handle log rotation on its own, I've included a logrotate configuration to handle log rotation for the logs written to disk. For the demonstration purpose, the rotation policy is quite aggressive. A log file cannot grow more than 5K. And, a maximum of 5 files will be kept.

### fluentd-check.sh: 
This script ensures that the Fluentd service is started correctly before other container services dependent on Fluentd's logging. It helps maintain the integrity of the logging infrastructure.

### entrypoint.sh: 
This script is used as the entry point for the Fluentd container. It starts both the crond (cron daemon) and Fluentd services when the container starts. This ensures that Fluentd is running and ready to collect logs.

### Running the project
- Docker runtime and docker-compose binary is required to run the docker-compose services.
- clone or fork the repository.
- cd to container-logging folder.
- $ docker-compose build
- $ docker-compose up or docker-compose up -d
- Check the data/log folder for the logs under busybox1 and busybox2 folders.
- Those same folders will also have the rotated log files.



