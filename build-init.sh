echo ____________________________________________________________________
echo _____________________ starting hrp-init.sh _________________________
echo ____________________________________________________________________
echo __________________________ id=@0703 ________________________________
echo ____________________________________________________________________
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ Common installs.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
npm install -g aws-cdk
npm install -g typescript

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ Versions.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo java:"\n"`java --version`"\n"
echo gradle:"\n"`gradle --version`"\n"
echo mvn:"\n"`mvn --version`"\n"
echo node:"\n"`node --version`"\n"
echo npm:"\n"`npm --version`"\n"
echo python:"\n"`python --version`"\n"
echo pip:"\n"`pip --version`"\n"
echo aws cdk:"\n"`cdk --version`"\n"
echo typescript:"\n"`tsc --version`"\n"

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ Get and configure secrets.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ Contents of gradle.properties.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cat $HOME/.gradle/gradle.properties

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ Login to docker and codeartifact.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# from call with George on 1/22
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 778477161868.dkr.ecr.us-west-2.amazonaws.com

echo Logging in to docker
# docker login --username dockerhrp --password $DOCKER_TOKEN

echo Logging in to AWS CodeArtifact
# aws codeartifact login --tool npm --repository hiddenroad-npm --domain hrplp --domain-owner 886589388215

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~ init.gradle.kts.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cp ./init.gradle.kts ../
cd..
ls -al

# from call with George on 1/22
echo ____________________________________________________________________
echo ______________________ hrp-init.sh end _____________________________
echo ____________________________________________________________________