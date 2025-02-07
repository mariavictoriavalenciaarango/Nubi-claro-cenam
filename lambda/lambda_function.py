import boto3
import os
import logging

client = boto3.client('redshift-data')

# Configura el logging
logging.basicConfig(level=logging.INFO)

# Función para la ejecución de consultas en Redshift

def execute_redshift_query(query):
    try:
        response = client.execute_statement(
            Database="kopiclouddb",
            Sql=query,
            # DbUser="kopiadmin",
            WorkgroupName= "kopicloud-workgroup"
        )
        logging.info(f"Respuesta de Redshift: {response}")        
        return response
    except Exception as e:
        logging.error(f"Error al ejecutar la consulta: {str(e)}")
        return {"statusCode": 500, "error": str(e)}



def lambda_handler():
    table_creation_query = """
    CREATE TABLE IF NOT EXISTS users (
        user_id VARCHAR(40) PRIMARY KEY,
        age INTEGER,
        registration_date DATE,
        purchases INTEGER,
        average_order_value REAL,
        customer_segment VARCHAR(30),
        created_at TIMESTAMP DEFAULT current_timestamp
    );
    """
    
    response = execute_redshift_query(table_creation_query)
    
    return {
        "statusCode": 200,
        "message": "Tabla 'users' creada en Redshift",
        "response": response
    }

if __name__ == "__main__":
    lambda_handler()
