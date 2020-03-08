SHELL = /bin/sh
PREFIX = $(shell pwd)
VERSION=2.0
USER_NAME=volkmydj

export USER_NAME=volkmydj
export VERSION=2.0

### BUild ###
build_comment:
	cd src/comment && bash docker_build.sh

build_post:
	cd src/post-py && bash ./docker_build.sh

build_ui:
	cd src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && bash docker_build.sh

build_alertmanager:
	cd ./monitoring/alertmanager && bash docker_build.sh

build_grafana:
	cd ./monitoring/grafana && bash docker_build.sh

build_telegraf:
	cd ./monitoring/telegraf && bash docker_build.sh

build_trickster:
	cd ./monitoring/trickster && bash docker_build.sh

build_stackdriver:
	cd ./monitoring/stackdriver && bash docker_build.sh

build: build_post build_comment build_ui build_prometheus build_alertmanager build_grafana build_telegraf build_trickster build_stackdriver

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

push_grafana:
	docker push ${USER_NAME}/grafana:${VERSION}

push_telegraf:
	docker push ${USER_NAME}/telegraf:${VERSION}

push_trickster:
	docker push ${USER_NAME}/trickster:${VERSION}

push_stackdriver:
	docker push ${USER_NAME}/stackdriver:${VERSION}

push: push_comment push_post push_ui push_prometheus push_alertmanager push_grafana push_telegraf push_trickster push_stackdriver

### All Up
up: up_app up_monitoring build


### All Down
down: down_app down_monitoring
