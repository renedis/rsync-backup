FROM alpine:latest
LABEL maintainer="renedis"

RUN set -x \
    && apk add --no-cache \
        bash \
        openssh-client \
        rsync \
    && adduser -D backupuser

COPY container/ /
RUN chmod +x /usr/local/bin/disk-backup.sh \
    chmod +x /usr/local/bin/disk-cleanup.sh

USER backupuser

CMD ["disk-backup.sh"]
