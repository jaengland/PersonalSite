import pytest
import boto3
from moto import mock_s3, mock_dynamodb
from infrastructure.modules.lambda_gen_pages.src.lambda_function import upload_html, \
    generate_html, create_project_line, retrieve_content


# Mock logger for testing purposes
class MockLogger:
    def debug(self, msg):
        print(msg)


logger = MockLogger()


@pytest.mark.unit
@mock_s3
def test_upload_html():
    # Set up the mock environment
    s3_bucket = 'my-test-bucket'
    html_result = '<html><body>A test HTML content</body></html>'

    conn = boto3.resource('s3', region_name='us-east-1')
    conn.create_bucket(Bucket=s3_bucket)

    # Call the function
    response = upload_html(s3_bucket, html_result)

    # Validate the results
    assert response['ResponseMetadata']['HTTPStatusCode'] == 200

    # Check if object exists in bucket
    bucket = conn.Bucket(s3_bucket)
    objects = list(bucket.objects.filter(Prefix='projects.html'))
    assert len(objects) == 1
    assert objects[0].key == 'projects.html'


@pytest.mark.unit
def test_create_project_line():
    project = {
        "name": "MyProject",
        "project_url": "https://example.com",
        "project_description": "This is a test project"
    }

    expected_html = '<li style="width:33%"><a href=https://example.com>MyProject</a></li>'
    expected_html += '<li style="width:66%">This is a test project</li>'

    assert create_project_line(project) == expected_html


@pytest.mark.unit
def test_generate_html():
    projects = [
        {
            "name": "Project1",
            "project_url": "https://project1.com",
            "project_description": "Description 1"
        },
        {
            "name": "Project2",
            "project_url": "https://project2.com",
            "project_description": "Description 2"
        }
    ]

    expected_html = "<ul>"
    for project in projects:
        expected_html += create_project_line(project=project)
    expected_html += "</ul>"

    assert generate_html(projects) == expected_html


@pytest.mark.unit
@mock_dynamodb
def test_retrieve_content():
    # Create mock DynamoDB table
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    dynamodb.create_table(
        TableName='test_table',
        KeySchema=[
            {'AttributeName': 'type', 'KeyType': 'HASH'},
            {'AttributeName': 'name', 'KeyType': 'RANGE'}
        ],
        AttributeDefinitions=[
            {'AttributeName': 'type', 'AttributeType': 'S'},
            {'AttributeName': 'name', 'AttributeType': 'S'}
        ],
        ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
    )

    # Put sample item in the table
    table = dynamodb.Table('test_table')
    table.put_item(Item={'type': 'test_type', 'name': 'myproject', 'content': 'test_content'})

    # Call the function
    response = retrieve_content(
        dynamo_client=dynamodb,
        dynamo_table='test_table',
        query='test_type'
    )

    # Assertions
    assert 'Items' in response
    assert len(response['Items']) == 1
    assert response['Items'][0]['content'] == 'test_content'
