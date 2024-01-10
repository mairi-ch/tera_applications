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


# The pasuses in conc marking (cm stw phases, young gcs, full gcs)
CM_GC_PAUSES=$(python cm_pauses.py "${RESULT_DIR}/gc.log" | awk '{ sum += $1 } END { print sum/1000.0 }')

#getrusage times for conc threads during CM
CM_CPU_TIME=$(grep "Clean" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

#total CM time including idle time and gcs
CM_C=$(grep "Concurrent Mark Cycle" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | wc -l)
CM_T=$(grep "Concurrent Mark Cycle" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')
# CM_T=$(echo "${CM_T} - ${CLEANUP_GC_T} - ${REMARK_GC_T}" | bc -l)   



TOTAL_TIME=$(tail -n 1 ${RESULT_DIR}/total_time.txt | awk '{split($0,a,","); print a[3]}')

FULL_GC_C=$(grep "Full" ${RESULT_DIR}/gc.log | wc -l)
FULL_GC_T=$(grep "Full" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

YOUNG_GC_C=$(grep "Young" ${RESULT_DIR}/gc.log | grep -v "(Mixed)" | wc -l)
YOUNG_GC_T=$(grep "Young" ${RESULT_DIR}/gc.log | grep -v "(Mixed)" | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

MIX_GC_C=$(grep "(Mixed)" ${RESULT_DIR}/gc.log | wc -l)
MIX_GC_T=$(grep "(Mixed)" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

#remark phase cm stw
REMARK_GC_C=$(grep "Pause Remark" ${RESULT_DIR}/gc.log | wc -l)
REMARK_GC_T=$(grep "Pause Remark" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

#cleanup phase cm stw
CLEANUP_GC_C=$(grep "Pause Cleanup" ${RESULT_DIR}/gc.log | wc -l)
CLEANUP_GC_T=$(grep "Pause Cleanup" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum/1000.0 }')

CM_STW=$(echo "${CLEANUP_GC_T} + ${REMARK_GC_T}" | bc -l) 
STW=$(echo "${FULL_GC_T} + ${YOUNG_GC_T} + ${MIX_GC_T}" | bc -l) 
STW_WITH_CM=$(echo "${CM_STW} + ${STW}" | bc -l) 



#those are cpu time (no idle included)
REFINE_MUTATOR_CPU=$(grep "Mutator refinement vtime" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum }')
REFINE_CONC_CPU=$(grep "Concurrent refinement vtime" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum }')
REFINE_TOTAL_CPU=$(grep "Total refinement vtime" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum }')
REFINE_TOTAL_REF_CPU=$(grep "Refinement thread time" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms$' | awk '{ sum += $1 } END { print sum }')

#those are clock time
REFINE_MUTATOR_WALL=$(grep "Mutator refinement:" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms' | awk '{ sum += $1 } END { print sum }')
REFINE_CONC_WALL=$(grep "Concurrent refinement:" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms' | awk '{ sum += $1 } END { print sum }')
REFINE_TOTAL_WALL=$(grep "Total refinement:" ${RESULT_DIR}/gc.log | grep -oP '(\d+\.\d+)ms' | awk '{ sum += $1 } END { print sum }')


CACHE_MISSES=$(grep "cache-misses" ${RESULT_DIR}/perf | awk '{print $1}' | sed 's/,//g' )

# Caclulate the overheads in TeraHeap card table traversal, marking and adjust phases
if [ $TH ]
then
  TIME_SCAN_H2=$(grep "TIME_SCAN_H2_CT" "${RESULT_DIR}"/teraHeap.txt  | awk '{print $4}' | awk '{ sum += $1 } END {print sum }')
  BYTES_IN_H2=$(tail -n 5 "${RESULT_DIR}"/teraHeap.txt  | grep "TOTAL_OBJECTS_SIZE" | awk '{print $5}')
fi

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
  ALL_SAMPLES=$(grep -w "<title>all" "${RESULT_DIR}"/profile.svg \
   | awk '{print $2}' \
   | sed 's/(//g' \
   | sed 's/,//g')

  NET_TIME=$(echo "${TOTAL_TIME} - ${STW_WITH_CM}" | bc -l) # time the mutator threads were running (aka. only the java application)
  SD_SAMPLES=$(echo "${SER_SAMPLES} + ${DESER_SAMPLES}" | bc -l)

  SERDES_WITH_NET+=($(echo "${SD_SAMPLES} * ${NET_TIME} / ${APP_THREAD_SAMPLES}" | bc -l))
  SERDES_WITH_ALL+=($(echo "${SD_SAMPLES} * ${TOTAL_TIME} / ${ALL_SAMPLES}" | bc -l))
done

OTHER=$(echo "${TOTAL_TIME} - ${STW} - ${SERDES_WITH_ALL}" | bc -l) 
CM_WALL_NO_PAUSES=$(echo "${CM_T} - ${CM_GC_PAUSES} - ${CM_STW}" | bc -l) 



{
  echo "COMPONENT,TIME(sec),COUNT,"               
  echo "TOTAL_TIME,${TOTAL_TIME},,"

  echo "OTHER,${OTHER},,"

  for ((i=0; i<NUM_EXECUTORS; i++))
  do
    echo "SERDES,${SERDES_WITH_ALL[$i]},,"
  done

  echo "YOUNG_GC,${YOUNG_GC_T},${YOUNG_GC_C},"
  echo "MIXED_GC,${MIX_GC_T},${MIX_GC_C},"
  echo "FULL_GC,${FULL_GC_T},${FULL_GC_C},"

  echo ""

  echo "CM_WALL_TIME,${CM_T},${CM_C},"
  echo "CM_GC_PAUSES,${CM_GC_PAUSES},,"
  echo "CM_STW,${CM_STW},,"
  echo "CM_WALL_NO_PAUSES,${CM_WALL_NO_PAUSES},,"


  echo ""
  echo "REFINE_MUTATOR_CPU,${REFINE_MUTATOR_CPU},,"
  echo "REFINE_CONC_CPU,${REFINE_CONC_CPU},,"
  echo "REFINE_TOTAL_CPU,${REFINE_TOTAL_CPU},,"
  echo "REFINE_runService_REF_CPU,${REFINE_TOTAL_REF_CPU},,"

  echo "REFINE_MUTATOR_WALL,${REFINE_MUTATOR_WALL},,"
  echo "REFINE_CONC_WALL,${REFINE_CONC_WALL},,"
  echo "REFINE_TOTAL_WALL,${REFINE_TOTAL_WALL},,"




#those are clock time
  echo ""

  REFINE_CPU=$(echo "${REFINE_MUTATOR_CPU} + ${REFINE_TOTAL_REF_CPU}" | bc -l) 
  

  echo "CACHE_MISSES,${CACHE_MISSES},,"
  echo "CM_CPU_TIME,${CM_CPU_TIME},," #sum of not idle clock ticks from all cpus  
  echo "REFINE_CPU_TIME,${REFINE_CPU},," #sum of not idle clock ticks from all cpus  
  echo "TIME_TO_SCAN_H2,${TIME_SCAN_H2},,"
  echo "BYTES_MOVED_IN_H2,${BYTES_IN_H2},,"

} >> "${RESULT_DIR}"/result.csv




{
  echo "SER_SAMPLES,${SER_SAMPLES}"
  echo "DESER_SAMPLES,${DESER_SAMPLES}"
  echo "APP_THREAD_SAMPLES,${APP_THREAD_SAMPLES}"
  echo "ALL_SAMPLES,${ALL_SAMPLES}"
  echo "SERDES_WITH_NET,${SERDES_WITH_NET}"
  echo "SERDES_WITH_ALL,${SERDES_WITH_ALL}"
} >> "${RESULT_DIR}"/serdes.csv

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
  echo "CPU_COMPONENT,TIME(sec),,"
  echo "USR_TIME,${USR_TIME},,"
  echo "SYS_TIME,${SYS_TIME},,"
  echo "IOW_TIME,${IOW_TIME},,"
} >> "${RESULT_DIR}"/result.csv
