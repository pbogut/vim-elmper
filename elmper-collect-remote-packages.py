#!/bin/env python
import json
import requests
from sys import stdout

packages_file = 'elm-remote-packages.json'

current_packages = json.loads(open(packages_file).read())


def get_packages():
    r = requests.get('http://package.elm-lang.org/all-packages')
    return r.json()


def get_package_details(name):
    r = requests.get('http://package.elm-lang.org/packages/' +
                     name + '/latest/documentation.json')
    return r.json()


def get_package_modules(name):
    data = get_package_details(name)
    modules = [module['name'] for module in data]
    return modules


def show_progress(current, total):
    stdout.write("\r                          ")
    if total > 0:
        progress = round(current * 100 / total, 2)
        stdout.write("\rProgress: " + str(progress) + '%')
    else:
        stdout.write("\rProgress: NaN")


packages = get_packages()
total = len(packages)
current = 0
new_packages = []
for package in get_packages():
    current = current + 1

    matches = [
        x for x in current_packages if x['name'] == package['name']]

    if len(matches) > 0 and matches[0]['latest'] == package['versions'][0]:
        new_packages.append(matches[0])
    else:
        new_entry = {'name': package['name'],
                     'latest': package['versions'][0],
                     'modules': get_package_modules(package['name'])}
        new_packages.append(new_entry)

    show_progress(current, total)

with open(packages_file, 'w') as f:
    f.write(json.dumps(new_packages, indent=2))
