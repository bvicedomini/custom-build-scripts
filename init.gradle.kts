allprojects {
    repositories {
        jcenter()
        maven {url = uri("https://packages.confluent.io/maven/")}
        maven {url = uri("https://jitpack.io")}
        maven {
            url = uri("s3://maven-repository.hiddenroad.com/maven/")

            val awsAccessKeyId: String by settings
            val awsSecretAccessKey: String by settings
            val awsSessionToken: String? by settings

            credentials(AwsCredentials::class) {
                accessKey = System.getenv("AWS_ACCESS_KEY_ID") ?: awsAccessKeyId
                secretKey = System.getenv("AWS_SECRET_ACCESS_KEY") ?: awsSecretAccessKey
                if (accessKey == null || secretKey == null) {
                    throw GradleException("No credentials available. " +
                            "Either add to ~/.gradle/gradle.properties " +
                            "or set in AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY env variables")
                }

                val token = System.getenv("AWS_SESSION_TOKEN") ?: awsSessionToken
                if (token != null) {
                    sessionToken = token
                }
            }
        }
    }
}