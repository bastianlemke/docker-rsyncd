FROM alpine:latest

MAINTAINER Bastian Lemke <bastian@konschtanz.de>

RUN apk update && \
	apk upgrade && \
	apk add --no-cache \
		rsync \
        openssh-server \
        bash \
 && rm -rf /var/cache/apk/*

# temporarily store a backup copy of sshd_config because /etc/ssh is overwritten by the
# mounted host directory to store the generated host keys outside of the container
RUN cp /etc/ssh/sshd_config /sshd_config.backup

VOLUME ["/etc/ssh"]
VOLUME ["/root/.ssh"]
VOLUME ["/data"]
EXPOSE 22

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]