# sed -i '21s/.*/S_LEVEL=("MEMORY_ONLY")/' conf.sh
sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/bench_out/short_out -f -p -s


# ##Logistic
# sed -i '21s/.*/S_LEVEL=("MEMORY_AND_DISK")/' conf.sh
# sed -i '22s/.*/MEM_BUDGET=7G/' conf.sh
# sed -i '23s/.*/H1_SIZE=(5)/' conf.sh
# sed -i '25s/.*/BENCHMARKS=("LogisticRegression")/' conf.sh
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Vanilla -f -p -s

# sed -i '21s/.*/S_LEVEL=("MEMORY_ONLY")/' conf.sh
# sed -i '23s/.*/H1_SIZE=(2)/' conf.sh
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final/LoR_Tera -f -p -t


# ##Linear
# sed -i '25s/.*/BENCHMARKS=("LinearRegression")/' conf.sh
# sed -i '21s/.*/S_LEVEL=("MEMORY_ONLY")/' conf.sh
# sed -i '22s/.*/MEM_BUDGET=7G/' conf.sh
# sed -i '23s/.*/H1_SIZE=(2)/' conf.sh
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/LiR_Tera -f -p -t


##Shortest path
# sed -i '25s/.*/BENCHMARKS=("ShortestPaths")/' conf.sh
# sed -i '21s/.*/S_LEVEL=("MEMORY_AND_DISK")/' conf.sh
# sed -i '22s/.*/MEM_BUDGET=10G/' conf.sh
# sed -i '23s/.*/H1_SIZE=(8)/' conf.sh
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Vanilla -f -p -s
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Vanilla -f -p -s

# sed -i '21s/.*/S_LEVEL=("MEMORY_ONLY")/' conf.sh
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Tera -f -p -t
# sh run.sh -n 1 -o /home1/public/mariach/TeraHeap/tera_applications/final2/SVD_Tera -f -p -t

