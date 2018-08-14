# Github Yaml Updater

Update yaml files on GitHub repos

## Examples

Using GitHub [Deploy Keys](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys)

```
 docker run -e CLONE_PARAMS="--branch repo_branch https://github.com/repo_owner/repo_name.git" \
            -e YAML_UPDATE_JSON='{"yaml_attr_to_update":"value"}' \
            -e YAML_UPDATE_FILE='yaml_file_to_update.yaml' \
            -e GIT_USER_EMAIL=deployer_user_email \
            -e GIT_USER_NAME=deployer_user_name \
            -e GIT_COMMIT_MESSAGE="auto update commit message" \
            -e PUSH_PARAMS='git@github.com:repo_slug.git repo_branch' \
            -v /local/path/to/deploy_key.id_rsa:/deploy_key.id_rsa \
            -e SSH_DEPLOY_KEY_FILE=/deploy_key.id_rsa \
            orihoch/github_yaml_updater
```

Using GitHub token

```
 docker run -e CLONE_PARAMS="--branch repo_branch https://github.com/repo_owner/repo_name.git" \
            -e YAML_UPDATE_JSON='{"yaml_attr_to_update":"value"}' \
            -e YAML_UPDATE_FILE='yaml_file_to_update.yaml' \
            -e GIT_USER_EMAIL=deployer_user_email \
            -e GIT_USER_NAME=deployer_user_name \
            -e GIT_COMMIT_MESSAGE="auto update commit message" \
            -e PUSH_PARAMS='https://github_token@repo_slug repo_branch' \
            orihoch/github_yaml_updater
```

Update based on docker images availability - the update will run only once all images are available

```
docker run -e CLONE_PARAMS="--branch ${K8S_REPO_BRANCH} https://github.com/${K8S_REPO_SLUG}.git" \
           -e YAML_UPDATE_TYPE='docker-image-suffixes' \
           -e DOCKER_IMAGE_SUFFIXES="${IMAGE_SUFFIXES}" \
           -e DOCKER_IMAGE_PREFIX="${IMAGE_PREFIX}" \
           -e DOCKER_IMAGE_UPDATE_MAP_JSON="${UPDATE_MAP_JSON}" \
           -e DOCKER_IMAGE_TAG="${tag}" \
           -e YAML_UPDATE_FILE="${YAML_UPDATE_FILE}" \
           -e GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
           -e GIT_USER_NAME="${GIT_USER_NAME}" \
           -e GIT_COMMIT_MESSAGE="${GIT_COMMIT_MESSAGE}" \
           -e PUSH_PARAMS="https://${GITHUB_TOKEN}@${K8S_REPO_SLUG} ${K8S_REPO_BRANCH}" \
           orihoch/github_yaml_updater
```
