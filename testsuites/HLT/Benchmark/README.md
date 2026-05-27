# Cangjie Benchmark

## 1. benchmarks-game

https://benchmarksgame-team.pages.debian.net/benchmarksgame

Compare Cangjie with go, python3, include benchmarks-game and some other programs.

### Run:
```shell
export BENCHROOT=${WORKSPACE}/source/testsuites/Benchmark
cd ${BENCHROOT}/benchmarks-game
cp ../scripts/prepare_input.sh .
mkdir tmp
source prepare_input.sh
python2 bin/bencher.py
```
### Prepare for jet:

Please replace ini and makefile manually for jet backend:
```shell
cp benchmarks-game/makefiles/my.linux.Makefile_jet benchmarks-game/makefiles/my.linux.Makefile
cp benchmarks-game/makefiles/my.linux.ini_jet benchmarks-game/makefiles/my.linux.ini
```

### Push: 

Warning: only run push script when you want to push result to CPLTP!

example:
```shell
cd ${BENCHROOT}
cp scripts/push_to_cptl.py .
cp benchmarks-game/tmp/all_measurements.csv .
python3 push_to_cptl.py llvmgc 
python3 push_to_cptl.py llvmgc_compile
python3 push_to_cptl.py jet # for jet
```

### Notice:

Configs and makefile write in `${BENCHROOT}/benchmarks-game/makefiles/` .

## 2. julia-benchmark

https://github.com/JuliaLang/Microbenchmarks

Compare Cangjie with go, julia.

### Run:
```shell
export BENCHROOT=${WORKSPACE}/source/testsuites/Benchmark
export BENCH_DIR=${BENCHROOT} # used in makefile
cd ${BENCHROOT}/julia-benchmark/OpenBLAS
make clean
make -j 20 > /dev/null
export CGO_LDFLAGS="-L ${BENCHROOT}/julia-benchmark/OpenBLAS/ -lopenblas"
export LD_LIBRARY_PATH=${BENCHROOT}/julia-benchmark/OpenBLAS:$LD_LIBRARY_PATH
cd ${BENCHROOT}/julia-benchmark/Microbenchmarks
make JULIAHOME=/home/jenkins/julia-1.7.0 BACKEND=llvm # $(JULIAHOME)/bin/julia should exist!
make JULIAHOME=/home/jenkins/julia-1.7.0 BACKEND=jet # for jet
```

### Push: 

Warning: only run push script when you want to push result to CPLTP!

example:
```shell
cd ${BENCHROOT}
cp scripts/push_julia_result.py .
python3 push_julia_result.py llvmgc
python3 push_julia_result.py jet # for jet
```

### Notice:

Should go get library before you run!
```
go get github.com/gonum/blas/blas64
go get github.com/gonum/blas/cgo
go get github.com/gonum/matrix/mat64
go get github.com/gonum/stat
```


## 3. linaro-benchmark

Compare Cangjie with java.

### Run&Push:
```shell
export BENCHROOT=${WORKSPACE}/source/testsuites/Benchmark
cd ${BENCHROOT}/linaro-benchmark
mkdir -p out/cj
python3 run-both.py llvmgc
python3 run-both.py jet # for jet
```
### Run&Push:
Add 'push' in args to push data.
```
python3 run-both.py llvmgc push
python3 run-both.py jet push # for jet
```
## 4. vm-benchmarks

Compare Cangjie with java.

### Run:
```shell
export BENCHROOT=${WORKSPACE}/source/testsuites/Benchmark
cd ${BENCHROOT}
cp scripts/run_vm_benchmark.sh .
bash run_vm_benchmark.sh llvmgc
bash run_vm_benchmark.sh jet # for jet
```

### Push: 

Warning: only run push script when you want to push result to CPLTP!

example:
```shell
cd ${BENCHROOT}
cp scripts/push_vm_result.py .
python3 push_vm_result.py llvmgc
python3 push_vm_result.py jet # for jet
```

## 5. MemTest

Runtime stress test tool, not for benchmark.

## 6. API

Benchmark for Cangjie API, todo.
