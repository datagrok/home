from storyville.conf.sites import *
import logging

## This is kinda slow
DEBUG = True

CELERYD_LOG_LEVEL = logging.DEBUG
DATABASES['default']['NAME'] = 'medley_local'
DATABASES['read_slave']['NAME'] = DATABASES['default']['NAME']
DATABASES['read_slave']['USER'] = DATABASES['default']['USER']
DATABASES['read_slave']['PASSWORD'] = DATABASES['default']['PASSWORD']
DATABASES['default']['TEST_TEMPLATE_NAME'] = 'test_storyville_template'

foo = 'bar'
