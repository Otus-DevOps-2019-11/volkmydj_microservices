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


# Docker-4
1. Изучены типы сетей в docker. Их функции, различия, особенности....
2. Установлен docker-compose с github.
3. Рассмотрены основные принципы применения docker-compose.
4. Создан docker-compose.yml, в котором билд и запуск разбит на отдельные сервисы и описан декларативно.
5. Базовое имя проекта образуется по принципу название папки + название сервиса: src_ui, src_post и т.д. \
   Базовое имя проекта можно задать, если в docker-compose.yml определить в названии сервиса container_name:
6. Все переменные определены в отдельном файле .env. Данный файл добавлен в .gitignore.
7. Создан docker-compose.override.yml. С помощью данного файла мы можем изменять код каждого из приложений, не выполняя сборку. \
   Также в данном файле определена команда запуска puma для ruby приложений в дебаг режиме и с двумя воркерами.

### Как использовать
`cd src && docker-compose up -d`


# gitlab-ci-1
1. Пакером подготовлен специальный image с установленным Dockr Engine и Docker-Compose.
2. Терраформом поднят инстанс с поготовленным образом. Проброшены нужные порт.
3. Gitlab-CE (omnibus) разворачивается в контейнере на инстансе GCP с помощью Ansible.
4. Один gitlab-runner развернут по примеру в ДЗ, другой с помощью роли Ansible (задание со *).
5. В шаг build добавлена сборка контейнера с приложением reddit. (задание со *).
6. Установка и регистрация ранеров осуществляется с помощью Ansible (задание со *).

### Как использовать :
`cd gitlab-ci/infra/terraform ` \
`terraform init && terraform plan` \
`terraform apply` \
`cd ansible` \
`ansible-playbook gitlab-docker.yml --check` \
`ansible-playbook gitlab-docker.yml` \
`ansible-playbook gitlab-runners.yml --check` \
`ansible-playbook gitlab-runners.yml` \
Done!

# monitoring-1
1. Добавили в проект систему мониторинга Prometheus.
2. Prometheus поднимаем в докере. Описание процесса добавили в docker-compose.yml проекта.
3. Для сбора метрик добавили несколько экспортеров:
 - node-exporter
 - mongodb-exporter (задание со *)
 - blackbox-exporter (задание со *)
4. Для упрощения рутины развертывания проекта создан Makefile (задание со *).
5. Ссылка на registry: `https://hub.docker.com/u/volkmydj`

### Как использовать

`git clone .....` \
`make up` \
Done!

# monitoring-2

