import os
import pathlib
import sys


def get_parent_dir():

	return str(pathlib.Path(__file__).parent.parent.parent.resolve())


def add_sys_path(path):

	path = get_parent_dir() + path
	sys.path.insert(0, path)


def remove_sys_path(path):

	path = get_parent_dir() + path
	if path in sys.path:
		sys.path.remove(path)


def exists_model_content(filename):

	found = False
	with open(filename) as f:
		if 'models.Model' in f.read():
			found = True
	return found


def get_apps():

	list_all_apps = []
	add_sys_path("/project")
	from settings import AUTOSTARTMIGRATE
	for app in AUTOSTARTMIGRATE:
		list_all_apps.append(app)

	list_apps = {}  # app -> file
	for app in list_all_apps:
		if "apps." not in app:  # si la app no está prefijada con apps, no añadir a la lista
			continue
		app_file = app.replace(".", "/")  # calcular el nombre del fichero de la app
		app_migrate_path = app_file + "/migrations"  # calcular la carpeta migrates de la app
		app_file_model = get_parent_dir() + "/" + app_file + "/models.py"  # calcular el nombre del modelo del fichero de la app
		if not os.path.isfile(app_file_model):  # si el fichero model.py de la app no existe, no añadir a la lista
			continue
		if not exists_model_content(app_file_model):  # si el fichero model.py de la app no contiene 'models.Model', no añadir a la lista
			continue
		# print(app_file_model)
		list_apps[app] = app_migrate_path  # añadir la app a la lista
	# print(list_apps)

	return list_apps
