#!/bin/sh
BEACON_ENDPOINT_URL=https://hogehoge.com/fuga
BEACON_API_KEY=
echo $"
curl -X POST \
-H 'Authorization: Bearer ' \
-H 'x-api-key:$BEACON_API_KEY'
-H 'Content-Type:application/json' \
-d '{ \"username\": \"`whoami`\", \"hostname\": \"`hostname`\", \"created_at\": \"$(date '+%Y-%m-%dT%H:%M:%S%z')\" , \"machine_type\" : \"mac\" }' \$BEACON_ENDPOINT_URL
echo '{ \"username\": \"`whoami`\", \"hostname\": \"`hostname`\", \"created_at\": \"$(date '+%Y-%m-%dT%H:%M:%S%z')\" , \"machine_type\" : \"mac\" }'
" >> /opt/webhook-beacon/beacon.sh
echo $"
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>webhook-beacon</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/webhook-beacon/beacon.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>150</integer>
    <key>StandardOutPath</key>
    <string>/var/log/beacon.log</string>
</dict>
</plist>
" >> 
# echo "{ \"username\": \"`whoami`\", \"hostname\": \"`hostname`\", \"created_at\": \"$(date '+%Y-%m-%dT%H:%M:%S%z')\" , \"machine_type\" : \"mac\" }"