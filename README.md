# volkmydj_microservices
volkmydj microservices repository

---------------------------------------

# Docker-2
1. Установлен docker на OC Ubuntu.
2. Запущен тестовый контейнер "Hello world"
3. Изучены основные команды создания, запуска, остановки, удаления контейнеров.
4. В файл docker-1.log выведен результат команды: `docker images`
5. В файле docker-1.log описаны различия image от container на основании вывода результаов команд:
   `docker inspect <u_container_id>` и `docker inspect <u_image_id>`
6. Установлен docker-machine.
7. Создан image с приложением reddit в GCE. Данному образу присвоено имя и таг.
8. Образ запушен в личный аккаунт Docker Hub.
9. Проверена работа скаченного образа на локальном ПК. Приложение доступно на порту 9292
10. (*).Создан прототип infra:
  1. Packer.Создан шаблон с установленным Docker Engine.
  2. Terraform. Описано создание нескольких инстансов (по-молчанию 1) с образом по шаблону из п.1.
  3. Ansible. Создан плейбук для запуска контейнера с reddit-app с использованием динамического инвентори.

### Как использовать
`docker run hello-world`
`docker ps`
`docker ps -a`

### Как использовать для задания со *.

`cd ../terraform/prod && terraform init`
`terraform plan`
`terraform apply`
`cd ../ansible`
`ansible-playbook container-run.yml --check`
`ansible-playbook container-run.yml`


# Docker-3
1. Приложение reddit разбито на микросервисы : comment, post-py, ui.
2. Для каждого микросервиса написан Dockerfile.
3. Каждый микросервис запускается в отдельном контейнере.
4. БД MongoDB запускается также в отдельном контейнере.
5. Изучена возможность переопределения ENV относительно исходного в Dockerfile:
   `docker run -e POST_DATABASE_HOST='new_post_db' -d --network=reddit --network-alias=post  volkmydj/post:1.0`
6. Исследованы возможности монтирования volume для хранения информации после остановки контейнера.
7. Исследованы возможности уменьшения размера image. Удалось добиться уменьшения image до 168 Мб относительно первичного image 786 Мб. Пример находится в реп-ии.

### Как использовать

`docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest` \
`docker run -d --network=reddit --network-alias=post volkmydj/post:1.0` \
`docker run -d --network=reddit --network-alias=comment volkmydj/comment:1.0` \
`docker run -d --network=reddit -p 9292:9292 volkmydj/ui:1.0`
