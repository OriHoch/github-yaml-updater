#!/usr/bin/env sh

(
    [ "${CLONE_PARAMS}" == "" ] ||
    [ "${YAML_UPDATE_JSON}" == "" ] ||
    [ "${YAML_UPDATE_FILE}" == "" ] ||
    [ "${GIT_USER_EMAIL}" == "" ] ||
    [ "${GIT_USER_NAME}" == "" ] ||
    [ "${GIT_COMMIT_MESSAGE}" == "" ] ||
    [ "${PUSH_PARAMS}" == "" ]
) && echo missing required environment variables && exit 1

cd `mktemp -d`

! git clone --depth 1 $CLONE_PARAMS . && echo failed git clone && exit 1

[ -e "${YAML_UPDATE_FILE}" ] && ls -lah $YAML_UPDATE_FILE
IS_NEW_FILE=$?

! /update_yaml.py "${YAML_UPDATE_JSON}" "${YAML_UPDATE_FILE}" && echo failed yaml update && exit 1

[ "${IS_NEW_FILE}" == "0" ] && git diff --shortstat --exit-code "${YAML_UPDATE_FILE}" && echo no change detected, skipping git push && exit 0

ls -lah $YAML_UPDATE_FILE

! (
    git config user.email "${GIT_USER_EMAIL}" &&
    git config user.name "${GIT_USER_NAME}"
) && echo failed git config && exit 1

! git add "${YAML_UPDATE_FILE}" && echo failed git add && exit 1
! git commit -m "${GIT_COMMIT_MESSAGE}" && echo failed git commit && exit 1
! git push $PUSH_PARAMS 2>/dev/null && echo failed git push, error log suppressed to prevent exposing the github token && exit 1

echo Great Success
exit 0
