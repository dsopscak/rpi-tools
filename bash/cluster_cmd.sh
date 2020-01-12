#/usr/bin/env bash
#
# cluster_cmd.sh <cmd>
#
# Run cmd on each node in cluster, assuming standardized hostnames for
# nodes. Set CLUSTER_NODECOUNT unless default of 4 is cool.

CMD="$1"
if [[ -z "$CLUSTER_NODECOUNT" ]]; then
    CLUSTER_NODECOUNT=4
fi

for s in $(seq -f "%02.0f" $CLUSTER_NODECOUNT); do
    echo "ssh pi$s \"$CMD\""
    ssh pi$s "$CMD"
done


