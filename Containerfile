FROM python:slim

RUN apt update && apt install curl sed openssh-server \
  openssh-client openssh-sftp-server faketime screen git build-essential \
  manpages-dev g++ gcc libc6-dev make pkg-config apt-utils ksh net-tools dnsutils -y && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
  sed -i 's/#PermitRootLogin prohibit-password/#PermitRootLogin no/g' /etc/ssh/sshd_config

COPY --from=golang:latest /usr/local/go /usr/local
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

EXPOSE 22

WORKDIR /
COPY ./entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
