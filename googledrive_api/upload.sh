#!/bin/sh
# Upload a file to Google Drive
#
# Usage: upload.sh <access_token> <file> [title] [folder_id] [file_id] [mime]

ACCESS_TOKEN=$(/path/refresh.sh)

set -e

BOUNDARY=`cat /dev/urandom | head -c 16 | hexdump -e '/1 "%02X"'`
MIME_TYPE=${FULLBACKUP_MIME:-"application/octet-stream"}

( printf "\--$BOUNDARY\nContent-Type: application/json; charset=UTF-8\n\n{ \'title\': \'$FULLBACKUP_ID\', \'modifiedDateBehavior\': \'now\',\'description\':\'latest\', \'parents\': [ { \'id\': \'$GD_FOLDER_ID\' } ] }\n\n\--$BOUNDARY\nContent-Type: $MIME_TYPE\n\n" \
	&& cat $FULLBACKUP_DIR/$FULLBACKUP_ID && printf "\n\n\--$BOUNDARY--\n" ) \
	| curl -v -X PUT "https://www.googleapis.com/upload/drive/v2/files/$GD_FILE_ID?uploadType=multipart" \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Content-Type: multipart/related; boundary=$BOUNDARY" \
	--data-binary "@-"
