#!/usr/bin/env bash

###################################################
#
# file: run.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  20-01-2021 
# @email:    kolokasis@ics.forth.gr
#
# Scrpt to run the experiments
#
###################################################

set -x

. ./conf.sh

##
# Description:
#   Create a cgroup
setup_cgroup() {
	# Change user/group IDs to your own
	sudo cgcreate -a mariach:carvsudo -t mariach:carvsudo -g memory:memlim
	cgset -r memory.limit_in_bytes="$MEM_BUDGET" memlim
}

##
# Description:
#   Delete a cgroup
delete_cgroup() {
	sudo cgdelete memory:memlim
}

run_cgexec() {
  cgexec -g memory:memlim --sticky ./run_cgexec.sh "$@"
}

##
# Description: 
#   Start Spark
##
start_spark() {
  run_cgexec "${SPARK_DIR}"/sbin/start-all.sh >> "${BENCH_LOG}" 2>&1
}

##
# Description: 
#   Stop Spark
##
stop_spark() {
  run_cgexec "${SPARK_DIR}"/sbin/stop-all.sh >> "${BENCH_LOG}" 2>&1
  xargs -a /sys/fs/cgroup/memory/memlim/cgroup.procs kill
}


CUSTOM_BENCHMARK=false

for benchmark in "${BENCHMARKS[@]}"
do
  setup_cgroup

  cp ./configs/native/spark-defaults.conf "${SPARK_DIR}"/conf

  ./update_conf.sh -b ${CUSTOM_BENCHMARK}

  start_spark

  # Run benchmark and save output to tmp_out.txt
  run_cgexec "${SPARK_BENCH_DIR}"/"${benchmark}"/bin/gen_data.sh >> "${BENCH_LOG}" 2>&1

  stop_spark

  
  delete_cgroup
done

