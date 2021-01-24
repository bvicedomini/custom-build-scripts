echo ____________________________________________________________________
echo _____________________ starting hrp-build-init.sh ___________________
echo ____________________________________________________________________
echo __________________________ id=@0703 ________________________________
echo ____________________________________________________________________
# CRED=`curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI`
# echo $CRED

GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id github/oauth | jq --raw-output '.SecretString' | jq -r '.oauthToken')
echo $GITHUB_TOKEN

DOCKER_TOKEN=$(aws secretsmanager get-secret-value --secret-id docker/accessToken | jq --raw-output '.SecretString')
echo $DOCKER_TOKEN

CRED=`curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI`
KEY_ID=`node -pe 'JSON.parse(process.argv[1]).AccessKeyId' "$CRED"`
ACCESS_KEY=`node -pe 'JSON.parse(process.argv[1]).SecretAccessKey' "$CRED"`
SESSION_TOKEN=`node -pe 'JSON.parse(process.argv[1]).Token' "$CRED"`

echo "CRED=$CRED"
echo "KEY_ID=$KEY_ID"
echo "ACCESS_KEY=$ACCESS_KEY"
echo "SESSION_TOKEN=$SESSION_TOKEN"

echo "awsAccessKeyId=$KEY_ID" >> $HOME/.gradle/gradle.properties
echo "awsSecretAccessKey=$ACCESS_KEY" >> $HOME/.gradle/gradle.properties
echo "awsSessionToken=$SESSION_TOKEN" >> $HOME/.gradle/gradle.properties
echo "githubToken=$GITHUB_TOKEN" >> $HOME/.gradle/gradle.properties
echo "dockerToken=$DOCKER_TOKEN" >> $HOME/.gradle/gradle.properties

echo Contents of gradle.properties
echo _________________________________________________
cat $HOME/.gradle/gradle.properties

# reach out to aws secretse manager --- get the docker
# GITHUB_TOKEN: 'github/oauth:oauthToken'
#    DOCKER_TOKEN: 'docker/accessToken'
# store results in environ veriable
# use jq to get just the secret value

# gradle properties files...
# 1)
# write docker token