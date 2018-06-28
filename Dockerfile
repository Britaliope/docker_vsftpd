FROM alpine
MAINTAINER Bruno MATEU <bruno.mateu@telecom-bretagne.eu>

# install vsftpd

RUN build_pkgs="build-base curl linux-pam-dev tar" && \
	runtime_pkgs="bash ca-certificates openssl" && \

 	apk update && \
	apk --no-cache --no-progress upgrade && \
	apk --no-cache --no-progress add bash \
		vsftpd ${build_pkgs} ${runtime_pkgs}

# get us pam_pwdfile
RUN mkdir pam_pwdfile && \
	cd pam_pwdfile && \
	curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz | tar xz --strip 1 && \
	make install && \
	cd .. && \
	rm -rf pam_pwdfile


RUN mkdir -p /var/run/vsftpd/empty && \
	chmod -w /var/run/vsftpd/empty && \
	mkdir -p /var/ftp && \
	mkdir -p /conf/vsftpd

RUN apk del ${build_pkgs}

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd /usr/sbin/
COPY addVirtualUser.sh /usr/sbin/

RUN mkdir -p /conf/vsftpd/user_conf/
COPY user_conf.example /conf/vsftpd/user_conf/

RUN chmod +x /usr/sbin/run-vsftpd && chmod +x /usr/sbin/addVirtualUser.sh

EXPOSE 20 21 21100-21150

VOLUME /conf/vsftpd/

CMD ["/usr/sbin/run-vsftpd"]
