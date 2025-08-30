import boto3
import os
import gzip
import shutil
from datetime import datetime

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    logs_client = boto3.client('logs')
    bucket = os.environ['S3_BUCKET']
    log_group = event.get('log_group', '/aws/lambda/example')
    start_time = int((datetime.utcnow().timestamp() - 7*24*3600) * 1000)
    end_time = int(datetime.utcnow().timestamp() * 1000)

    streams = logs_client.describe_log_streams(logGroupName=log_group)['logStreams']
    for stream in streams:
        log_stream_name = stream['logStreamName']
        events = logs_client.get_log_events(
            logGroupName=log_group,
            logStreamName=log_stream_name,
            startTime=start_time,
            endTime=end_time,
            startFromHead=True
        )
        log_data = '\n'.join([e['message'] for e in events['events']])
        if log_data:
            file_name = f"{log_group.replace('/', '_')}_{log_stream_name.replace('/', '_')}_{start_time}_{end_time}.log.gz"
            with open(f"/tmp/{file_name}", "wb") as f_out:
                with gzip.GzipFile(fileobj=f_out, mode="wb") as gz:
                    gz.write(log_data.encode('utf-8'))
            s3.upload_file(f"/tmp/{file_name}", bucket, file_name)
            os.remove(f"/tmp/{file_name}")
    return {'status': 'done'}