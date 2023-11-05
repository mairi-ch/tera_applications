###################################################
#
# file: parse_results.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  20-01-2021 
# @email:    kolokasis@ics.forth.gr
#
# Parse the results for the experiments
#
###################################################

# Print error/usage script message
usage() {
    echo
    echo "Usage:"
    echo -n "      $0 [option ...] "
    echo
    echo "Options:"
    echo "      -d  Directory with results"
    echo "      -t  Enable TeraHeap"
    echo "      -s  Enable serialization/deserialization"
    echo "      -h  Show usage"
    echo

    exit 1
}


# Check for the input arguments
while getopts "d:n:tsah" opt
do
    case "${opt}" in
        s)
            SER=true
            ;;
        t)
            TH=true
            ;;
        d)
            RESULT_DIR="${OPTARG}"
            ;;
        n)
            NUM_EXECUTORS="${OPTARG}"
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

TOTAL_TIME=$(tail -n 1 ${RESULT_DIR}/total_time.txt | awk '{split($0,a,","); print a[3]}')

MINOR_GC=()
MAJOR_GC=()

for ((i=0; i<NUM_EXECUTORS; i++))
do
  MINOR_GC+=($(tail -n 1 "${RESULT_DIR}"/jstat_${i}.txt | awk '{print $8}'))
  MAJOR_GC+=($(tail -n 1 "${RESULT_DIR}"/jstat_${i}.txt | awk '{print $10}'))
done

# Caclulate the overheads in TeraHeap card table traversal, marking and adjust phases
# if [ $TH ]
# then
#   TC_CT_TRAVERSAL=$(grep "TC_CT" "${RESULT_DIR}"/teraHeap.txt     | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
#   HEAP_CT_TRAVERSAL=$(grep "HEAP_CT" "${RESULT_DIR}"/teraHeap.txt | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
#   PHASE1=$(grep "PHASE1" "${RESULT_DIR}"/teraHeap.txt             | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
#   PHASE2=$(grep "PHASE2" "${RESULT_DIR}"/teraHeap.txt             | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
#   PHASE3=$(grep "PHASE3" "${RESULT_DIR}"/teraHeap.txt             | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
#   PHASE4=$(grep "PHASE4" "${RESULT_DIR}"/teraHeap.txt             | awk '{print $5}' | awk '{ sum += $1 } END {print sum }')
# fi

# Caclulate the serialziation/deserialization overhead

for ((i=0; i<NUM_EXECUTORS; i++))
do
  ../../util/FlameGraph/flamegraph.pl "${RESULT_DIR}"/serdes_"${i}".txt > "${RESULT_DIR}"/profile.svg
  SER_SAMPLES=$(grep "org/apache/spark/serializer/KryoSerializationStream.writeObject" "${RESULT_DIR}"/profile.svg \
    | awk '{print $2}' \
    | sed 's/,//g' | sed 's/(//g' \
    | awk '{sum+=$1} END {print sum}')
  DESER_SAMPLES=$(grep "org/apache/spark/serializer/KryoDeserializationStream.readObject" "${RESULT_DIR}"/profile.svg \
    | awk '{print $2}' \
    | sed 's/,//g' |sed 's/(//g' \
    | awk '{sum+=$1} END {print sum}')
  APP_THREAD_SAMPLES=$(grep -w "java/lang/Thread.run" "${RESULT_DIR}"/profile.svg \
    | awk '{print $2}' \
    | sed 's/,//g' \
    | sed 's/(//g' \
    | head -n 1)

  NET_TIME=$(echo "${TOTAL_TIME} - ${MINOR_GC[$i]} - ${MAJOR_GC[$i]}" | bc -l)
  SD_SAMPLES=$(echo "${SER_SAMPLES} + ${DESER_SAMPLES}" | bc -l)
  SERDES+=($(echo "${SD_SAMPLES} * ${NET_TIME} / ${APP_THREAD_SAMPLES}" | bc -l))
done

{
  echo "COMPONENT,TIME(s)"               
  echo "TOTAL_TIME,${TOTAL_TIME}"

  for ((i=0; i<NUM_EXECUTORS; i++))
  do
    echo "MINOR_GC,${MINOR_GC[$i]}"
    echo "MAJOR_GC,${MAJOR_GC[$i]}"
  done

  echo "TC_MINOR_GC,${TC_CT_TRAVERSAL}"
  echo "HEAP_MINOR_GC,${HEAP_CT_TRAVERSAL}"
  echo "PHASE1_FGC,${PHASE1}"
  echo "PHASE2_FGC,${PHASE2}"
  echo "PHASE3_FGC,${PHASE3}"
  echo "PHASE4_FGC,${PHASE4}"
  for ((i=0; i<NUM_EXECUTORS; i++))
  do
    echo "SERSES,${SERDES[$i]}"
  done
} >> "${RESULT_DIR}"/result.csv

{
  echo "SER_SAMPLES,${SER_SAMPLES}"
  echo "DESER_SAMPLES,${DESER_SAMPLES}"
  echo "APP_THREAD_SAMPLES,${APP_THREAD_SAMPLES}"
} >> "${RESULT_DIR}"/serdes.csv

# if [ $TH ]
# then
#   {
#     grep "TOTAL_TRANS_OBJ" "${RESULT_DIR}"/teraHeap.txt | awk '{print $3","$5}'
#     grep "TOTAL_FORWARD_PTRS" "${RESULT_DIR}"/teraHeap.txt | awk '{print $3","$5}'
#     grep "TOTAL_BACK_PTRS" "${RESULT_DIR}"/teraHeap.txt | awk '{print $3","$5}'
#     grep "DUMMY" "${RESULT_DIR}"/teraHeap.txt | awk '{sum+=$6} END {print "DUMMY_OBJ_SIZE(GB),"sum*8/1024/1024}'
#     grep "DISTRIBUTION" "${RESULT_DIR}"/teraHeap.txt |tail -n 1 |awk '{print $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12" " $13 " " $14 " " $15}'
#   } >> "${RESULT_DIR}"/statistics.csv
# fi

# Read the Utilization from system.csv file
USR_UTIL_PER=$(grep "USR_UTIL" "${RESULT_DIR}"/system.csv |awk -F ',' '{print $2}')
SYS_UTIL_PER=$(grep "SYS_UTIL" "${RESULT_DIR}"/system.csv |awk -F ',' '{print $2}')
IO_UTIL_PER=$(grep "IOW_UTIL" "${RESULT_DIR}"/system.csv |awk -F ',' '{print $2}')

# Convert CPU utilization to time 
USR_TIME=$( echo "${TOTAL_TIME} * ${USR_UTIL_PER} / 100" | bc -l )
SYS_TIME=$( echo "${TOTAL_TIME} * ${SYS_UTIL_PER} / 100" | bc -l )
IOW_TIME=$( echo "${TOTAL_TIME} * ${IO_UTIL_PER} / 100" | bc -l )

{
  echo
  echo
  echo "CPU_COMPONENT,TIME(s)"
  echo "USR_TIME,${USR_TIME}"
  echo "SYS_TIME,${SYS_TIME}"
  echo "IOW_TIME,${IOW_TIME}"
} >> "${RESULT_DIR}"/result.csv
