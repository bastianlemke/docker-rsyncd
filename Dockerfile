FROM alpine:latest

MAINTAINER Bastian Lemke <bastian@konschtanz.de>

RUN apk update && \
	apk upgrade && \
	apk add --no-cache \
		rsync \
        openssh-server \
 && rm -rf /var/cache/apk/*

RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
RUN cp /etc/ssh/sshd_config /sshd_config.backup

VOLUME ["/etc/ssh"]
VOLUME ["/root/.ssh"]
VOLUME ["/data"]
EXPOSE 22

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]