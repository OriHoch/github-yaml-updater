#!/usr/bin/env python
from __future__ import print_function
import sys, requests, json, os, time


debug_enabled = bool(os.environ.get('DEBUG'))


def debug(*args, **kwargs):
    if debug_enabled:
        kwargs.update(file=sys.stderr)
        print(*args, **kwargs)


def parse_argv():
    _, suffixes, prefix, update_map_json, tag = sys.argv
    suffixes = suffixes.split(' ')
    return suffixes, prefix, update_map_json, tag


def wait_for_images(suffixes, prefix, tag):
    got_suffixes = set()
    while True:
        for suffix in suffixes:
            if suffix not in got_suffixes:
                res = requests.get('https://index.docker.io/v1/repositories/{}{}/tags/{}'.format(prefix, suffix, tag))
                if res.status_code == 200:
                    got_suffixes.add(suffix)
                else:
                    debug('missing image ({}): {}{}:{}'.format(res.status_code, prefix, suffix, tag))
                    break
        if len(got_suffixes) == len(set(suffixes)):
            debug('got all images ({})'.format(len(got_suffixes)))
            break
        else:
            debug('sleeping 1 second')
            time.sleep(1)


def get_update_json(suffixes, prefix, update_map_json, tag):
    for suffix in suffixes:
        replace_string = '<<{}>>'.format(suffix)
        image = '{}{}:{}'.format(prefix, suffix, tag)
        update_map_json = update_map_json.replace(replace_string, image)
    return update_map_json


def main():
    suffixes, prefix, update_map_json, tag = parse_argv()
    wait_for_images(suffixes, prefix, tag)
    print(get_update_json(suffixes, prefix, update_map_json, tag))
    exit(0)


if __name__ == '__main__':
    main()
