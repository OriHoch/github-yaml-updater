# Github Yaml Updater

Update yaml files on GitHub repos

## Usage

```
 docker run -it -e CLONE_PARAMS="--branch repo_branch https://github.com/repo_slug/repo_name.git" \
                -e YAML_UPDATE_JSON='{"yaml_attr_to_update":"value"}' \
                -e YAML_UPDATE_FILE='yaml_file_to_update.yaml' \
                -e GIT_USER_EMAIL=deployer_user_email \
                -e GIT_USER_NAME=deployer_user_name \
                -e GIT_COMMIT_MESSAGE="auto update commit message" \
                -e PUSH_PARAMS='https://github_token@repo_slug/repo_name repo_branch' \
                orihoch/github_yaml_updater
```
