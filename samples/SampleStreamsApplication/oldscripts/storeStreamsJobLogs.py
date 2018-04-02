# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import sys
import json
import streamsx.rest
import streamsx_rest_additions

serviceName = 'MyStreamingAnalytics'

applicationName = 'MyStreamsApplication::Main'

connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services='vcap.json', service_name=serviceName)
for instance in connection.get_instances():
    print('Streaming Analytics service ' + connection.service_name + ' is ' + instance.status + ' and ' + instance.health)
    for job in instance.get_jobs():
        if job.applicationName == applicationName:
            tarballFilename = 'logs.' + job.name + '.tar.gz'
            result = job.store_logs(tarballFilename)
            print( ( 'job ' + job.name + ' logs stored in ' + tarballFilename ) if result else ( 'could not store logs for job ' + job.name ) )

sys.exit(0)
