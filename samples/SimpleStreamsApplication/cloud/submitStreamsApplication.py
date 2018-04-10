# Copyright (C) 2017, 2018  International Business Machines Corporation
# All Rights Reserved

import os
import sys
import json
import streamsx.scripts.runner 

################### parameters used in this script ############################

here = os.path.dirname(os.path.realpath(__file__))

vcapFilename = here + '/vcap.json'

applicationBundle = here + '/../output/SimpleStreamsApplication.Main.sab'

applicationParameters = [
    'iterationCount=1',
    'iterationInterval=1.0',
    'stringParameter=Hello, world',
    'integerParameter=42',
    'floatParameter=3.14159',
    'booleanParameter=true',
    'listParameter=[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]',
    'mapParameter={ 200: \'OK\', 301: \'Moved Permanently\', 408: \'Request Timeout\', 501: \'Not Implemented\' }'
]

traceLevel = 'info'

###############################################################################

# make sure the application has been compiled
if not os.path.isfile(applicationBundle):
    raise ValueError('sorry, application bundle \'' + applicationBundle + '\' not found')

# get the name of the first Streaming Analytics service in the 'vcap.json' file
with open(vcapFilename) as file: vcap = json.load(file)
serviceName = vcap['streaming-analytics'][0]['name']

# store contents of 'vcap.json' file in environment variable
with open(vcapFilename) as file: os.environ['VCAP_SERVICES'] = file.read()

# create a list of command-line arguments for the Streams 'runner'
sys.argv = [ 'submitStreamsApplication.py',
             '--service-name', serviceName,
             '--bundle', applicationBundle,
             '--trace', traceLevel,
             '--submission-parameters' ] + applicationParameters

# submit the bundle to the Streaming Analytics service
result = streamsx.scripts.runner.main()

# display the job name if the submission was successful
if result['return_code']==0:
    print('job \'' + result['name'] + '\' submitted and ' + result['health'])
else:
    print('submit failed for application bundle \'' + applicationBundle + '\:')
    print(result)
    
sys.exit(result['return_code'])
