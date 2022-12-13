#####
# Postgres: wait until container is created
#####
until python3 /srv/config/database-check-psql.py; do
    sleep 5; echo "*** Waiting for postgres container ..."
done

#####
# Django setup
#####
if [ "$DB_FLUSH" == "TRUE" ]; then
    # Django: reset database
    # https://docs.djangoproject.com/en/1.9/ref/django-admin/#flush
    #
    # This will give some errors when there is no database to be flushed, but
    # you can ignore these messages.
    echo "==> Django setup, executing: flush"
    python3 /srv/project/manage.py flush --noinput
fi

# Django: migrate
#
# Django will see that the tables for the initial migrations already exist
# and mark them as applied without running them. (Django won’t check that the
# table schema match your models, just that the right table names exist).
echo "==> Django setup, executing: migrate"
python3 /srv/project/manage.py migrate --fake-initial
