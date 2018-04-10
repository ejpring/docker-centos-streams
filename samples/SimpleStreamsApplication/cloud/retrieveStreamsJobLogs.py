# Copyright (C) 2017, 2018  International Business Machines Corporation
# All Rights Reserved

import os
import sys
import json
import streamsx.rest

################### parameters used in this script ############################

here = os.path.dirname(os.path.realpath(__file__))

vcapFilename = here + '/vcap.json'

applicationName = 'SimpleStreamsApplication::Main'

###############################################################################

# get the name of the first Streaming Analytics service in the 'vcap.json' file
with open(vcapFilename) as file: vcap = json.load(file)
serviceName = vcap['streaming-analytics'][0]['name']

# get a connection to the Streaming Analytics service
connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services=vcapFilename, service_name=serviceName)

# get logs for running applications
for instance in connection.get_instances():
    print('Streaming Analytics service \'' + connection.service_name + '\' is ' + instance.status + ' and ' + instance.health)
    for job in instance.get_jobs():
        if job.applicationName == applicationName:
            tarballFilename = 'logs.' + job.name + '.tar.gz'
            result = job.retrieve_log_trace(tarballFilename)
            print( ( 'job \'' + job.name + '\' is ' + job.status + ' and ' + job.health + ', logs stored in \'' + tarballFilename + '\'' ) if result else ( 'could not store logs for job ' + job.name ) )

sys.exit(0)
