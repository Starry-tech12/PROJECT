def handler(event, context):
    for record in event.get('Records', []):
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        print(f"Image received: {key} from bucket: {bucket}")
    return {"statusCode": 200, "body": "Success"}
