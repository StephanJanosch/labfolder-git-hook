#!/usr/bin/env bash

CREDENTIALSFILE="$HOME/.labfolder_credentials.sh"
TOKENFILE="$HOME/.labfolder_token.sh"
PROJECTID="3358"

if [ ! -f $CREDENTIALSFILE ]
then
    echo "did not found $CREDENTIALSFILE. Please check https://gitlab.gwdg.de/labfolder-api-tools/git-hook/blob/master/README.md"
    exit 1
else
    source $CREDENTIALSFILE
fi

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
        echo "No valid labfolder token found. Aquriring new one."
        echo "user provided: $USER. Please enter password on $LABFOLDER_HOST"
        read -s -p "password: " PASSWORD
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
ENTRY=`curl -s -f -u "$TOKEN:" -H "Content-Type: application/json" -X POST -d "$POSTJSON" "https://$LABFOLDER_HOST/api/v2/entries"`
if [ $? != 0 ]
then
    echo "could not create labfolder entry"
    exit 1
fi
ENTRID=`echo $ENTRY | jq -r '.id'`


DESC="bla"
POSTJSON="{\"entry_id\": \"$ENTRID\",  \"data_elements\": [ \
    { \
      \"type\": \"DATA_ELEMENT_GROUP\", \
      \"title\": \"Commit\", \
      \"children\": [ \
{\"type\": \"DESCRIPTIVE_DATA_ELEMENT\",\"title\": \"Descriptive XYZ\",\"description\": \"$DESC\"}, \
{\"type\": \"DESCRIPTIVE_DATA_ELEMENT\",\"title\": \"Descriptive XYZ\",\"description\": \"$DESC\"}, \
{\"type\": \"DESCRIPTIVE_DATA_ELEMENT\",\"title\": \"Descriptive XYZ\",\"description\": \"$DESC\"} \
      ]\
    }\
]}"

#comment 1

curl -s -f -u "$TOKEN:" -H "Content-Type: application/json" -X POST -d "$POSTJSON" "https://$LABFOLDER_HOST/api/v2/elements/data"
