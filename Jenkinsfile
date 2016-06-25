node {
    slackSend("[<${env.BUILD_URL}|${env.JOB_NAME}:${env.BUILD_NUMBER}>] Pipeline started!")

    try {
        stage 'build & push image'
        slackSend("[<${env.BUILD_URL}|${env.JOB_NAME}:${env.BUILD_NUMBER}>] Building new Docker image..")
        def service = env.JOB_NAME
        def region = 'eu-west-1'
        def dockerRepo = "944590742144.dkr.ecr.${region}.amazonaws.com/apply/smart-${service}"
        def img = docker.build("${dockerRepo}:build-${env.BUILD_NUMBER}")
        sh("eval \$(aws ecr get-login --region ${region})")
        img.push()
        img.push('latest')
        slackSend color: 'good', message: "[<${env.BUILD_URL}|${env.JOB_NAME}:${env.BUILD_NUMBER}>] New image: ${img.id}"
    } catch (e) {
        slackSend color: 'danger', message: "[<${env.BUILD_URL}|${env.JOB_NAME}:${env.BUILD_NUMBER}>] Pipeline failed: ${e}"
        error(e.getMessage())
    }

    slackSend color: 'good', message: "[<${env.BUILD_URL}|${env.JOB_NAME}:${env.BUILD_NUMBER}>] Pipeline finished!"
}