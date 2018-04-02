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
            for pe in job.get_pes():
                logFilename = pe.store_console_log('logs.' + job.name + '.PE_' + pe.id + '.log')
                print( 'job ' + job.name + ' PE ' + pe.id + ' console log stored in ' + logFilename )
                traceFilename = pe.store_application_trace('logs.' + job.name + '.PE_' + pe.id + '.trace')
                print( 'job ' + job.name + ' PE ' + pe.id + ' application trace stored in ' + traceFilename )

sys.exit(0)
