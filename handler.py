import json

from hello import get_hello

def hello(event, context):
    hello = get_hello()
    body = {
        "message": str(hello),
        "input": event
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """

if __name__ == '__main__':
    print(hello('yup', 'context'))
