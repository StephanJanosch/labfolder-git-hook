#!/usr/bin/env bash

TOKENFILE="$HOME/.labfolder_token.sh"
PROJECTID="3358"

#TODO: check for credential file
source $HOME/.labfolder_credentials.sh

if [  -f $TOKENFILE ]
then
    source $TOKENFILE
else
    TOKEN=""
fi

#$USER
#$PASSWORD
#$LABFOLDER_HOST
#$TOKEN

#do a dummy call to check validity of token
PROJECTS=`curl -f  -s -u "$TOKEN:" -G  "https://$LABFOLDER_HOST/api/v2/projects?limit=&offset="`
if [ $? == "22" ]
then
#    curl failed, now check for the reason
    PROJECTS=`curl  -s -u "$TOKEN:" -G  "https://$LABFOLDER_HOST/api/v2/projects?limit=&offset="`
    MESSAGE=`echo $PROJECTS | jq -r '.message'`
    if [[ $MESSAGE == "Invalid token" ]]
    then
        #invalid token, so get a new one
        echo "aquiring new token"
        POSTAUTH="{\"user\":\"$USER\",\"password\":\"$PASSWORD\"}"
        RESULT=`curl -s -H "Content-Type: application/json"  -X POST -d "$POSTAUTH" https://$LABFOLDER_HOST/api/v2/auth/login`
        TOKEN=`echo "$RESULT" | jq -r '.token'`
        echo "#!/usr/bin/env bash" > "$TOKENFILE"
        echo "TOKEN=\"$TOKEN\"" >> "$TOKENFILE"
        echo "token saved to $TOKENFILE"
    fi
fi
# we have a valid $TOKEN

#create entry
POSTJSON="{\"title\": \"test entry 1\",\"project_id\": \"$PROJECTID\"}"
ENTRY=`curl -s -u "$TOKEN:" -H "Content-Type: application/json" -X POST -d "$POSTJSON" "https://$LABFOLDER_HOST/api/v2/entries"`
ENTRID=`echo $ENTRY | jq -r '.id'`

echo $ENTRID
