#!/usr/bin/env python

# author PEDRO REINA ROJAS <apachebcn@gmail.com>

import os
import list_apps

lista_apps = list_apps.get_apps()
for app in lista_apps:
	app_migrate_path = "/srv/project/%s" % lista_apps[app]
	print("*****************************")
	print("*****************************")
	print("Remove Migration %s" % app)
	print("*****************************")
	print("*****************************")

	"""
	command = "ls -l %s" % app_migrate_path
	print(command)
	code = os.system("rm -f -R %s" % app_migrate_path)
	if code != 0:
	    exit()
	"""
	
	command = "rm -f -R %s" % app_migrate_path
	code = os.system(command)
	if code != 0:
	    exit()
	