# MySQL to Google Big Query

Backs up MySQL databases to Google Big Query.

```sh
GCLOUD_SERVICE_KEY=`base64 <your-service-account.json>`
docker run \
  -e MYSQL_HOST=127.0.0.1 \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=password \
  -e BQ_PROJECT_ID=1092187650 \
  -e BQ_DATASET_ID=mydataset \
  -e GCLOUD_SERVICE_KEY=$GCLOUD_SERVICE_KEY \
  -e EXCLUDE_DB=foo|bar \
  abemeda/mysql-backup
```

### BQ_PROJECT_ID
The Google Cloud project ID.

### BQ_DATASET_ID (optional)
The Big Query dataset ID to import the tables in. If left blank it will use the source table name.

### GCLOUD_SERVICE_KEY
Base64 encoded Google Cloud service account json file. Generate as follows.

To generate it visit https://console.developers.google.com/, and click on ‘API Manager’, then ‘Credentials’, then ‘New credentials’, then select ‘Service account key’.
Create and download the service account json file, then run the following command to get a base64 encoded version of it.

```sh
GCLOUD_SERVICE_KEY=`base64 <your-service-account.json>`
```

### REPLACE_DATA (optional)
Empty Big Query table before importing new data.

### BATCH_SIZE (optional)
How many rows to export per batch. Defaults to 1 million.

### MYSQL_HOST
MySQL host.

### MYSQL_PORT (optional)
Port the MySQL server is accessible on. Defaults to `3306`.

### MYSQL_USER (optional)
MySQL user. Defaults to `root`.

### MYSQL_PASSWORD
Password to use when connecting.

### MYSQL_DB (optional)
MySQL DB to export. Exports all if left blank.

### MYSQL_TABLE (optional)
MySQL table to export. Exports all if left blank.

### EXCLUDE_DB (optional)
Pipe separated list of databases to exclude.

### EXCLUDE_TABLE (optional)
Pipe separated list of tables to exclude.
