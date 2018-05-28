VERSION:=1.0.0
PROJECT_NAME=rcg-resources-server
DOCKER_IMAGE_NAME=registry.changhong.io/hlj/${PROJECT_NAME}
AUTO_DEPLOY_DIRECTORY=/data/deploy
SSH_HOSTNAME:=111.9.116.136
SSH_USERNAME:=deploy
SSH_PORT:=22
SSH_KEY=.ssh/deploy_ed25519
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
deploy:
	chmod 600 ${SSH_KEY}
	ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -p ${SSH_PORT} ${SSH_USERNAME}@${SSH_HOSTNAME} "cd ${AUTO_DEPLOY_DIRECTORY}/${PROJECT_NAME} && (docker-compose stop; docker-compose rm -f; docker rmi ${DOCKER_IMAGE_NAME}:test; cd ${AUTO_DEPLOY_DIRECTORY}; rm -rf ${PROJECT_NAME}/docker-compose.yml;) || mkdir ${AUTO_DEPLOY_DIRECTORY}/${PROJECT_NAME}"
	scp -P ${SSH_PORT} -i ${SSH_KEY} -r docker-compose.test.yml ${SSH_USERNAME}@${SSH_HOSTNAME}:${AUTO_DEPLOY_DIRECTORY}/${PROJECT_NAME}/
	ssh -i ${SSH_KEY} -p ${SSH_PORT} ${SSH_USERNAME}@${SSH_HOSTNAME} "cd ${AUTO_DEPLOY_DIRECTORY}/${PROJECT_NAME} && mv docker-compose.test.yml docker-compose.yml && docker-compose up -d"