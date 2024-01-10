-https://docs.localstack.cloud/user-guide/integrations/terraform/
-localstack config show
-localstack config validate
-localstack start
-docker ps -a
-localstack status services
-localstack status docker

<h6>few ways to start localstack</h6>

<p>start LocalStack with Docker Compose by configuring a docker-compose.yml file</p>
`
version: "3.8"

services:
localstack:
container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
    image: localstack/localstack
    ports:
      - "127.0.0.1:4566:4566"            # LocalStack Gateway
      - "127.0.0.1:4510-4559:4510-4559"  # external services port range
    environment:
      # LocalStack configuration: https://docs.localstack.cloud/references/configuration/
      - DEBUG=${DEBUG:-0}
volumes: - "${LOCALSTACK_VOLUME_DIR:-./volume}:/var/lib/localstack" - "/var/run/docker.sock:/var/run/docker.sock"
`

docker-compose up

# start the LocalStack container using the Docker CLI instead of Docker-Compose

docker run \
 --rm -it \
 -p 4566:4566 \
 -p 4510-4559:4510-4559 \
 localstack/localstack
