# How many new outputs were created by block 123,456?

hash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock $hash | jq -r ".tx[]")
# echo $block
total=0
for tx in $block; do
    vouts=$(bitcoin-cli getrawtransaction $tx true | jq -r ".vout[].n" | jq -s -r "tojson" | jq -r "length")
    total=$((total+vouts))
done
echo $total