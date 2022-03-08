# jupyter-notebook

Jupyter notebook docker container with tools I commonly use

## Run

```bash
docker run --network="host" \
  --rm \
  --name jupyter \
  -e AWS_DEFAULT_REGION \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  -e JUPYTER_ENABLE_LAB=yes \
  -v "$PWD":/home/jovyan/work \
  justmiles/jupyter-notebook
```

## Usage with Glue Dev Endpoints

```bash
PRIVATE_SSH_KEY=~/.ssh/id_rsa
ENDPOINT_NAME=justmiles

aws glue create-dev-endpoint \
  --endpoint-name $ENDPOINT_NAME \
  --role-arn "arn:aws:iam::00000000000:role/TBD" \
  --security-group-ids "TBD" \
  --subnet-id "TBD" \
  --public-keys "$(ssh-keygen -y -f $PRIVATE_SSH_KEY) $USERNAME@localhost" \
  --number-of-nodes 5 \
  --extra-python-libs-s3-path "TBD" \
  --glue-version "1.0" \
  --arguments '{ "--enable-glue-datacatalog": "true", "GLUE_PYTHON_VERSION": "3" }'


while [ ! "$STATUS" == "READY" ]; do
  STATUS=$(aws glue get-dev-endpoint --endpoint-name $ENDPOINT_NAME --query 'DevEndpoint.Status' --output text)
  sleep 10
  echo "dev endpoint status: $STATUS"
done

# Setup tunnel for Glue Sessions
REMOTE_HOST=$(aws glue get-dev-endpoint --endpoint-name $ENDPOINT_NAME --query 'DevEndpoint.PrivateAddress' --output text)
ssh -i $PRIVATE_SSH_KEY -NTL 8998:169.254.76.1:8998 glue@$REMOTE_HOST

```
