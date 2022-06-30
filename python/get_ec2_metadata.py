#!/usr/bin/env python

import requests
import json

def load_metadata(key):
    metaurl = 'http://169.254.169.254/latest'

    metadict = {'dynamic': {}, 'meta-data': {}, 'user-data': {}}

    for subsect in metadict.keys():
        data_scarp('{0}/{1}/'.format(metaurl, subsect), metadict[subsect])

    return next(find_item(metadict, key), metadict)

def find_item(obj, field):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == field:
                yield v
            elif isinstance(v, dict) or isinstance(v, list):
                yield from find_item(v, field)
    elif isinstance(obj, list):
        for v in obj:
            yield from find_item(v, field)

def data_scarp(url, d ):
    r = requests.get(url)
    if r.status_code == 404:
        return

    for item in r.text.split('\n'):
        if not item:
            continue
        newurl = '{0}{1}'.format(url, item)

        if item.endswith('/'):
            newkey = item.split('/')[-2]

            d[newkey] = {}
            data_scarp(newurl, d[newkey])
        else:
            r = requests.get(newurl)
            if r.status_code != 404:
                try:
                    d[item] = json.loads(r.text)
                except ValueError:
                    d[item] = r.text
            else:
                d[item] = None

if __name__ == '__main__':
    key = input("Enter the key:")
    print(json.dumps(load_metadata(key), indent=4))