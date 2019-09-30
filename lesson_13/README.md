##Docker

Докер образ - содержит набор слоёв файловой системы, не имеет состояния и никогда не изменяется.

Докер контейнер - это экземпляр образа докера во время выполнения, который состоит из докер образа, среды исполнения и набора инструкций.

В контейнере можно собрать ядро.

В папке php находится dockerfile для создания образа php-fpm, cсылка на образ с php https://cloud.docker.com/u/manvigor/repository/docker/manvigor/otusphpfpm

В папке nginx находится dockerfile для создания образа Nginx, ссылка на образ с nginx https://cloud.docker.com/u/manvigor/repository/docker/manvigor/otusnginx

Файл docker-compose.yml позволяет запустить контейнеры из собранных ранее образов и перейдя на http://localhost:8080/info.php посмотреть информацию по php.
