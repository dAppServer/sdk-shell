# Note
This is not added to the docker image yet, so for docker to work run `docker build -t lthn/chain .` 

# Install
This is not meant to be used other than developers or power users.
```shell
sudo ln -s $(pwd)/lthn.sh /usr/bin/lthn
sudo chmod +x /usr/bin/lthn

```

# Run letheand as a daemon
```shell
lthn daemon
```
Docker:
```shell
docker lthn/chain sync
```

# Run Interactive Letheand

Linux:
```shell
lthn letheand 
# Alias: lthn sync
```
Docker:
```shell
docker lthn/chain letheand
```

# Export Chain to /dc/ share

Linux:
```shell
lthn export 
```
Docker:
```shell
docker lthn/chain export
```

# Import Chain from /dc/ share

Linux:
```shell
lthn import 
```
Docker:
```shell
docker lthn/chain import
```

# Wallet RPC
```shell
lthn wallet-rpc
```

# Wallet VPN RPC
```shell
lthn vpn-rpc
```

# Run Command on Wallet CLI (Restful)
```shell
lthn wallet-cmd help
```

# Make a wallet
Makes a wallet in `./data/wallet/wallet` with password `test`
```shell
lthn make-wallet
```

# Environment Vars
```shell
export WALLET_PASSWORD="test"
export WALLET_RPC_PASSWORD="test"
export BASE_DIR=$(pwd)

export WALLET_DATA="${BASE_DIR}/data/wallet"
export WALLET_FILE="${WALLET_DATA}/wallet"
export CONFIG_PATH="${BASE_DIR}/config"
export LOGS_DATA="${BASE_DIR}/logs"
export WALLET_RPC="${BASE_DIR}/cli/lethean-wallet-rpc"
export WALLET_CLI="${BASE_DIR}/cli/lethean-wallet-cli"
export WALLET_VPN_RPC="${BASE_DIR}/cli/lethean-wallet-vpn-rpc"
export CHAIN_IMPORT="${BASE_DIR}/cli/lethean-blockchain-import"
export CHAIN_EXPORT="${BASE_DIR}/cli/lethean-blockchain-export"
export CHAIN_DAEMON="${BASE_DIR}/cli/letheand"

export DAEMON_HOST="localhost"
export PORT_P2P="48772"
export PORT_RPC="48782"
export PORT_VPN="14660"
```