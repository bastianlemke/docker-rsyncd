FROM alpine:latest

MAINTAINER Bastian Lemke <bastian@konschtanz.de>

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-server \
 && rm -rf /var/cache/apk/*

RUN ssh-keygen -A

VOLUME ["/root/.ssh"]
VOLUME ["/backup"]
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
