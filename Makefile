SHELL = /bin/sh
PREFIX = $(shell pwd)
VERSION=1.0
USER_NAME=volkmydj

### BUild ###
build_comment:
	cd src/comment && bash ./docker_build.sh

build_post:
	cd src/post-py && bash ./docker_build.sh

build_ui:
	cd src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && bash docker_build.sh

build: build_post build_comment build_ui build_prometheus

### APP UP ####

up_app:
	echo '>> running app <<'
	docker-compose --project-directory docker -f docker/docker-compose.yml up -d

### APP Down ###

down_app:
	echo '>> stoping app <<'
	docker-compose --project-directory docker -f docker/docker-compose.yml down

### Monitoring UP
up_monitoring:
	echo '>> running monitoring <<'
	docker-compose --project-directory docker -f docker/docker-compose-monitoring.yml up -d

### Monitoring Down
down_monitoring:
	echo '>> stoping monitoring <<'
	docker-compose --project-directory docker -f docker/docker-compose-monitoring.yml down

### Push ###

push_comment:
	docker push $(USER_NAME)/comment:$(VERSION)

push_post:
	docker push ${USER_NAME}/post:$(VERSION)

push_ui:
	docker push ${USER_NAME}/ui:$(VERSION)

push_prometheus:
	docker push ${USER_NAME}/prometheus:$(VERSION)

push_alertmanager:
	docker push ${USER_NAME}/alertmanager:${VERSION}

push: push_comment push_post push_ui push_prometheus push_alertmanager
