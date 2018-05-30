VERSION:=1.0.0
PROJECT_NAME=resources-server
DOCKER_IMAGE_NAME=120011676/${PROJECT_NAME}
build:
image-dev: build
image-test: build
	docker build -t ${DOCKER_IMAGE_NAME}:test .
image-latest: build
	docker build -t ${DOCKER_IMAGE_NAME}:latest .
image-version: build
	docker build -t ${DOCKER_IMAGE_NAME}:${VERSION} .
push-dev: image-dev
	docker push ${DOCKER_IMAGE_NAME}:dev
push-test: image-test
	docker push ${DOCKER_IMAGE_NAME}:test
push-latest: image-latest
	docker push ${DOCKER_IMAGE_NAME}:latest
push-version: image-version
	docker push ${DOCKER_IMAGE_NAME}:${VERSION}
push: push-dev push-test push-latest push-version
run: image-dev
	docker-compose up --build