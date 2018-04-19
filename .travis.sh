#!/usr/bin/env bash

if [ "${1}" == "script" ] && [ "${IMAGE_SUFFIX}" != "" ]; then
    docker pull "${IMAGE_PREFIX}${IMAGE_SUFFIX}:latest"
    docker build --cache-from "${IMAGE_PREFIX}${IMAGE_SUFFIX}:latest" \
                 -t "${IMAGE_PREFIX}${IMAGE_SUFFIX}:latest" \
                 $DOCKER_BUILD_ARGS
    [ "$?" != "0" ] && echo failed script && exit 1

elif [ "${1}" == "deploy" ]; then
    tag="${TRAVIS_COMMIT}"
    [ "${tag}" == "" ] && echo empty tag && exit 1
    if [ "${IMAGE_SUFFIX}" != "" ]; then
        docker login -u "$DOCKER_USER" -p "$DOCKER_PASS" &&\
        docker push "${IMAGE_PREFIX}${IMAGE_SUFFIX}:latest" &&\
        docker tag "${IMAGE_PREFIX}${IMAGE_SUFFIX}:latest" "${IMAGE_PREFIX}${IMAGE_SUFFIX}:${tag}" &&\
        docker push "${IMAGE_PREFIX}${IMAGE_SUFFIX}:${tag}"
        [ "$?" != "0" ] && echo failed docker push && exit 1
    fi

fi

echo Great Success
exit 0
