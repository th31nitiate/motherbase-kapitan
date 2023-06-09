import salt.exceptions
import os

def check_state(state, **kwargs):
    data = dict([(x, y) for x, y in kwargs.items() if not x.startswith('__')])

    if 'common_name' in data.keys() and data['common_name'] != state['Subject']['CN']:
        return False
    if 'key_usage' in data.keys() and data['key_usage'] != state['X509v3 Extensions']['keyUsage'].split(", "):
        return False
    if 'extkey_usage' in data.keys() and data['extkey_usage'] != state['X509v3 Extensions']['extendedKeyUsage'].split(", "):
        return False
    
    return True

def generate_vault_certificate(file_path, vault_path, write=True, **kwargs):

    data = dict([(x, y) for x, y in kwargs.items() if not x.startswith('__')])

    ret = {
        'name': file_path,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
        }

    # Start with basic error-checking. Do all the passed parameters make sense
    # and agree with each-other?
    if write == True and os.access(vault_path, os.W_OK):
        raise salt.exceptions.SaltInvocationError(
            'File path is not writable')

    # Check the current state of the system. Does anything need to change?

    current_state = __salt__['x509.read_certificate'](file_path + "public.key")
    if check_state(current_state, **kwargs) == True:
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret

    # The state of the system does need to be changed. Check if we're running
    # in ``test=true`` mode.
    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(vault_path)
        ret['pchanges'] = {
            'old': current_state,
            'new': data,
        }

        # Return ``None`` when running with ``test=true``.
        ret['result'] = None

        return ret

    # Finally, make the actual change and return the result.
    __salt__['merlin.generate_cert'](vault_path, file_path, **kwargs)

    new_state = __salt__['x509.read_certificate'](file_path + "public.key")

    ret['comment'] = 'The state of "{0}" was changed!'.format(vault_path)

    ret['changes'] = {
        'old': current_state,
        'new': new_state,
    }

    ret['result'] = True

    return ret