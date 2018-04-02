# Copyright (C) 2017  International Business Machines Corporation
# All Rights Reserved

import json
import types
import pprint
import streamsx.rest

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def _streamsx_rest_StreamingAnalyticsService_submit_application(self, applicationName, sabFile, jobOptions):
    """Submit a compiled Streams Application Bundle (a SAB file) to run in this Streamin Analytics service.

    Args:
    applicationName (string): name of the application in the SAB file
    sabFile (string): path to the compiled SAB file containing the application to be submitted
    jobOptions (dict): job overlay object with submission parameters and deployment configuration
    
    Returns:
    dict: JSON response with name of submitted job
    """

    jobURL = self._get_url('jobs_path')

    jobParameters = { 'bundle_id': applicationName + ".sab" }

    jobFiles = [
        ('sab_file', ( applicationName,  open(sabFile, 'rb'), 'application/octet-stream' ) ),
        ('job_options', ( 'job_options', json.dumps(jobOptions), 'application/json' ) )
    ]
    
    return self.rest_client.session.post(url=jobURL, params=jobParameters, files=jobFiles).json()

if not hasattr(streamsx.rest.StreamingAnalyticsService, 'submit_application'):
    streamsx.rest.StreamingAnalyticsService.submit_application = _streamsx_rest_StreamingAnalyticsService_submit_application

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def _streamsx_rest_primitives_ResourceElement_store_file(self, filename, url, mimetype):
    """Get a log from a running job or PE and store it in a file.

    Args:
    filename (string): path to the file where the log should be stored
    url (string): URL of the log to be stored in the file
    mimetype (string): expected MimeType of the log
    
    Returns:
    string: path to the file where the log was stored

    Exceptions:
    HTTP GET failed, error xxx xxxxxxxxxxxxx from URL xxxxxxxxxxxxxxxx
    HTTP GET expected response content of type xxxx/xxxx, got xxxxx/xxxxxx, from URL xxxxxxxxxxxxxx
    """

    response = self.rest_client.session.get(url=url, stream=True)

    if response.status_code != 200:
        raise Exception('HTTP GET failed, error ' + str(response.status_code) + ' ' + response.reason + ' from URL ' + response.url)

    if not response.headers['Content-Type'].startswith(mimetype):
        raise Exception('HTTP GET expected response content of type ' + mimetype + ', got ' + response.headers['Content-Type'] + ', from URL ' + response.url)

    with open(filename, 'wb') as file:
        for chunk in response.iter_content(chunk_size=None):
            file.write(chunk)    
    
    return filename

if not hasattr(streamsx.rest_primitives._ResourceElement, '_store_file'):
    streamsx.rest_primitives._ResourceElement._store_file = _streamsx_rest_primitives_ResourceElement_store_file

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def _streamsx_rest_primitives_Job_store_logs(self, tarFilename):
    """Get the console logs and application traces from a running job and store them in a compressed 'tar' archive.

    Args:
    tarFilename (string): path to the compreseed 'tar' archive where the logs and traces should be stored
    
    Returns:
    string: path to the compressed 'tar' archive where the logs and traces were stored

    Exceptions:
    HTTP GET failed, error xxx xxxxxxxxxxxxx from URL xxxxxxxxxxxxxxxx
    HTTP GET expected response content of type application/x-compressed, got xxxxx/xxxxxx, from URL xxxxxxxxxxxxxx
    """

    return self._store_file(tarFilename, self.applicationLogTrace, 'application/x-compressed')
    
if not hasattr(streamsx.rest_primitives.Job, 'store_logs'):
    streamsx.rest_primitives.Job.store_logs = _streamsx_rest_primitives_Job_store_logs

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
def _streamsx_rest_primitives_PE_store_console_log(self, logFilename):
    """Get the console log from a running PE and store it in an uncompressed text file.

    Args:
    logFilename (string): path to the text file where the console log should be stored
    
    Returns:
    string: path to the text file where the console log was stored

    Exceptions:
    HTTP GET failed, error xxx xxxxxxxxxxxxx from URL xxxxxxxxxxxxxxxx
    HTTP GET expected response content of type text/plain', got xxxxx/xxxxxx, from URL xxxxxxxxxxxxxx
    """

    return self._store_file(logFilename, self.consoleLog, 'text/plain')

if not hasattr(streamsx.rest_primitives.PE, 'store_console_log'):
    streamsx.rest_primitives.PE.store_console_log = _streamsx_rest_primitives_PE_store_console_log

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def _streamsx_rest_primitives_PE_store_application_trace(self, traceFilename):
    """Get the application trace from a running PE and store it in an uncompressed text file.

    Args:
    logFilename (string): path to the text file where the application trace should be stored
    
    Returns:
    string: path to the text file where the application trace was stored

    Exceptions:
    HTTP GET failed, error xxx xxxxxxxxxxxxx from URL xxxxxxxxxxxxxxxx
    HTTP GET expected response content of type text/plain', got xxxxx/xxxxxx, from URL xxxxxxxxxxxxxx
    """

    return self._store_file(traceFilename, self.applicationTrace, 'text/plain')

if not hasattr(streamsx.rest_primitives.PE, 'store_application_trace'):
    streamsx.rest_primitives.PE.store_application_trace = _streamsx_rest_primitives_PE_store_application_trace

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
