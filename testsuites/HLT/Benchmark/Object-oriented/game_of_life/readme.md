# Overview

This test measures performance of new objects allocations and garbage collection. For this a plenty of objects are created
and then become unreachable and should be collected by GC.

# How to run

Each test should be build and run with the correponding `build_and_run.sh` script from java/cj/go directories.
In some of them you should also specify JET_DIR and llvm-gc directories.

Each test will report time, this is exactly the metric that we are interested in. The example of output:

```
Total time: 4718 ms
```

In Java case we run both JET-compiled application and using Hotspot JVM.
In Cangjie case we run JET and LLVM-GC versions.

# How to change problem size

Each test use the pregenerated unput date `data.txt`.
It describes matrix of 1000x1000 size and 10 days as configuration of a benchmarks.

To get new input data you can use java/source/Generator.java, running it as following:

```
java Generator <size> <days> [<seed>]
```

# Notes about implementation and configuration

Each test allocates as much as possible, this is needed to stress the GC and allocators. Do not replace classes with structs and do not try to decrease the pressuare on GC by any other means.
Each test is run with 768mb heap. It is more then enough as the peak memory consumption does not exceed 300mb (however Go dies with such heap, so, we increase it to 768mb).
As Go doesn't have an option to limit heap we have to use ulimit -m to limit it somehow.
 
