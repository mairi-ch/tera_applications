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

#AUTO-RUNS
S_LEVEL=("MEMORY_AND_DISK")
MEM_BUDGET=8G
H1_SIZE=(6)

BENCHMARKS=("SVM")
# "PageRank" "ConnectedComponent" "LinearRegression" "LogisticRegression" "ShortestPaths" "SVDPlusPlus" "SVM" "TriangleCount"


#FIND HUMONGOUS : 5 min peripou
# S_LEVEL=( "MEMORY_ONLY" )  
# MEM_BUDGET=90G 
# H1_SIZE=(80)  


# big dram (will be changed later)
# tera h1 : Find the peak alllocation size for humongou. round up to find tera h1 size ( just enough in odrer not to trigger full gc)
# vanilla h1 : Find minimum h1 vanilla can run (not bellow h1 tera, bcs page cache for tera would be too small)
# dram = vanilla h1 should be 70% - 80% of dram

#MEM_BUDGET = DRAM = h1 size + page cache 
#MEM_BUDGET accepts K,M,G
#S_LEVEL = MEMORY_AND_DISK, MEMORY_ONLY

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

# Number of executors
NUM_EXECUTORS=( 1 )
# Total Configurations
TOTAL_CONFS=${#H1_SIZE[@]}
