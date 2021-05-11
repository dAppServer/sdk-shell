### WARNING: Alpha Ware, Dont use unless you're a sadist.

You can use this direct, or via docker. If that confused you, you want docker.

- Build It: ` docker build -t lethean/wallet .`
- Run Interactive: `docker run -it --entrypoint /bin/bash lethean/wallet` (type `exit` in the console and hit enter to
  exit)
- Run Restful: ` docker run lethean/wallet wallet lthn balance`

# Project Details

wallet management, that is boring and not worth looking at, come back later.

## Namespacing

- Name: `Lethean Wallet`
- Group: `projects-wallet`

### Urls

*Advertised Website* \
Website: https://wallet.lethean.app 

*Non-Technical Support* \
https://wallet.lethean.help

*Technical Support & Api/CmdLine Docs* \
https://wallet.lethean.sh

*Project downloads, smart clean website* \
https://wallet.lethean.tools 

*Platform Endpoint* \
`wallet.lethean.network`

*Email Address* \
`wallet@lethean.io`


### DNS Zones

#### .network
```commandline
wallet        IN      A       DEPLOYMENT_K8_INGRESS_IP
wallet        IN      CNAME   wallet.app.lethean.network
```
#### .app
```commandline
wallet        IN      CNAME   wallet.app.lethean.network
```
##### .sh
```commandline
wallet        IN      CNAME   wallet.sh.lethean.network
```
##### .help
```commandline
wallet        IN      CNAME   wallet.help.lethean.network
```
##### .tools
```commandline
wallet        IN      CNAME   wallet.tools.lethean.network
```
##### .mx
```
Insert the mx records for email `lethean.mx` (clean ip's)
```
### Restful Mapping

Load a wallet interactive console

- `lethean.sh/wallet/lthn/` = `lethean.sh wallet lthn`
- `lethean.sh/exchange/lthn/10` = `lethean.sh exchange 10`
