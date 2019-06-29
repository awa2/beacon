$BEACON_ENDPOINT_UR="https://hogehoge.com/fuga"
$BEACON_API_KEY=

$dt = (Get-Date -Format "o") -replace "\.[0-9]+"
$username = whoami
$hostname = hostname;
$params = @{
 "usename"=$username;
 "hostname"=$hostname;
 "created_at"=$dt;
 "machine_type"="windows";
}
Invoke-RestMethod
  -Uri BEACON_ENDPOINT_UR
  -Header @{x-api-key:$BEACON_API_KEY}
  -ContentType 'application/json'
  -Method Post
  -Body ($params|ConvertTo-Json)