FROM alpine
RUN apk --update add python2 git py2-pip
RUN pip install --upgrade pip && pip install pyyaml
COPY entrypoint.sh /
COPY update_yaml.py /
ENTRYPOINT ["/entrypoint.sh"]
