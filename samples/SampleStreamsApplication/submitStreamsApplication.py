# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import sys
import json
import streamsx.rest
import streamsx_rest_additions

applicationName = 'MyStreamsApplication::Main'

sabFilename = "./output/MyStreamsApplication.Main.sab"

serviceCredentialsFile = './vcap.json'

jobOptions = {
    'jobConfigOverlays': [
        { 'jobConfig': {
            'submissionParameters': [
                { "name": "iterationCount", "value": "1" },
                { "name": "iterationInterval", "value": "1.0" },
                { "name": "stringParameter", "value": "Hello, world" },
                { "name": "integerParameter", "value": "42" },
                { "name": "floatParameter", "value": "3.14159" },
                { "name": "booleanParameter", "value": "true" },
                { "name": "listParameter", "value": "[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]" },
                { "name": "mapParameter", "value": "{200: 'OK', 301: 'Moved Permanently', 408: 'Request Timeout', 501: 'Not Implemented'}" } ],
            'tracing': "info" },
          'deploymentConfig': {
              'fusionScheme': "manual",
              'fusionTargetPeCount': 1 }
        }
    ]
}

with open(serviceCredentialsFile) as file: serviceCredentials = json.load(file)
serviceName = serviceCredentials['streaming-analytics'][0]['name']

connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services=serviceCredentials, service_name=serviceName)
service = connection.get_streaming_analytics()
status = service.get_instance_status()
print('Streaming Analytics service ' + connection.service_name + ' is ' + status['state'] + ' and ' + status['status'])

result = service.submit_application(applicationName, sabFilename, jobOptions)
print('job ' + result['name'] + ' submitted')

sys.exit(0)
