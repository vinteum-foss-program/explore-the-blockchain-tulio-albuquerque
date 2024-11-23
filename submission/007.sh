# Only one single output remains unspent from block 123,321. What address was it sent to?

tx_height=123321
# addresses=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $tx_height) 2 |\
#     jq -r ".tx" | jq ".[1:]" | jq ".[] | {txid: .txid, address: .vout.[].scriptPubKey.address}")
txs=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $tx_height) 2 |\
    jq -r ".tx.[] | {txid: .txid, n: .vout[].n, address: .vout[].scriptPubKey.address}" | jq -r "tojson")
# txids=
for tx in $txs; do
    txid=$(echo $tx | jq -r ".txid")
    n=$(echo $tx | jq -r ".n")
    utxo=$(bitcoin-cli gettxout $txid $n)
    if [ -n "$utxo" ]; then
        break
    fi
done
echo $utxo | jq -r ".scriptPubKey.address"