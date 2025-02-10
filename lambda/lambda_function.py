import boto3
import os
import logging
import psycopg2

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
    CREATE TABLE IF NOT EXISTS users_t (
        user_id VARCHAR(40) PRIMARY KEY,
        age VARCHAR(40),
        registration_date VARCHAR(40),
        purchases VARCHAR(40),
        average_order_value VARCHAR(40),
        customer_segment VARCHAR(30),
        created_at VARCHAR(40)
    );
    """
    
    response = execute_redshift_query(table_creation_query)
    
    return {
        "statusCode": 200,
        "message": "Tabla 'users' creada en Redshift",
        "response": response
    }

# Configuración de AWS y Redshift

def upload_to_s3(file_name, bucket_name, s3_key):
    s3_client = boto3.client('s3')
    s3_client.upload_file(file_name, bucket_name, s3_key)
    print(f"Archivo {file_name} subido a s3://{bucket_name}/{s3_key}")

def copy_to_redshift(bucket_name, s3_key, table_name, iam_role):
    s3_path = f's3://{bucket_name}/{s3_key}'
    
    conn = psycopg2.connect(
        dbname=REDSHIFT_DB,
        user=REDSHIFT_USER,
        password=REDSHIFT_PASSWORD,
        host=REDSHIFT_HOST,
        port=REDSHIFT_PORT
    )

    cur = conn.cursor()

    copy_sql = f"""
        COPY {table_name}
        FROM '{s3_path}'
        IAM_ROLE '{iam_role}'
        FORMAT AS CSV
        IGNOREHEADER 1;
    """

    cur.execute(copy_sql)
    conn.commit()

    print(f"Datos cargados en la tabla {table_name} de Redshift")

    cur.close()
    conn.close()





if __name__ == "__main__":
    BUCKET_NAME = 'redshift-cenam-claro'
    S3_KEY = 'redshift/datos.csv'
    FILE_NAME = 'datos.csv'
    REDSHIFT_HOST = 'kopicloud-workgroup.015319782619.us-east-1.redshift-serverless.amazonaws.com'
    REDSHIFT_DB = 'kopiclouddb'
    REDSHIFT_USER = 'kopiadmin'
    REDSHIFT_PASSWORD = 'M3ss1G0at10'
    REDSHIFT_PORT = 5439
    IAM_ROLE = 'arn:aws:iam::015319782619:role/kopicloud-dev-redshift-serverless-role-new'
    TABLE_NAME = 'users_t'
    lambda_handler()
    upload_to_s3(FILE_NAME, BUCKET_NAME, S3_KEY)
    #copy_to_redshift(BUCKET_NAME, S3_KEY, TABLE_NAME, IAM_ROLE)
