import boto3, os, logging, uuid
from PIL import Image, ImageOps
from urllib.parse import unquote_plus

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

DST_BUCKET = os.environ.get('DST_BUCKET')
REGION = os.environ.get('REGION')

s3_client = boto3.client('s3')

def strip_exif_and_copy(image_path, file_path, src_bucket, object_tags=[]):
    try:
        with Image.open(image_path) as image:
            image_contents = list(image.getdata())
            try:
                original  = ImageOps.exif_transpose(image)
            except Exception as e:
                print(e)
                print('Unable to transpose {}.'.format(image_path))
                return
            stripped = Image.new(original.mode, original.size)
            stripped.putdata(list(original.getdata()))
            try:
                stripped.save(image_path)
            except Exception as e:
                print(e)
                print('Unable to overwrite {}.'.format(image_path))
                return
            try:
                s3_client.upload_file(image_path, DST_BUCKET, file_path)
            except Exception as e:
                print(e)
                print('Unable to upload {} to {} at {}.'.format(image_path, DST_BUCKET, file_path))
                return
            try:
                object_tags.append({'Key':'ExifRemoved', 'Value': 'True'})
                s3_client.put_object_tagging(
                    Bucket=src_bucket,
                    Key=file_path,    
                    Tagging={
                        'TagSet': object_tags
                    }
                )
            except Exception as e:
                print(e)
                print('Unable to set tags to the object {} stored in {}.'.format(file_path, DST_BUCKET))

    except Exception as e:
        print(e)
        print('Error getting object {}.'.format(image_path))
        return

def lambda_handler(event, context):
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        file_path = unquote_plus(record['s3']['object']['key'], encoding='utf-8')
        file_name, file_extension = os.path.splitext(file_path)

        if file_extension.lower() not in ['.jpg']:
            print('Duh! {} from bucket {} is not a .jpg file.'.format(file_path, bucket_name))
            return

        try:
            tagging = s3_client.get_object_tagging(Bucket=bucket_name, Key=file_path)
        except Exception as e:
            print(e)
            print('Error getting object tags for {} from bucket {}.'.format(file_path, bucket_name))
            return

        object_tags = tagging['TagSet']
        for tag in object_tags:
            if tag['Key'] == 'ExifRemoved' and tag['Value'] == 'True':
                print('Already Exifstrippyfied so bailing early for {} from bucket {}.'.format(file_path, bucket_name))
                return

        tmpkey = file_path.replace('/', '')
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), tmpkey)

        try:
            s3_client.download_file(bucket_name, file_path, download_path)
        except Exception as e:
            print(e)
            print('Unable to download file {} form {} to {} location.'.format(file_path, bucket_name, download_path))
            return

        strip_exif_and_copy(download_path, file_path, bucket_name, object_tags)