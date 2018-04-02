# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import sys
import streamsx.rest

serviceName = 'MyStreamingAnalytics'

connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services='vcap.json', service_name=serviceName)
for instance in connection.get_instances():
    print('Streaming Analytics service ' + connection.service_name + ' is ' + instance.status + ' and ' + instance.health)
    for job in instance.get_jobs():
        print('job ' + job.name + ' is ' + job.status + ' and ' + job.health)

sys.exit(0)
