# Cangjie Concurrency Benchmark

## Introduction

### EnterExit
Benchmark measures performance of built-in `sync/Monitor` used as a critical section (no `wait/notify` operations).  
Supported modes of operation:
1) Biased. Single thread creates Monitor instance and uses it throughout all benchmark.
2) Bacon. Thread A creates Monitor instance but Thread B uses this instance to run specified workload.
 
Modes (1) and (2) are using just one thread (no concurrency overheads) and could be used to estimate performance of "happy path". As we see in real-world scenarios, sometimes thread uses synchronization to protect its own resources (mode (1)) and sometimes data is transferred to other thread that become a single user of corresponding data structure (mode (2)).
 
3) "Monitor uncontended". Only one thread actually accesses the data but special tricks are used to "persuade" runtime that many threads are going to compete over the monitor. Note that some advanced techniques (e.g. "monitor deflation") exploited by runtime system may transform this mode into (1) or (2).
4) "Monitor contended". Several threads are concurrently competing over (non-overlapping) memory chunks guarded by single Monitor instance.
 
Insights: benchmark is very sensitive to selected spinning policy -- both on application level ("hand-made" mutexes) and OS level (futex spin etc.). Consider using `-scheduling-stat` to analyse number of "context-switches" during run.
 
### SynchProdCons
Benchmark measures performance of built-in `sync/Monitor` used as a condition variable -- two threads ("pair") are ping-ponging a signal via `wait/notify`. User may select number of pairs that are intercommunicating simultaneously. Pairs are independent -- they share no common data, only CPU time.
 
### WaitNotifyBench
Benchmark measures performance of built-in `sync/Monitor` and `sync/MultiConditionMonitor` used to implement "producer-consumer" pattern.
N threads are producing data and save it into shared `workList`. M threads are consuming data from this list.
Supported modes of operation:
1) WaitNotifyBase uses two Monitor instances: `monitorForConsumer` and `monitorForProducer` which allow threads to auto-balance consumption and production -- consumers are waiting for data to appear in `workList`, producers are waiting for data to be processed before pushing additional workload.
2) WaitNotifySingleLock. Single MultiConditionMonitor instance is associated with two Conditions which use the same auto-balancing technique as in previous mode.

### StartEndCost
Benchmark evaluates the cost of creation and destruction of coroutines.

### Scheduler 
Benchmark simulates a system that handles a number of simultaneously running tasks of different duration.
This benchmark is organized according to the following principles:
1) a separate coroutine is created for each task
2) there are tasks of two kinds:
- heavy tasks to simulate requests that require long processing like uploading or hashing of a big file
- light tasks to simulate quickly processed requests like simply returning some cached values

This benchmark creates light tasks waiting for a signal and heavy tasks waiting for another signal. First, all heavy tasks are resumed (and therefore, scheduled for execution), then all light tasks are resumed. Completion time for a light task is defined as that elapsed from the moment of resuming the light tasks till this task finishes. The metrics is computed as average time for completion over all **light tasks**, the lower, the better.

This benchmark has two modes:
1. preempt: the running tasks include light tasks and heavy tasks. The number of light tasks is much greater than that of heavy tasks.
2. enmass: the running tasks contains only light tasks.

### PerThreadMemUsage
This benchmark measures the memory usage per thread.  
Per thread memory usage evaluated as (RSS_threads – RSS_1) / (threads – 1)

### Echo

Benchmark measures overheads of library implementation of non-blocking sockets as well as scheduling overheads of runtime.

To observe the scheduler's overhead the number of threads could be varied, e.g.:

1) With one carrier thread we could observe the difference in performance solely of library implementation and polling mechanism.
2) By increasing the number of carriers, we could observe how scheduler's synchronization overhead affects performance.

To facillitate the setup of the benchmarking environment, it is suggested to specify the number of connections
to be not significantly large.


## Run
### Auto Run

```
export OUTPUT=<absolute path of result.csv>
export JET_DIR=
export LLVM_GC_DIR=
export JAVA_DIR=
export LOOM_DIR=
./test.sh [cj/jet | cj/jet/pgo | cj/llvmgc | go | java | loom]
```

Note: java19(loom) uses virtual threads (for details: https://openjdk.org/jeps/425) to measure the performance of concurrency.
### Manual Run

#### EnterExit
```
Usage: -biased | -bacon | -mon-uncontended | -mon-contended [-size <value>] [-threads <num of threads>] [-scheduling-stat <num of slices>]
```
#### SynchProdCons
```
Usage: [-iter <num>] [-threadPairs <numx>]
```
#### WaitNotifyBench
```
Usage: base | singleLock c=<consumers> p=<producers> v=<valuePerProducer> s=<spinners>
```
### StartEndCost
```
Usage: <num>
```
### VariousSizeTasks
```
Usage: preempt | enmasse [num of light tasks] [num of heavy tasks]
```
Note: In enmasse mode, the number of heavy tasks must be 0.
### PerThreadMemUsage
This case needs to be run via a scipt, please check the script at <ROOT_PATH>/PerThreadMemUsage/.
### Echo
```
Usage: [-iter <num>] [-connections <num>]
```
