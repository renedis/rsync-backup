FROM alpine:latest
LABEL maintainer="renedis"

RUN set -x \
    && apk add --no-cache \
        bash \
        openssh-client \
        rsync \
        tzdata

COPY container/ /

ENV TZ=UTC

CMD sh -c "ln -sf \"/usr/share/zoneinfo/\$${TZ}\" /etc/localtime \
  && echo \$${TZ} > /etc/timezone \
  && exec /disk-backup.sh"
