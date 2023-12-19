#!/usr/bin/env bash

###################################################
#
# file: conf.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  27-02-2021 
# @email:    kolokasis@ics.forth.gr
#
# Experiments configurations. Setup these
# configurations before run
#
###################################################

# SMALL DS
DATA_SIZE=small
DATA_HDFS="file:///spare/mariach/datasets/SparkBench"




# S_LEVEL=( "MEMORY_ONLY" )  # MEMORY_AND_DISK, MEMORY_ONLY
# # cgset accepts K,M,G and eiB, MiB, GiB units for memory limit
# MEM_BUDGET=8G # dram size = h1 size + page cache for h2
# H1_SIZE=(4) # vanilla h1 = 90% of dram 

S_LEVEL=( "MEMORY_AND_DISK" ) 
MEM_BUDGET=8G
H1_SIZE=(7)

# big dram (whatev -changed later)
# h1 size for tera = just enough in odrer not to trigger full gc
# dram = h1 size (for tera) + 4gb page cache
# h1 size for vanilla = 90% of dram  (vanilla doesnt use dram)

# JAVA Home
MY_JAVA_HOME="/home1/public/mariach/TeraHeap/teraheap/jdk17/build/base-linux/jdk"

# Spark Version
SPARK_VERSION=3.3.0
# Number of partitions
NUM_OF_PARTITIONS=256
# Benchmark repo
BENCH_DIR=/home1/public/mariach/TeraHeap/tera_applications
# Spark directory
SPARK_DIR=${BENCH_DIR}/spark/spark-${SPARK_VERSION}
# Spark master log dir
MASTER_LOG_DIR=${SPARK_DIR}/logs
# Spark master log dir
MASTER_METRIC_FILE="${SPARK_DIR}/conf/metrics.properties"
# Spark master node
SPARK_MASTER=sith3-fast
# Spark slave host name
SPARK_SLAVE=sith3-fast


# Device for shuffle
DEV_SHFL=nvme0n1
# Mount point for shuffle directory
MNT_SHFL=/tmp/nvme/mariach/shuffle


# Device for H2
DEV_H2=nvme0n1
# Mount point for H2 TeraHeap directory
MNT_H2=/tmp/nvme/mariach

# Card segment size for H2
CARD_SIZE=$((8 * 1024))
# Region size for H2
REGION_SIZE=$((256 * 1024 * 1024))
# Stripe size for H2
STRIPE_SIZE=$(( REGION_SIZE / CARD_SIZE ))
# TeraCache file size in GB e.g 800 -> 800GB
H2_FILE_SZ=700

# Number of garbage collection threads
GC_THREADS=8
# Executor cores
EXEC_CORES=( 8 )


# SparkBench directory
SPARK_BENCH_DIR=${BENCH_DIR}/spark/spark-bench
#Benchmark log
BENCH_LOG=${BENCH_DIR}/spark/scripts/log.out



# TeraCache configuration size in Spark: 'spark.teracache.heap.size'
H1_H2_SIZE=( 1200 ) #dont

# Spark memory fraction: 'spark.memory.storagefraction'
MEM_FRACTION=( 0.5 ) 
# Running benchmarks
BENCHMARKS=("PageRank")
# "LogisticRegression" "ShortestPaths" "SQL" "SVDPlusPlus" "SVM" "TriangleCount" )
# "PageRank" "ConnectedComponent" "LogisticRegression" "PageRank" "ShortestPaths" "SQL" "SVDPlusPlus" "SVM" "TriangleCount")
# Number of executors
NUM_EXECUTORS=( 1 )
# Total Configurations
TOTAL_CONFS=${#H1_SIZE[@]}
