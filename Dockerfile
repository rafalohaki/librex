# syntax = edrevo/dockerfile-plus
ARG VERSION="3.17"
FROM alpine:${VERSION} AS librex
WORKDIR "/var/www/html"

# Docker metadata contains information about the maintainer, such as the name, repository, and support email
# Please add any necessary information or correct any incorrect information
# See more: https://docs.docker.com/config/labels-custom-metadata/
LABEL name="LibreX" \
      description="Framework and javascript free privacy respecting meta search engine" \
      version="1.0" \
      vendor="Hnhx Femboy<femboy.hu>" \
      maintainer="Hnhx Femboy<femboy.hu>, Junior L. Botelho<juniorbotelho.com.br>" \
      url="https://github.com/hnhx/librex" \
      usage="https://github.com/hnhx/librex/wiki" \
      authors="https://github.com/hnhx/librex/contributors"

# Include arguments as temporary environment variables to be handled by Docker during the image build process
# Change or add new arguments to customize the image generated by 'docker build' command
ARG DOCKER_SCRIPTS="docker"
ARG NGINX_PORT=8080

# Customize the environment during both execution and build time by modifying the environment variables added to the container's shell
# When building your image, make sure to set the 'TZ' environment variable to your desired time zone location, for example 'America/Sao_Paulo'
# See more: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
ENV TZ="America/New_York"

# Include docker scripts, docker images, and the 'GNU License' in the Librex container
ADD "." "/var/www/html"

# Set permissions for script files as executable scripts inside 'docker/scripts' directory
RUN chmod u+x "${DOCKER_SCRIPTS}/php/prepare.sh" &&\
    chmod u+x "${DOCKER_SCRIPTS}/server/prepare.sh" &&\
    chmod u+x "${DOCKER_SCRIPTS}/entrypoint.sh" &&\
    chmod u+x "${DOCKER_SCRIPTS}/attributes.sh"

RUN apk add gettext --no-cache

# The following lines import all Dockerfiles from other folders so that they can be built together in the final build
INCLUDE+ docker/php/php.dockerfile
INCLUDE+ docker/server/nginx.dockerfile

EXPOSE ${NGINX_PORT}

# Configures the container to be run as an executable.
ENTRYPOINT ["/bin/sh", "-c", "docker/entrypoint.sh"]
