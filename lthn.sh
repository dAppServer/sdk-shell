#!/bin/bash

#echo "https://lethean.sh/${1}/${2}/${3}"
export WALLET_PASSWORD="test"
export WALLET_RPC_PASSWORD="test"

export BASE_DIR="$(pwd)"
export WALLET_DATA="${BASE_DIR}/wallet"
export WALLET_FILE="${WALLET_DATA}/test-wallet"
export CONFIG_PATH="${BASE_DIR}/config"
export LOGS_DATA="${BASE_DIR}/logs"
export WALLET_RPC="${BASE_DIR}/cli/lethean-wallet-rpc"
export WALLET_CLI="${BASE_DIR}/cli/lethean-wallet-cli"
export WALLET_VPN_RPC="${BASE_DIR}/cli/lethean-wallet-vpn-rpc"
export CHAIN_IMPORT="${BASE_DIR}/cli/lethean-blockchain-import"
export CHAIN_EXPORT="${BASE_DIR}/cli/lethean-blockchain-export"
export CHAIN_DAEMON="${BASE_DIR}/cli/letheand"
export CHAIN_DATA="${BASE_DIR}/data"
export BC_DATA="${BASE_DIR}/bc"
export BC_MODE="livenet"

export DAEMON_HOST="localhost"
export PORT_P2P="48772"
export PORT_RPC="48782"


runLiveNetDaemon() {
  echo "Livenet Blockchain"
  $CHAIN_DAEMON --non-interactive --config-file "${CONFIG_PATH}"/livenet.conf "$@"
}

runTestNetDaemon() {
  echo "Testnet Blockchain"
  $CHAIN_DAEMON --non-interactive --testnet --config-file "${CONFIG_PATH}"/testnet.conf "$@"
}

exportChain() {
  echo "Exporting Blockchain"
  $CHAIN_EXPORT --data-dir="$CHAIN_DATA/$BC_MODE" --output-file "$BC_DATA/$BC_MODE"/data.lmdb
}

importChain() {
  echo "Blockchain Importing"
  $CHAIN_IMPORT --data-dir="$CHAIN_DATA/$BC_MODE" --input-file "$BC_DATA/$BC_MODE"/data.lmdb
}

runWalletRPC() {

  if [ -z "$WALLET_RPC_URI" ]; then
    echo "Starting Wallet cli with $WALLET_FILE." >&2
    $WALLET_RPC --wallet-file "$WALLET_FILE" --daemon-host "localhost" --password "$WALLET_PASSWORD" --rpc-bind-port "$PORT_RPC" --confirm-external-bind --disable-rpc-login --trusted-daemon  &
    sleep 4
     WALLET_RPC_URI="http://localhost:$PORT_RPC"
  else
    echo "Wallet is outside of container ($WALLET_RPC_URI)." >&2
  fi
}

makeWallet(){
    mkdir -p "${WALLET_DATA}"
    echo "Generating wallet $WALLET_FILE" >&2
    $WALLET_CLI --mnemonic-language English --generate-new-wallet "$WALLET_FILE" --password "$WALLET_PASSWORD"  --command exit
    WALLET_ADDRESS=$(cat "${WALLET_FILE}.address.txt")
    echo "Created new wallet: ${WALLET_ADDRESS}"
    echo "Saved: $WALLET_FILE"
}

case $1 in
sync|letheand)
  shift
  runLiveNetDaemon "$@"
  ;;

daemon)
  shift
  runLiveNetDaemon --detach
  ;;

testnet)
  shift
  runTestNetDaemon "$@"
  ;;

export)
  shift
  exportChain "$@"
  ;;

import)
  shift
  importChain "$@"
  ;;

wallet-rpc)
  shift
  runWalletRPC "$@"
  unset HTTP_PROXY
  unset http_proxy
  shift
  while ! curl "$WALLET_RPC_URI" >/dev/null 2>/dev/null; do
    echo "Waiting for wallet rpc server."
    sleep 5
  done
  ;;

vpn-rpc)
  shift
  runWalletVPNRpc "$@"
  unset HTTP_PROXY
  unset http_proxy
  shift
  while ! curl "$WALLET_VPN_RPC_URI" >/dev/null 2>/dev/null; do
    echo "Waiting for vpn rpc server."
    sleep 5
  done
  ;;

test-seed-node)
  shift
  if [ -z "${*}" ]; then
    NODE_IP="35.217.36.217:48772"
  else
    NODE_IP="$@"
  fi
  echo "Testing connection, Wait and send a 'status' cmd, check for 1 or 0 upstream: " $NODE_IP
  runLiveNetDaemon --add-exclusive-node  "$NODE_IP"
  ;;

test)
  shift
  echo "Testing connection, Wait and send a 'status' cmd, check for 1 or 0 upstream: " $NODE_IP
  runLiveNetDaemon --add-exclusive-node  "$NODE_IP"
  ;;


make-wallet)
  shift
  makeWallet
  ;;

dev-fund)
  shift
  showDevFund "$@"
  ;;

sh | bash)
  /bin/bash
  ;;

bc-size)
  du -h ./data/livenet/lmdb/data.mdb
  ;;

*)
  echo "Available Commands: "
  echo "sync|daemon|import|export|vpn-rpc|wallet-rpc|make-wallet|wallet-cmd|wallet-cli|testnet|bash"
  exit 2
  ;;

esac
