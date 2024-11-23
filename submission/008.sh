# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
tx=$(bitcoin-cli getrawtransaction $txid true)

script=$(echo $tx| jq -r ".vin[0].txinwitness[-1]")
script=$(bitcoin-cli decodescript $script | jq -r ".asm | tojson")
pubkey=$(echo $script | jq -r '. | split(" ")[1]')
echo "$pubkey"
