# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import sys
import streamsx.rest

serviceName = 'MyStreamingAnalytics'

# stop the Streams instance, if its not already stopped

connection = streamsx.rest.StreamingAnalyticsConnection(vcap_services='vcap.json', service_name=serviceName)
service = connection.get_streaming_analytics()
result = service.stop_instance()
print('Streaming Analytics service ' + connection.service_name + ' is ' + result['state'])

sys.exit(0)

