#!/bin/bash

set -e


if [[ ! -d /srv/project ]]
then
    echo ""
    echo "**************************************************************************"
    echo "ERROR"
    echo "No se encuentra el proyecto Django en volumes/django"
    ls -l /srv/project
    echo ""
    echo "**************************************************************************"
    echo ""
    exit
fi


echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"
echo "*                                                         *"
if [ $MODE == "prod" ]; then
    echo "*     start.sh MODE PROD                                  *"
else
    echo "*     start.sh MODE DEV                                   *"
fi
echo "*                                                         *"
echo "*     CONTAINER_NAME: ${CONTAINER_NAME}"
echo "*"
echo "*     DB_HOST: ${DB_HOST}"
echo "*     DB_PORT: ${DB_PORT}"
echo "*     DB_NAME: ${DB_NAME}"
echo "*     DB_USER: ${DB_USER}"
echo "*     DB_PASSWORD: $DB_PASSWORD"
echo "*"
echo "*     DJANGO_DEBUG: $DJANGO_DEBUG"
echo "*     DJANGO_DEBUG_TOOLBAR: $DJANGO_DEBUG_TOOLBAR"
echo "*     DJANGO_PTVSD_DEBUG: $DJANGO_PTVSD_DEBUG"
echo "*"
if [ $MODE == "prod" ]; then
    echo "*     DJANGO LISTENING PORT: $EXPOSE_PORT_DJANGO"
    echo "*     PTVSD PUBLIC PORT: $EXPOSE_PUBLIC_DEV_PORT_PTVSD"
fi
echo "*"
echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"


if [ $MODE == "prod" ]; then

    echo "==> Django setup, executing: collectstatic"
    python3 /srv/project/manage.py collectstatic --noinput -v 3

    echo "==> Iniciando base de datos"
    /srv/scripts/start_db.sh

    echo "==> Starting uWSGI ..."
    /usr/local/bin/uwsgi --emperor /etc/uwsgi/django-uwsgi.ini

else

    echo "==> Iniciando base de datos"
    /srv/scripts/start_db.sh

    echo "==> Starting runserver_plus ..."
    # opcion --nopin es para que WERKZEUG no pida el pin
    /srv/project/manage.py runserver_plus 0.0.0.0:8000 --nopin --keep-meta-shutdown --insecure

fi
