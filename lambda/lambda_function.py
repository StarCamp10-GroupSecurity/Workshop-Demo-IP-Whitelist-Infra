import pymysql
import json
import re

def lambda_handler(event, context):
    try:
        data_dict = json.loads(event['body'])
        email = data_dict["email"]
        endpoint = '14.225.210.134'
        username = 'root'
        password = 'thegatekeeper'
        database_name = 'workshop'
        port = 3307  # Use an integer for the port

        # Attempt to connect to the database
        connection = pymysql.connect(
            host=endpoint,
            user=username,
            password=password,
            database=database_name,
            port=port
        )
        
        # Validate the email
        if not is_valid_email(email):
            return {
                "statusCode": 200,
                "body": json.dumps({"description": "invalid email address."}),
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",  # Allow all origins or specify your domain
                    "Access-Control-Allow-Methods": "OPTIONS, POST, GET",  # Allowed methods
                    "Access-Control-Allow-Headers": "Content-Type"  # Allowed headers
                }
            }
        
        with connection.cursor() as cursor:
            # Select a user by email
            select_query = "SELECT description FROM users WHERE email = %s;"
            cursor.execute(select_query, (email,))
            result = cursor.fetchall()
            print(type(result))
            print(result)
            if not result:
                return {
                    "statusCode": 200,
                    "body": json.dumps({
                        "description": "Hey there! So we haven't really formed any specific impression about you yet... mostly because we've been as social as potted plants! Total shame we haven't chatted much or hung out - let's do more in the future. Wishing you a cheerful day and a wild adventure at NAB!"
                    }),
                    "headers": {
                        "Content-Type": "application/json",
                        "Access-Control-Allow-Origin": "*",  # Allow all origins or specify your domain
                        "Access-Control-Allow-Methods": "OPTIONS, POST, GET",  # Allowed methods
                        "Access-Control-Allow-Headers": "Content-Type"  # Allowed headers
                    }
                }
            # Print the results
            description = None
            for row in result:
                description = row[0]
            

        # If the connection is successful, return a success message
        connection.close()
        
        return {
                "statusCode": 200,
                "body": json.dumps({
                    "description": description
                }),
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",  # Allow all origins or specify your domain
                    "Access-Control-Allow-Methods": "OPTIONS, POST, GET",  # Allowed methods
                    "Access-Control-Allow-Headers": "Content-Type"  # Allowed headers
                }
            }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})  # Serialize error message
        }
        
def is_valid_email(email):
    # Simple regex for validating an email address
    email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(email_regex, email) is not None