# Docker Dind extanded

This docker image extand official docker:dind image and allow to pass variable.

## Variables
 - **DOCKER_DIND_EXTRA_HOSTS**
DOCKER_DIND_EXTRA_HOSTS="my.local:192.168.1.1,my.local2:192.168.1.2"

- **DOCKER_DIND_DEAMON_OPTION**
DOCKER_DIND_DEAMON_OPTION="--registry-mirror=http://my.local:5000"