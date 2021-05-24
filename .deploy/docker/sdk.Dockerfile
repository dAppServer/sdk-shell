FROM alpine

WORKDIR /home/lthn

RUN apk add bash make
COPY . .

RUN chmod +x lthn.sh ; ln -s /home/lthn/lthn.sh /usr/bin/lthn

ENTRYPOINT lthn sync