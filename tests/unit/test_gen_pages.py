import boto3
import pytest
from moto import mock_dynamodb, mock_s3
import sys

from src.gen_pages.lambda_function import (retrieve_content, generate_html,
                                           create_project_line, upload_html)


@pytest.fixture
def aws_credentials():
    """Mocked AWS Credentials for moto."""
    return {
        "aws_access_key_id": "testing",
        "aws_secret_access_key": "testing",
        "region_name": "us-west-2"
    }


@pytest.fixture
def dynamo_client(aws_credentials):
    """Create a mocked DynamoDB client."""
    with mock_dynamodb():
        yield boto3.client("dynamodb", **aws_credentials)


@pytest.fixture
def dynamo_resource(aws_credentials):
    """Create a mocked DynamoDB client."""
    with mock_dynamodb():
        yield boto3.resource("dynamodb", **aws_credentials)


@pytest.fixture
def create_table(dynamo_client):
    """Create a mock DynamoDB table."""
    table_name = "test_table"
    dynamo_client.create_table(
        TableName=table_name,
        KeySchema=[{"AttributeName": "page_type", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "page_type", "AttributeType": "S"}],
        ProvisionedThroughput={"ReadCapacityUnits": 1, "WriteCapacityUnits": 1}
    )

    # Populate the table with a test item
    dynamo_client.put_item(
        TableName=table_name,
        Item={"page_type": {"S": "test_query"}, "content": {"S": "test_content"}}
    )
    return table_name


@pytest.mark.unit
def test_retrieve_content(dynamo_resource, create_table):
    # Call the function under test
    result = retrieve_content(dynamo_resource, create_table, "test_query")

    content = result["Items"][0]["content"]
    # Assertions
    assert "Items" in result
    assert len(result["Items"]) == 1
    assert content == "test_content"


@pytest.mark.unit
def test_create_project_line():
    project = {
        "item_name": "Project1",
        "project_url": "https://project1.com",
        "project_description": "Description of Project1"
    }
    expected_html = '<li style="width:90%"><a class="project" href=https://project1.com>Project1</a>  -  Description of Project1</li><br>\n'
    assert create_project_line(project) == expected_html


@pytest.mark.unit
def test_generate_html():
    projects = [
        {
            "item_name": "Project1",
            "project_url": "https://project1.com",
            "project_description": "Description of Project1"
        },
        {
            "item_name": "Project2",
            "project_url": "https://project2.com",
            "project_description": "Description of Project2"
        }
    ]
    expected_html = "<ul>"
    for project in projects:
        expected_html += create_project_line(project)
    expected_html += "</ul>"

    assert generate_html(projects) == expected_html


@pytest.fixture
def s3_setup(aws_credentials):
    with mock_s3():
        s3_client = boto3.client('s3', region_name="us-east-1")
        s3_client.create_bucket(Bucket="test-bucket")
        yield s3_client


@pytest.mark.unit
def test_upload_html(s3_setup):
    html_content = "<html><body>Test Content</body></html>"
    bucket_name = "test-bucket"

    response = upload_html(bucket_name, html_content)

    # Assert that the put_object operation was successful
    assert response['ResponseMetadata']['HTTPStatusCode'] == 200

    # Verify the object exists in the bucket
    obj = s3_setup.get_object(Bucket=bucket_name, Key="projects.html")
    assert obj['Body'].read().decode() == html_content
