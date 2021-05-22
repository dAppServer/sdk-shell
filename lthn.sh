#!/bin/bash

#echo "https://lethean.sh/${1}/${2}/${3}"

# shellcheck disable=SC2155
export BASE_DIR=$(pwd)
export CLI_DATA="${BASE_DIR}/cli/${2}"
export WALLET_DATA="${BASE_DIR}/data/${2}"
export CONFIG_PATH="${BASE_DIR}/config"
export CONFIG_DATA="${BASE_DIR}/config/${2}.env"
export LOGS_DATA="${BASE_DIR}/logs/${2}"
export WALLET_RPC="${BASE_DIR}/cli/lethean-wallet-rpc"
export WALLET_CLI="${BASE_DIR}/cli/lethean-wallet-cli"
export WALLET_CLI="${BASE_DIR}/cli/lethean-wallet-vpn-rpc"
export CHAIN_IMPORT="${BASE_DIR}/cli/lethean-blockchain-import"
export CHAIN_EXPORT="${BASE_DIR}/cli/lethean-blockchain-export"
export CHAIN_DAEMON="${BASE_DIR}/cli/letheand"

if [ -f "$CONFIG_DATA" ]; then
   # shellcheck disable=SC1090
   . "${BASE_DIR}"/config/"${2}".env
fi




addArgs() {

  command=${command:-}
  daemon_host=${daemon_host:-nodes.hashvault.pro}
  wallet_file=${wallet_file:-hashvault}
  password=${password:-}

  while [ $# -gt 0 ]; do

    if [[ $1 == *"--"* ]]; then
      param="${1/--/}"
      declare $param="${2/_/-}"
             echo $1 $2 // Optional to see the parameter:value result
    fi

    shift
  done

}

runWalletCmd() {
  cd "$WALLET_DATA" || echo "Cant CD into ${WALLET_DATA}" && exit 2
  addArgs "$@"

  if ! [ -t 0 ]; then
    echo "You must allocate TTY to run letheand! Use -t option" && exit 3
  fi

  # If no --daemon-host fallback to the network
  if [ -z "$daemon_host" ]; then
    WALLET_CMD+=" --daemon-host chain.lethean.network"
  else
    WALLET_CMD+=" --daemon-host ${daemon_host} "
  fi

  # If no --daemon-host fallback to the network
  if [ -z "${wallet_file}" ]; then
    WALLET_CMD+=" --wallet-file chain.lethean.network"
  else
    WALLET_CMD+=" --wallet-file ${wallet_file} "
  fi
  # If no --daemon-host fallback to the network
  if [ ! -z "$password" ]; then
    WALLET_CMD+=" --password ${password} "
  fi

  # If no --command do the default
  if [ -z "${*}" ]; then
    # shellcheck disable=SC2089
    WALLET_CMD+=" --command ${*} "
  fi
  $WALLET_CLI --log-file "${LOGS_DATA}/wallet.log" "$WALLET_CLI_ARGS" "${WALLET_CMD}"

}

showDevFund() {

  if ! [ -t 0 ]; then
    errorExit 3 "You must allocate TTY to run letheand! Use -t option"
  fi
  echo "Starting Dev Fund Watcher"
  runWalletCmd --config_file "${CONFIG_PATH}"/xmr.conf
}
runLiveNetDaemon() {

  if ! [ -t 0 ]; then
    errorExit 3 "You must allocate TTY to run ${CHAIN_DAEMON}! Use -t option"
  fi
  echo "Livenet Blockchain"
  $CHAIN_DAEMON --config-file "${CONFIG_PATH}"/livenet.conf
}

exportChain() {

  if ! [ -t 0 ]; then
    errorExit 3 "You must allocate TTY to run ${CHAIN_EXPORT}! Use -t option"
  fi
  echo "Exporting Blockchain"
  $CHAIN_EXPORT --data-dir=./data/livenet --output-file ./bc/data.lmdb
}

importChain() {

  if ! [ -t 0 ]; then
    errorExit 3 "You must allocate TTY to run ${CHAIN_IMPORT}! Use -t option"
  fi
  echo "Blockchain Importing"
  $CHAIN_IMPORT --data-dir=./data/livenet --db-salvage --input-file ./bc/data.lmdb
}

initCoin() {

  # Create cli directory
  if [ ! -d "$CLI_DATA"/"${1}" ]; then
    echo "Creating $BASE_DIR/cli/${1}"
    mkdir -p "$BASE_DIR"/cli/"${1}" || errorExit 2 "Cant make: $BASE_DIR/cli/${1}"
    export CLI_DATA="$BASE_DIR/cli/${1}"
  fi

  # Create data directory
  if [ ! -d "$BASE_DIR"/data/"${1}" ]; then
    echo "Creating $BASE_DIR/data/${1}"
    mkdir -p "$BASE_DIR/data/${1}"
    export WALLET_DATA="$BASE_DIR/data/${1}"
  fi

  # Create log directory
  if [ ! -d "$BASE_DIR"/cli/"${1}" ]; then
    echo "Creating $BASE_DIR/logs/${1}"
    mkdir -p "$BASE_DIR"/logs/"${1}"
    export LOGS_DATA="$BASE_DIR/logs/${1}"
  fi

  # Create config dir
  if [ ! -f "$CONFIG_DATA" ]; then
    echo "Creating $CONFIG_DATA"
    touch "$CONFIG_DATA"
  fi

}

case $1 in
sync|letheand)
  shift
  runLiveNetDaemon "$@"
  ;;
export)
  shift
  exportChain "$@"
  ;;
import)
  shift
  importChain "$@"
  ;;



balance)
  shift
  runWalletCmd "balance"
  ;;

exchange)
  shift
  runWalletCmd "transfer $EXCHANGE_ADDRESS ${2}"
  ;;

create)
  shift
  if [ ! -f $CONFIG_DATA ]; then
    echo "Starting a new coin, found no config in: $CONFIG_DATA"
    initCoin "$@"
  fi
  runWalletCmd "refresh"
  ;;

dev-fund)
  shift
  showDevFund "$@"
  ;;

sh | bash)
  /bin/bash
  ;;

repair)

  ;;

*)
  echo "Bad command. Use one of:"
  echo "wallet [coin] [help|balance|transfer|sign|verify]|dev-fund|wallet-cli"

  exit 2
  ;;
esac
