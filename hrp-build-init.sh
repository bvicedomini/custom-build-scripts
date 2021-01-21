CRED=`curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI`
echo $CRED

DOCKER_TOKEN=$(aws secretsmanager get-secret-value --secret-id hrp-docker-token | jq --raw-output '.SecretString' | jq -r '.token')
echo $DOCKER_TOKEN

# reach out to aws secretse manager --- get the docker
# GITHUB_TOKEN: 'github/oauth:oauthToken'
#    DOCKER_TOKEN: 'docker/accessToken'
# store results in environ veriable
# use jq to get just the secret value

# gradle properties files...
# 1)
# write docker token