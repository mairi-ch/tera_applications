##PR
BENCH=PR
sed -i '25s/.*/BENCHMARKS=("PageRank")/' conf.sh
sed -i '22s/.*/MEM_BUDGET=10G/' conf.sh

sed -i '21s/.*/S_LEVEL=("MEMORY_ONLY")/' conf.sh
sed -i '23s/.*/H1_SIZE=(5)/' conf.sh
sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/${BENCH}_tera -f -p -t

##CC
BENCH=CC
sed -i '25s/.*/BENCHMARKS=("ConnectedComponent")/' conf.sh
sed -i '22s/.*/MEM_BUDGET=14G/' conf.sh
sed -i '23s/.*/H1_SIZE=(6)/' conf.sh
sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/${BENCH}_tera -f -p -t
