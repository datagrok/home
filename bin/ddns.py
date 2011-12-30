#!/usr/bin/python

from os import environ
from sys import argv, path
path.append('/home/datagrok/lib/python')
from datagrok.dreamhostapi import main

if __name__ == "__main__":

    try:
        if 'SSH_ORIGINAL_COMMAND' in environ:
            _, key, hostname = environ['SSH_ORIGINAL_COMMAND'].split()
        else:
            _, key, hostname = argv
    except ValueError:
        raise SystemExit("Error: api key and hostname are required arguments.")

    main(key, hostname)
