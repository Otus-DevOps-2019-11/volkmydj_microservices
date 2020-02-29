SHELL = /bin/sh
PREFIX = $(shell pwd)
# VERSION=$(shell git describe --tags)
VERSION=1.0
REGISTRY=volkmydj
# SRC_DIRS=comment post-py ui
# dpl ?= deploy.env
# include $(dpl)
# export $(shell sed 's/=.*//' $(dpl))

SERVICES=comment post ui blackbox-exporter prometheus mongo-exporter

build/all: $(addprefix build/,$(SERVICES))
push/all : $(addprefix push/,$(SERVICES))

$(addprefix build/,$(SERVICES)):
	@echo '>> building $(notdir $@) image <<'
	@docker build -t $(USERNAME)/$(notdir $@):$(VERSION) $(PREFIX)/src/$(notdir $@)/

$(addprefix push/,$(SERVICES)):
	@echo '>> pushing $(notdir $@) image <<'
	@docker push $(USERNAME)/$(notdir $@):$(VERSION)

$(addprefix rmi/,$(SERVICES)):
	@echo '>> remove $(notdir $@) image <<'
	@docker rmi $(USERNAME)/$(notdir $@):$(VERSION)

$(addprefix up/,$(SERVICES)):
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d $(notdir $@)

$(addprefix kill/,$(SERVICES)):
	docker-compose --project-directory docker -f docker/docker-compose.yml kill $(notdir $@)

up:
	@echo '>> running app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d

down:
	@echo '>> stoping app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml down
