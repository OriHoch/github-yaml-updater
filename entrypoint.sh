#!/usr/bin/env bash

(
    [ "${CLONE_PARAMS}" == "" ] ||
    [ "${YAML_UPDATE_FILE}" == "" ] ||
    [ "${GIT_USER_EMAIL}" == "" ] ||
    [ "${GIT_USER_NAME}" == "" ] ||
    [ "${GIT_COMMIT_MESSAGE}" == "" ] ||
    [ "${PUSH_PARAMS}" == "" ]
) && echo missing required environment variables && exit 1

cd `mktemp -d`

! git clone --depth 1 $CLONE_PARAMS . && echo failed git clone && exit 1

IS_NEW_FILE=yes
[ -e "${YAML_UPDATE_FILE}" ] && ls -lah $YAML_UPDATE_FILE && IS_NEW_FILE=no

if [ "${YAML_UPDATE_TYPE}" == "docker-image-suffixes" ]; then
    (
        [ "${DOCKER_IMAGE_SUFFIXES}" == "" ] ||
        [ "${DOCKER_IMAGE_PREFIX}" == "" ] ||
        [ "${DOCKER_IMAGE_UPDATE_MAP_JSON}" == "" ] ||
        [ "${DOCKER_IMAGE_TAG}" == "" ]
    ) && echo missing required environment variables && exit 1
    echo waiting for docker images...
    YAML_UPDATE_JSON=$(/get_docker_image_suffixes_update_json.py "${DOCKER_IMAGE_SUFFIXES}" "${DOCKER_IMAGE_PREFIX}" "${DOCKER_IMAGE_UPDATE_MAP_JSON}" "${DOCKER_IMAGE_TAG}")
    [ "$?" != "0" ] && echo failed to get update json && exit 1
    [ "${DEBUG}" == "1" ] && echo "${YAML_UPDATE_JSON}"
    ! /update_yaml.py "${YAML_UPDATE_JSON}" "${YAML_UPDATE_FILE}" && echo failed yaml update && exit 1

else
    [ "${YAML_UPDATE_JSON}" == "" ] && echo missing required environment variables && exit 1
    [ "${DEBUG}" == "1" ] && echo "${YAML_UPDATE_JSON}"
    ! /update_yaml.py "${YAML_UPDATE_JSON}" "${YAML_UPDATE_FILE}" && echo failed yaml update && exit 1
fi

[ "${IS_NEW_FILE}" == "no" ] && git diff --shortstat --exit-code "${YAML_UPDATE_FILE}" && echo no change detected, skipping git push && exit 0

ls -lah $YAML_UPDATE_FILE
[ "${DEBUG}" == "1" ] && cat $YAML_UPDATE_FILE

! (
    git config user.email "${GIT_USER_EMAIL}" &&
    git config user.name "${GIT_USER_NAME}"
) && echo failed git config && exit 1

! git add "${YAML_UPDATE_FILE}" && echo failed git add && exit 1
! git commit -m "${GIT_COMMIT_MESSAGE}" && echo failed git commit && exit 1

if [ "${SSH_DEPLOY_KEY_FILE}" != "" ]; then
    echo setting up ssh deploy key
    mkdir -p ~/.ssh &&\
    cp "${SSH_DEPLOY_KEY_FILE}" ~/.ssh/id_rsa &&\
    chmod 400 ~/.ssh/id_rsa
fi

! git push $PUSH_PARAMS && echo failed git push && exit 1

echo Great Success
exit 0
