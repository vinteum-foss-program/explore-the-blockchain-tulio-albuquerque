# Which tx in block 257,343 spends the coinbase output of block 256,128?
#!/bin/bash

tx_height=257343
coinbase_height=256128

coinbase_block=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $coinbase_height) | jq -r ".tx[0]")
coinbase=$(bitcoin-cli getrawtransaction $coinbase_block true | jq ".txid")

tx_block=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $tx_height) | jq -r ".tx" | jq ".[1:]" | jq --raw-output ".[]")

result=""
for tx in $tx_block; do
    tx_inputs=$(bitcoin-cli getrawtransaction $tx true | jq ".vin[].txid")
    for input in $tx_inputs; do
        # echo $input
        if [ $input == $coinbase ]; then
            result=$tx
            break
        fi
    done
    if [ $input == $coinbase ]; then
        break
    fi
done
echo $result