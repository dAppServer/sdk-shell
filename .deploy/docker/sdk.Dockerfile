FROM alpine

RUN apk add bash make
WORKDIR /home/lthn

COPY . .

RUN chmod +x lthn.sh ; ln -s /home/lthn/lthn.sh /usr/bin/lthn

# CMD lthn letheand