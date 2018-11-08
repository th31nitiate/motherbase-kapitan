# -*- coding: utf-8 -*-
from __future__ import absolute_import
import salt

import logging

log = logging.getLogger(__name__)


def write_certs(vault_response, name, output):
    ##create outpath if not exists


    f = open(output + name + "cert.pem", "w")
    f.write(str(vault_response['certificate']))
    f.close 
    f = open(output + name + ".ca.pem", "w")
    f.write(str(vault_response['issuing_ca']))
    f.close 
    f = open(output + name + "key.pem", "w")
    f.write(str(vault_response['private_key']))
    f.close 

def generate_cert(path, output, **kwargs):
    log.debug('Writing vault secrets for %s at %s', __grains__['id'], path)
    print kwargs
    data = dict([(x, y) for x, y in kwargs.items() if not x.startswith('__')])
    try:
        url = 'v1/{0}'.format(path)
        response = __utils__['vault.make_request']('POST', url, json=data)
        if response.status_code == 200:
            write_certs(response.json()['data'], data['name'], output)
            return response.json()['data']
        elif response.status_code != 204:
            response.raise_for_status()
        return True
    except Exception as err:
        log.error('Failed to write secret! %s: %s', type(err).__name__, err)
        return response
