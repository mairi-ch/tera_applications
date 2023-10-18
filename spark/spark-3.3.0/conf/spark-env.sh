#!/usr/bin/env bash

JAVA_HOME=/home1/public/mariach/TeraHeap/teraheap/jdk17/build/base-linux/jdk
SPARK_WORKER_CORES=8
SPARK_WORKER_INSTANCES=1
SPARK_WORKER_MEMORY=1200g
SPARK_LOCAL_DIRS=/spare/mariach/shuffle
SPARK_MASTER_IP=spark://sith1-fast:7077
SPARK_MASTER_HOST=sith1-fast
SPARK_LOCAL_IP=sith1-fast
# SPARK_DAEMON_JAVA_OPTS=-XX:-UseParallelOldGC

