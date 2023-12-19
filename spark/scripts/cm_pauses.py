import sys

if len(sys.argv) != 2:
    print("Usage: python3 cm_pauses.py <filepath>")
    sys.exit(1)

filename = sys.argv[1]
file = open(filename, 'r')

sum = 0


while True:
    line = file.readline()
    if not line:
        break

    if "Concurrent Mark Cycle" in line:
        # print("Found Concurrent Mark Cycle")
        
        while True:
            line = file.readline()
            if not line:
                break
            if "Concurrent Mark Cycle" in line:
                # print("Found Concurrent Mark Cycle")
                # print("Pauses-sum: ", sum)
                print(sum)
                sum=0
                break
            if "Pause" in line:
                # print("Found Pause")
                ms = line.split(" ")[-1]
                # print(ms)
                sum += float(ms[:-3])