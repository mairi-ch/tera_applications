#!/usr/bin/env bash

JAVA_HOME=/home1/public/mariach/TeraHeap/teraheap/jdk17/build/base-linux/jdk
SPARK_WORKER_CORES=8
SPARK_WORKER_INSTANCES=1
SPARK_WORKER_MEMORY=7g
SPARK_LOCAL_DIRS=/tmp/nvme/mariach/shuffle
SPARK_MASTER_IP=spark://sith3-fast:7077
SPARK_MASTER_HOST=sith3-fast
SPARK_LOCAL_IP=sith3-fast
# SPARK_DAEMON_JAVA_OPTS=-XX:-UseParallelOldGC

