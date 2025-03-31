import pymysql
import json

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
                        "description": "This email does not exist"
                    })
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
                })
            }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})  # Serialize error message
        }