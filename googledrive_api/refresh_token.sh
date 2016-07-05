#!/bin/sh

TOKEN=$( find /path/ -name "token" -cmin -60 | xargs -I {} cat {} )
if [ "$TOKEN" ]; then
      break
else
	curl -sd "client_id=$GD_CLIENT_ID&client_secret=$GD_CLIENT_SECRET&refresh_token=$GD_REFRESH_TOKEN&grant_type=refresh_token" https://accounts.google.com/o/oauth2/token | tr -d '"}{[:space:]' | awk -F "," '{print $1}' | awk -F ":" '{print $2}' > /path/token
fi
cat /path/token
