FROM alpine

RUN apk add bash
WORKDIR /wallet

COPY . .

RUN chmod +x start.sh

ENTRYPOINT /wallet/lthn.sh sync-chain