1. Вынес все микросервисы мониторинга в отдельный файл  `docker-compose-monitorng.yml`. Теперь мониторинг деплоится отдельно от приложений.
2. Добавил в мониторинг экспортер `cAdvisor` для получения метрик с наших микросервисов приложения.
3. Добавил в мониторинг средство отображения метрик `Grafana`.
4. Добавил в Grafana источник сбора метрик (datasource) наш Prometheus. Данный функциоанл  Grafana доступен "из коробки".
5. Начиная с Grafana 5.0 была добавлена возможность описать в конфигурационных файлах источники данных и дашборды. Реализовал данную возможность (задание с **). При деплое автоматически добавляются источники данных: `InfluxDB` и `Prometheus`.
6. В Grafana я использовал как собственно сделанные дашбоарды, так и те, что есть в комьюнити на официальном сайте.
7. Добавлена возможность получать алерты. Реализован алерт получения уведомления в личный канал Slack, если микросервис Post находится в состоянии Down.
8. Также реализована возможность получать уведомления на почту (так себе вариант), если время обработки запроса микросервиса UI превышает 50 мс.
9. Реализована возможность сбора метрик с docker engine, используя его встренные средства. В основном большая часть метрик ориентирована на Swarm. Поэтому данный способ получения метрик не является оптимальным.
10. Для сбора метрик с докер-демона реализована возможность получать данные с помощью `Telegraf` от `InfluxDB`. Данный способ также добавлен в общий файл деплоя мониторинга (задание с *).
11. Реализован алерт для микросервиса UI 95 процентиль времени ответа.
12. Реализован сбор метрик с помощью `Stackdriver`. Stackdriver - это сервис по сбору метрик, логов и трейсов, а так же алертинг...Предварительно необходимо создать сервисный аккаунт GCP с ролью View. Далее согласно [официальной документации](https://cloud.google.com/monitoring/quickstart-lamp) произвести установку агента. Начиная с версии 5.3.х и 5.4.х Grafana позволяет получать метрики напрямую от агентов. В нашем случае мы использем экспортер для Prometheus.
13. Реализовано подключение Grafana к Prometheus через прокси `Trickster`.

### Как использовать
`git clone....` \
`make up` \
Done!

[My docker hub](https://hub.docker.com/u/volkmydj)


# logging-1

1. В диретории logging созда папку fluentd, где создал Dockerfile для образа fluentd.
2. Cоздал конфигурационный файл fluent.conf в диретории fluentd.
3. В дирректории docker создал файл для поднятия стека EFK `docker-compose-logging.yml`.
4. Изменил тэги микросервисов в файле .env на logging.
5. Для микросервисов post и ui добавлен драйвер логирования fluentd.
6. В fluentd.conf добавлен фильтр парсинга структурированных логов JSON.
7. В fluentd.conf добавлен фильтр парсинга неструктурированных логов.
8. Реализован функционал использования grok-шаблонов.
9. Для полного парсинга неструктурированного лога добавлена дополнительная секция фильтра:
```
<filter service.ui>
  @type parser
  format grok
  grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IPORHOST:remote_addr} \| method=%{GREEDYDATA:method} \| response_status=%{NUMBER:response_status}
  key_name message
  reserve_data false
</filter>
```
по аналогии с
```
<filter service.ui>
  @type parser
  format grok
  grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  key_name message
  reserve_data true
</filter>
```
10. Добавлен сервис распределенного трейсинга `Zipkin`.
11. В файле .env добавлена информация о том, что Zipkin активен.
12. Zipkin также добавлен в одну сеть с микросервисами.
13. В задании со * найдена причина некоректного работа микросервиса post. С помощью Zipkin была диагностирована следующая аномалия. Страница долго загружалась. На этапе поиска записи в БД процесс подвисал примерно на 3 сек. После анализа кода микросервиса post была выявлена причина. Всему виной оказалась строка  `time.sleep(3)` в блоке кода:
```
        stop_time = time.time()  # + 0.3
        resp_time = stop_time - start_time
        app.post_read_db_seconds.observe(resp_time)
        time.sleep(3)
        log_event('info', 'post_find',
                  'Successfully found the post information',
                  {'post_id': id})
        return dumps(post)
```
Закоментировав данную строку, приложение стало корректно обрабатывать запросы.

### Как использовать

`git clone...`
`make up`
Done!


# kubernetes-1

1. Изучен материал "Kubernetes The Hard Way". По данному методу был поднят кластер Kubernetes.
2. Кластер был поднят на 3-х мастер-нодах и 1 воркере. Такая конфигурация вынужденная по причине ограничения до 4-х внешних IP на бесплатном аккаунте GCP.
3. Найдены синтаксические ошибки в некоторых командах из туториала.
4. Проверен деплоймент всех сервисов приложения.
5. Все сертификаты и конфигурации закоммичены в репозиторий.
6. Изучены несколько варинатов полного деплоя кластера. Но мной принято решение не использовать данные вырианты. Думаю, что было бы логичней использовать связку terraform+ansible.


# kuberenetes-2
1. Поднят кластер minikube для изучения основных принципов управления и деплоя в кластер
2. Рассмотрены различные контексты kubectl.
3. Расссмотрены основные компоненты кластера.
4. Рассмотрен ресурс Deployment. Также рассмотрен процесс его деплоя.
5. Рассмотрена такая абстракция как Service.
6. Рассмотрены различные варианты форвардинга.
7. Рассмотрен аддон - dashboard. Произведен его деплой.
8. Рассмотрена такая сущность как NameSpace.
9. Описан манифест namespace dev, а также произведен его деплой.
10. Через консоль GCP развернут кластер GKE.
11. Созданы правила firewall для возможности подключения к нему снаружи.
12. Подключен аддон dashboard-kubernetes. (Warning: The open source Kubernetes Dashboard addon is deprecated for clusters on GKE and will be removed as an option in version 1.15. It is recommended to use the alternative Cloud Console dashboards described on this page.)
13. Также, как и в minikube задеплоны  namespace dev и reddit-app.
14. Создано описание поднятия кластера GKE с помощью terraform.
15. Через terraform также описано подключение аддона dashboard-kubernetes и правила firewall.
16. Написаны манифесты для создания пользователя ServiceAccount и присвоения ему роли cluster-admin.


### Как использовать
1. `cd .../terraform` \
2. `terraform init` && `terraform apply`
3. `gcloud container clusters get-credentials my-gke-cluster --region us-central1 --project docker-266610`
4. `kubectl apply -f ./kubernetes/reddit/dev-namespace.yml`
5. `kubectl apply -f ./kubernetes/reddit/ -n dev`
   ##### Check application functionality
- `kubectl get nodes -o wide`
- `kubectl describe service ui -n dev | grep NodePort`
- `http://<node-ip>:<NodePort>`
6. Install dashboard: \
   6.1. Create ServiceAccount: `kubectl apply -f ./kubernetes/dashboard/dashboard-adminuser.yml` \
   6.2. Create ClusterRoleBinding: `kubectl apply -f ./kubernetes/dashboard/cluster-admin.yml` \
   6.3. Get Bearer Token: `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')` \
   It should print something like:
```
Name:         admin-user-token-v57nw
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin-user
              kubernetes.io/service-account.uid: 0303243c-4040-4a58-8a47-849ee9ba79c1

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1066 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXY1N253Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIwMzAzMjQzYy00MDQwLTRhNTgtOGE0Ny04NDllZTliYTc5YzEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.Z2JrQlitASVwWbc-s6deLRFVk5DWD3P_vjUFXsqVSY10pbjFLG4njoZwh8p3tLxnX_VBsr7_6bwxhWSYChp9hwxznemD5x5HLtjb16kI9Z7yFWLtohzkTwuFbqmQaMoget_nYcQBUC5fDmBHRfFvNKePh_vSSb2h_aYXa8GV5AcfPQpY7r461itme1EXHQJqv-SN-zUnguDguCTjD80pFZ_CmnSE1z9QdMHPB8hoB4V68gtswR1VLa6mSYdgPwCHauuOobojALSaMc3RH7MmFUumAgguhqAkX3Omqd3rJbYOMRuMjhANqd08piDC3aIabINX6gP5-Tuuw2svnV6NYQ

```
7. `kubectl proxy`
8. Go to: `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`
9. Now copy the token and paste it into Enter token field on login screen.
10. Click Sign in button and that's it. You are now logged in as an admin.


# kubernetes-3
1. Расссмотрено взаимодействие микросервисов при помощи kube-dns.
2. Расссмотрено взаимодействие микросервисов при помощи iptables.
3. Рассмотрен вариант внешнего доступа к кластеру при помощи LoadBalancer.
4. Рассмотрен вариант внешнего доступа к кластеру при помощи Ingress.
5. Рассмотрены основные задачи, решаемые с помощью Ingress’ов.
6. Защитил наш сервис ui с помощью TLS.
7. Настроил Ingress на прием только HTTPS траффика.
8. Описан создаваемый объект Secret в виде Kubernetes- манифеста. (задание со *).
9. Рассмотрен NetworkPolicy - инструмент для декларативного описания потоков трафика.
10. Обновлен mongo-network-policy.yml так, чтобы post-сервис доходил до базы данных.
11. Рассмотрен механизм PersistentVolume.
12. Рассмотрен механизм создания запроса на выдачу - PersistentVolumeClaim.
13. Рассмотрен механизм создания хранилища при необходимости и в автоматическом режиме, с помощью StorageClass.

### Как использовать
1. `cd .../terraform` \
2. `terraform init` && `terraform apply`
3. `gcloud container clusters get-credentials my-gke-cluster --region us-central1 --project docker-266610`
4. `kubectl apply -f ./kubernetes/reddit/dev-namespace.yml`
5. `kubectl apply -f ./kubernetes/reddit/ -n dev`


# kubernetes-4

Уважаемые коллеги из Otus, такого п....ца как в этом ДЗ я пока не встречал в ДЗ до этого. Т.к. в Slack обычно отмалчиваются на нарекания по качеству ДЗ, то оставлю это здесь. \
`Переделайте конкретно это ДЗ. Уберите не логичную последовательность, ошибки и безобразную подачу материала в ДЗ. Вам самим то не стыдно?`

P.S. Какое ДЗ такое и описание.
