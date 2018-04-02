# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import sys
import streamsx.rest

serviceName = 'MyStreamingAnalytics'

applicationName = 'MyStreamsApplication::Main'

connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services='vcap.json', service_name=serviceName)
for instance in connection.get_instances():
    print('Streaming Analytics service ' + connection.service_name + ' is ' + instance.status + ' and ' + instance.health)
    for job in instance.get_jobs():
        if job.applicationName == applicationName:
            result = job.cancel()
            print( ( 'job ' + job.name + ' canceled' ) if result else ( 'could not cancel job ' + job.name ) )
            
sys.exit(0)






















