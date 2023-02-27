#!/bin/bash
#Grab aya testnet stats

jailed=$(sudo ayad query staking validator ayavaloper1f6ytfl7svdke5vpfgze2p4cjwl4xpxn5ccg438 -o json | jq -r .jailed)
votingpower=$(sudo ayad status | jq -r .ValidatorInfo.VotingPower)
catchingup=$(sudo ayad status | jq -r .SyncInfo.catching_up)
uptime=$(ps -eo comm,etimes | grep cosmovisor)
totaljailed=$(sudo ayad query staking validators -o json --limit 300 | jq '.validators | map(select(.jailed == true)) | length')
totalen=$(sudo ayad query slashing signing-infos -o json --limit 300 | jq '.info[].address' | wc -l)
tombstoned=$(sudo ayad query slashing signing-infos -o json --limit 300 | jq '.info | map(select(.tombstoned == true)) | length')

catchingup=${catchingup//false/1}
catchingup=${catchingup//true/2}
jailed=${catchingup//false/1}
jailed=${catchingup//true/2}
uptime=$(echo $uptime | awk '{ print $2 }')

if [ ! -f /var/lib/prometheus/node-exporter/ayad1.prom ]; then
    sudo touch /var/lib/prometheus/node-exporter/ayad1.prom
fi

sudo cat << EOF > "/var/lib/prometheus/node-exporter/ayad.prom"
# TYPE ayad_stats gauge
ayad_stats_votingpower ${votingpower}
ayad_stats_catchingup ${catchingup}
ayad_stats_jailed ${jailed}
ayad_stats_uptime ${uptime}
ayad_stats_totaljailed ${totaljailed}
ayad_stats_totalen ${totalen}
ayad_stats_tombstoned ${tombstoned}

EOF
