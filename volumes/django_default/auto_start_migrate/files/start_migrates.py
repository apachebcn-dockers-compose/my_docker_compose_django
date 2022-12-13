# author PEDRO REINA ROJAS <apachebcn@gmail.com>

import os
import list_apps

lista_apps = list_apps.get_apps()
for app in lista_apps:
	app_migrate_path = lista_apps[app]
	print("*****************************")
	print("*****************************")
	print("Remove Migration %s" % app)
	print("*****************************")
	print("*****************************")
	code = os.system("rm -f -R %s" % app_migrate_path)
	if code != 0:
		exit()

for app in lista_apps:
	print("*****************************")
	print("*****************************")
	print("migration %s" % app)
	print("*****************************")
	print("*****************************")
	app = app.replace("apps.", "")
	app = app.replace("apps_sumex.", "")
	command = "/srv/project/manage.py makemigrations %s" % app
	print(command)
	code = os.system(command)
	if code != 0:
		exit()
	#command = "/srv/project/manage.py migrate --fake %s" % app
	#code = os.system(command)
	#if code != 0:
	#	exit()
	#code = os.system("/srv/project/manage.py migrate --fake %s zero" % app)
	#if code != 0:
	#	exit()
	code = os.system("/srv/project/manage.py migrate --fake-initial %s 0001" % app)
	if code != 0:
		exit()
	command = "/srv/project/manage.py sqlmigrate %s 0001" % app
	code = os.system(command)
	if code != 0:
		exit()
