## A Dockerfile and two batch scripts for creating Dart dev channel Docker images

### This Docker image is intended to be used for development only and not for production. 

### Dockerfile
`Dockerfile` contains the instructions for building a Docker image

Specifying a `DART_VERSION` forces a specific Dart version to be installed.
Without a specific version the most recent available Dart version is installed 
(not tested yet without a specific version)

### docker_build.sh 
`docker_build.sh` creates the Docker image locally. This is mostly for debugging.

THE `VERSION` environment variable is used to tag the created image.

### docker_push.sh
`docker_push.sh` calls `docker_build.sh` and publishes the created Docker image

THE `VERSION` environment variable is used to tag the created image.

### dart_run.sh
`dart_run.sh` is the batch script executed to launch the application when a 
Docker container is started from this Docker image.

### Support

If you think this could be improved or you need more information just create a 
new issue at https://github.com/bwu-dart/bwu_docker_dart_dev/issues or a
pull request ;-)
