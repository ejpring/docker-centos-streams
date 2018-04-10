# Copyright (C) 2017, 2018  International Business Machines Corporation
# All Rights Reserved

import os
import sys
import json
import streamsx.rest

################### parameters used in this script ############################

here = os.path.dirname(os.path.realpath(__file__))

vcapFilename = here + '/vcap.json'

###############################################################################

# get the name of the first Streaming Analytics service in the 'vcap.json' file
with open(vcapFilename) as file: vcap = json.load(file)
serviceName = vcap['streaming-analytics'][0]['name']

# get a connection to the Streaming Analytics service
connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services=vcapFilename, service_name=serviceName)

# stop the Streaming Analytics service and then display its health and status
result = connection.get_streaming_analytics().stop_instance()
print('Streaming Analytics service \'' + connection.service_name + '\' is ' + result['state'] + ' and ' + result['status'])

sys.exit(0)
