#!/bin/bash

ENVIRONMENT=local
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
while [ $# -gt 0 ]; do
  case "$1" in
    --help)
      echo "Usage: $0 --environment <environment>"
      exit 0
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

RPC_URL=http://localhost:8545
DEPLOYER_KEY=ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Start l1 devnet
echo "boot l1 docker compose in $SCRIPT_DIR/devnet/"
cd $SCRIPT_DIR/devnet && docker compose up -d

echo "wait l1 devnet ok for 40s"
sleep 35s

finalized_l1_block_number="0"
while [ "$finalized_l1_block_number" -le "0" ]; do
    echo "not have finalized block, should wait: $finalized_l1_block_number"
    sleep 8s
    finalized_l1_block_number=$(cast bn -r $RPC_URL finalized)
    if [ -z $finalized_l1_block_number ]; then
        echo "no have finalized block"
        finalized_l1_block_number="0"
    fi
done

echo "current devnet finalized block $finalized_l1_block_number"
