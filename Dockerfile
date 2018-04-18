FROM alpine
RUN apk --update add python2 git py2-pip bash
RUN pip install --upgrade pip && pip install pyyaml
RUN pip install requests
COPY entrypoint.sh /
COPY *.py /
ENTRYPOINT ["/entrypoint.sh"]
