#!/bin/bash

set -e

echo $GCLOUD_SERVICE_KEY | base64 --decode --ignore-garbage > $HOME/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
gcloud config set project $BQ_PROJECT_ID

MYSQL_PARAMS="--user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$MYSQL_HOST --port=$MYSQL_PORT"

if [ -n "$MYSQL_DB" ]; then
    databases=$MYSQL_DB
else
    databases=`mysql $MYSQL_PARAMS -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
fi

if [ -n "$EXCLUDE_DB" ]; then
    databases=`echo "$databases" | grep -Ev "($EXCLUDE_DB)"`
fi

for db in $databases; do
    echo "dumping database: $db"

    if [ -n "$MYSQL_TABLE" ]; then
        tables=$MYSQL_TABLE
    else
        tables=`mysql $MYSQL_PARAMS --skip-column-names -e "SHOW TABLES;" $db`
    fi

    if [ -n "$EXCLUDE_TABLE" ]; then
        tables=`echo "$tables" | grep -Ev "($EXCLUDE_TABLE)"`
    fi

    for table in $tables; do
        echo "dumping table: $table"
        mysql $MYSQL_PARAMS --database=$db -e "SELECT * FROM \`$table\`" --batch --silent > /tmp/$db.$table.csv
        bq load --quote='' --field_delimiter="\t" --source_format=CSV ${BQ_DATASET_ID:-$db}.$table /tmp/$db.$table.csv
        rm -rf /tmp/$db.$table.csv
    done
done

echo "completed dump"
