clean:
	rm -rf bench_out/*
	rm -rf spark/scripts/log.out
	rm -rf spark/spark-3.3.0/logs/*
	rm -rf spark/spark-3.3.0/work/*
	rm -rf /tmp/nvme/mariach/shuffle/*
	sh spark/spark-3.3.0/sbin/stop-all.sh
	xargs -a /sys/fs/cgroup/memory/memlim/cgroup.procs kill

