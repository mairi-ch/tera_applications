# Spark Bench Suite
# Global settings - Configurations

# Spark Master
master="sith3-fast"

# A list of machines where the spark cluster is running
MC_LIST="sith3-fast"

# Use these inputs for fileio
DATA_HDFS=file:///spare/mariach/datasets/SparkBench

# Local dataset optional
DATASET_DIR="${DATA_HDFS}/dataset"

# Use this when run on Spark 2.3.0-kolokasis
SPARK_VERSION=2.3.0
[ -z "$SPARK_HOME" ] &&  export SPARK_HOME=/home1/public/mariach/TeraHeap/tera_applications/spark/spark-3.3.0

SPARK_MASTER=spark://${master}:7077

SPARK_RPC_ASKTIMEOUT=10000
# Spark config in environment variable or aruments of spark-submit 
#SPARK_SERIALIZER=org.apache.spark.serializer.KryoSerializer
SPARK_RDD_COMPRESS=false
#SPARK_IO_COMPRESSION_CODEC=lzf

# Spark options in system.property or arguments of spark-submit 
SPARK_EXECUTOR_MEMORY=38g
SPARK_EXECUTOR_INSTANCES=1
SPARK_EXECUTOR_CORES=8

# Storage levels, see :
STORAGE_LEVEL=MEMORY_ONLY

# For data generation
NUM_OF_PARTITIONS=256

# For running
NUM_TRIALS=1
