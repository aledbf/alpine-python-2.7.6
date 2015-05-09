FROM gliderlabs/alpine:3.1

RUN apk-install alpine-sdk \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER builder

WORKDIR /package

ENV REPODEST /packages

RUN abuild-apk update

COPY . /package

RUN sudo mkdir /packages \
  && sudo chown -R builder /package /packages

RUN abuild-keygen -a

RUN abuild -r