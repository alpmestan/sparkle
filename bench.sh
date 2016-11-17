export DATASET_SIZE=100000
export DATASET_PARTITIONS=64

SPARK_SUBMIT="../../spark-2.0.1-bin-hadoop2.7/bin/spark-submit"

rm -r bench-*.jar*

for n in 1 2 4 8; do
    rm -r /tmp/blockmgr* /tmp/app* /tmp/spark*
    for v in micro-java.jar micro-patched-sparkle.jar micro-nonpatched-sparkle.jar; do
	SPARK_CMD=""
	if [ $v = "micro-java.jar" ]; then
	    SPARK_CMD="$SPARK_SUBMIT --class Micro --master local[$n] $v"
	else
	    SPARK_CMD="$SPARK_SUBMIT --master local[$n] $v"
	fi
	for i in $(seq 10); do
	    echo "Running $v on $n cores, sample $i"
	    echo $SPARK_CMD
	    $SPARK_CMD 2>&1 | grep "Job.*finished" | sed -e 's/took /\n/g' | tail -1 | sed -e 's/,/./g' | sed -e 's/ /\n/g' | head -1 >> bench-$v-$n-cores
	done
    done
done
