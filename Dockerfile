FROM alpine
RUN apk --update add python2 git py2-pip bash openssh-client &&\
    pip install --upgrade pip && pip install pyyaml requests &&\
    mkdir -p ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
COPY entrypoint.sh /
COPY *.py /
ENTRYPOINT ["/entrypoint.sh"]
