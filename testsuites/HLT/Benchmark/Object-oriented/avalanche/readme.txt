/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */


# Overview
Avalanche test measures performance of dynamic memory allocation in multithreadead context.
Benchmark is intentionally written to minimize all other overheads of memory manager -- every created object immediately becomes garbage and there is no heap graph mutation (no read or write GC barriers required).

How to run:
```
  program <iterations.per.thread> <threads> <total.repeats>
```

`threads` defines number of threads/goroutines/LightWeightThreads to be started, each thread would execute `iterations.per.thread` allocation operations and benchmark would report following figures:
   1. `Throughput (units / msec)` -- overall performance of a system. It is expected to increase as soon as number of therads grows.
   2. `Normalized throughput (units / msec)` -- average performance of a particular thread. It is expected to remain constant if memory allocator is scalable. Please refer to "Hardware point of view" section.




# Optimizing compiler point of view

Code in benchmarks is written in a little bit "artificial" way to ensure that any optimizing compiler will not replace dynamic memory allocation with something simple (e.g. we are trying our best to avoid 
"scalar replacement", "stack allocation", "partial escape analysis", "loop hoisting" and other optimizations). For example, hand-coded random generator is introduced instead of simple
```
static bool alwaysFalse = false;
...
if (alwaysFalse) {
  // fake object escape
  blackHole = tmp;
}
```
just to be sure that concurrently running threads do not access the same memory location thus avoiding "false sharing" problem (https://en.wikipedia.org/wiki/False_sharing).

DO NOT MODIFY SOURCE CODE unless you hundred percent sure that your modification is safe.



# Hardware point of view

Ideal memory allocator would scale linearly across available cores (`normalized throughput` number should not decrease significantly). 
Note, however, that memory subsystem of commodity hardware does not scale well (see "What Every Programmer Should Know About Memory" by Ulrich Drepper, section" 6.4.3 Bandwidth Considerations",  https://people.freebsd.org/~lstewart/articles/cpumemory.pdf).
So, the same benchmark may show different numbers when different memory limits are used. For example, whenever heap/TLAB fits into L1/L2/L3 cache of a processor, performance gain is tremendous.
That is why recommended heap size should be fixed and quite large (use -Xmx100Mb and equivalents), just to avoid such "cache-oriented" performance spikes.
