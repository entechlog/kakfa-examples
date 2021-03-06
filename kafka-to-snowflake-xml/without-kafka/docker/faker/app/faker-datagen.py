#!/usr/bin/env python

from faker import Faker
import json
import sys, getopt, time, os
import argparse
import time
from datetime import datetime
from json2xml import json2xml
from json2xml.utils import readfromurl, readfromstring, readfromjson
import boto3

def main():
    # Display the program start time
    print('-' * 40)
    print(os.path.basename(sys.argv[0]) + " started at ", time.ctime())
    print('-' * 40)

    print('Number of arguments          :', len(sys.argv))
    print('Argument List:', str(sys.argv))

    parser = argparse.ArgumentParser(description="""
    script generates sample data
    """)
    parser.add_argument("--no_of_records", help="Number of records", type=int, required=True)
    parser.add_argument("--loop_delay", help="Loop delay", type=int, required=True)
    parser.add_argument("--s3_prefix", help="S3 prefifx", required=True)

    args = parser.parse_args()

    global no_of_records
    no_of_records = args.no_of_records

    global loop_delay
    loop_delay = args.loop_delay

    global s3_prefix
    s3_prefix = args.s3_prefix

    print("Number of records            : " + str(no_of_records))
    print("Loop delay                   : " + str(loop_delay))
    print("S3 Prefix                    : " + str(s3_prefix))

    # S3 details
    global ACCESS_KEY
    ACCESS_KEY = os.environ.get("S3_ACCESS_KEY")
    global SECRET_KEY
    SECRET_KEY  = os.environ.get("S3_SECRET_KEY")
    global BUCKET_NAME
    BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")

def upload_to_aws(data, bucket, s3_file):
    s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY,
                      aws_secret_access_key=SECRET_KEY)

    try:
        s3.put_object(Body=data, Bucket=bucket, Key=s3_file)
        print("Upload Successful")
        return True
    except FileNotFoundError:
        print("The file was not found")
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False

class DatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        try:
            return super(DatetimeEncoder, obj).default(obj)
        except TypeError:
            return str(obj)

def faker_datagen():

    faker = Faker()
    count = 0
    while count < no_of_records:
        profile = faker.simple_profile()
        message = json.dumps(profile, cls=DatetimeEncoder)
        # get the xml from a json string
        data = readfromstring(message)
        message_xml = json2xml.Json2xml(data, pretty=True, attr_type=False).to_xml()
        key=str(profile['username'])

        s3_key = "snowflake-xml-demo/" + s3_prefix + "/year=" + str(datetime.now().strftime('%Y')) + "/month=" + str(datetime.now().strftime('%m')) + "/day=" + str(datetime.now().strftime('%d')) + "/hour=" + str(datetime.now().strftime('%H')) + "/" + key + ".xml"

        uploaded = upload_to_aws(data=message_xml, bucket=BUCKET_NAME, s3_file=s3_key)

        count += 1
        print("Sleep Counter                : " + str(count))
        time.sleep(loop_delay)
    print("Finished Processing")

if __name__ == "__main__":
    main()
    faker_datagen()
    sys.exit()
