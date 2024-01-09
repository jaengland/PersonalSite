import json
import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(os.environ.get("logging_level", "INFO"))


def lambda_handler(event: json, context: json):
    """
    AWS Event handler to create a new projects.html for display

    :param event: AWS Lambda event
    :param context: AWS Lambda context
    :return: "Success"
    """
    # Initial state
    logger.debug("## Event and Context")
    logger.debug(event)
    logger.debug(context)

    # Environment variables
    dynamo_table = os.environ['dynamo_table']
    s3_bucket = os.environ['s3_bucket']
    logger.debug("## Environment Variables")
    logger.debug(dynamo_table)
    logger.debug(s3_bucket)

    # Connect to DynamoDB and retrieve data
    query = "Project"  # temporarily hard code this
    dynamodb = boto3.resource('dynamodb')
    response = retrieve_content(
        dynamo_client=dynamodb,
        dynamo_table=dynamo_table,
        query=query
    )
    logger.debug("## Dynamo Results")
    logger.debug(response)

    # Generate HTML content
    html_content = generate_html(response['Items'])
    logger.debug(html_content)

    # get template contents and update
    with open("./projects.html", "r") as f:
        template = f.read()
    html_result = template.replace("$$ProjectsHere$$", html_content)

    # Upload to s3
    response = upload_html(s3_bucket=s3_bucket, html_result=html_result)
    logger.debug(response)

    return response


def retrieve_content(dynamo_client, dynamo_table: str, query: str):
    table = dynamo_client.Table(dynamo_table)
    response = table.query(
        KeyConditionExpression="page_type = :query_value",
        ExpressionAttributeValues={":query_value": query}
    )
    logger.debug("## Dynamo Results")
    logger.debug(response)
    return response


def generate_html(items: list):
    html_content = "<ul>"
    for project in items:
        html_content += create_project_line(project=project)
    html_content += "</ul>"

    return html_content


def create_project_line(project: dict):
    """
    Function to create each project entry
    :param project: json from DynamodDb Result
    :return: string
    """
    html = f'<li style="width:90%"><a class="project" href={project["project_url"]}>{project["item_name"]}</a>'
    html += f'  -  {project["project_description"]}</li><br>\n'

    return html


def upload_html(s3_bucket: str, html_result: str):
    s3_client = boto3.client("s3")
    response = s3_client.put_object(
        Bucket=s3_bucket,
        Key="projects.html",
        Body=html_result
    )
    return response
