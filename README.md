# Docker Dind extanded

This docker image extand official docker:dind image and allow to pass variable for registry mirror.

## Variables
 - **DOCKER_INSECURE_REGISTRY**
DOCKER_INSECURE_REGISTRY="my.local:5000"

- **DOCKER_REGISTRY_MIRROR**
DOCKER_REGISTRY_MIRROR="http://my.local:5000"