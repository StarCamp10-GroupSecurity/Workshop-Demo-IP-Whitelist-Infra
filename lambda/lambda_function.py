import pymysql
import json

def lambda_handler(event, context):
    try:
        endpoint = '14.225.210.134'
        username = 'root'
        password = 'thegatekeeper'
        database_name = 'users'
        port = 3307  # Use an integer for the port

        # Attempt to connect to the database
        connection = pymysql.connect(
            host=endpoint,
            user=username,
            password=password,
            database=database_name,
            port=port
        )

        # If the connection is successful, return a success message
        connection.close()
        
        return {
            "statusCode": 200,
            "body": json.dumps("Connection successful!")
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})  # Serialize error message
        }