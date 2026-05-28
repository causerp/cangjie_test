// Performance.now is used in latency benchmarks, the fallback is Date.now.
class Performance {
    now() {
        return Date.now();
    }
}
var performance = new Performance();

class Benchmark {
    constructor(name, doWarmup, doDeterministic, deterministicIterations,
                run, setup, tearDown, rmsResult, minIterations) {
        this.name = name;
        this.doWarmup = doWarmup;
        this.doDeterministic = doDeterministic;
        this.deterministicIterations = deterministicIterations;
        this.run = run;
        this.Setup = setup ? setup : function() {};
        this.TearDown = tearDown ? tearDown : function() {};
        this.rmsResult = rmsResult ? rmsResult : null;
        this.minIterations = minIterations ? minIterations : 32;
    }
}


class BenchmarkResult {
    constructor(benchmark, time, latency) {
        this.benchmark = benchmark;
        this.time = time;
        this.latency = latency;
    }
    valueOf() {
        return this.time;
    }
}

class BenchmarkSuite {
    constructor(name, reference, benchmarks) {
        this.name = name;
        this.reference = reference;
        this.benchmarks = benchmarks;
        BenchmarkSuite_suites.push(this);
    }
    NotifyStep(result) {
        this.results.push(result);
    }
    NotifyResult() {
        var mean = BenchmarkSuite_GeometricMeanTime(this.results);
        var score = this.reference[0] / mean;
        BenchmarkSuite_scores.push(score);
        if (this.runner.NotifyResult) {
            var formatted = BenchmarkSuite_FormatScore(100 * score);
            this.runner.NotifyResult(this.name, formatted);
        }
        if (this.reference.length == 2) {
            var meanLatency = BenchmarkSuite_GeometricMeanLatency(this.results);
            if (meanLatency != 0) {
                var scoreLatency = this.reference[1] / meanLatency;
                BenchmarkSuite_scores.push(scoreLatency);
                if (this.runner.NotifyResult) {
                    var formattedLatency = BenchmarkSuite_FormatScore(100 * scoreLatency)
                    this.runner.NotifyResult(this.name + "Latency", formattedLatency);
                }
            }
        }
    }
    NotifySkipped(runner) {
        BenchmarkSuite_scores.push(1); // push default reference score.
        if (runner.NotifyResult) {
            runner.NotifyResult(this.name, "Skipped");
        }
    }
    NotifyError(error) {
        this.runner.NotifyError(this.name, error);
    }
    RunSingleBenchmark(benchmark, data) {
        var config = BenchmarkSuite_config;
        var doWarmup = config.doWarmup !== undefined ?
            config.doWarmup :
            benchmark.doWarmup;
        var doDeterministic = config.doDeterministic !== undefined ?
            config.doDeterministic :
            benchmark.doDeterministic;

        // Sets up data in order to skip or not the warmup phase.
        if (!doWarmup && data == null) {
            data = { runs: 0, elapsed: 0 };
        }

        if (data == null) {
            Measure(null, doDeterministic, benchmark);
            return { runs: 0, elapsed: 0 };
        } else {
            Measure(data, doDeterministic, benchmark);
            // If we've run too few iterations, we continue for another second.
            if (data.runs < benchmark.minIterations) return data;
            var usec = (data.elapsed * 1000) / data.runs;
            var rms = (benchmark.rmsResult != null) ? benchmark.rmsResult() : 0;

            this.NotifyStep(new BenchmarkResult(benchmark, usec, rms));
            return null;
        }
    }
    RunStep(runner) {
        BenchmarkSuite_ResetRNG();
        this.results = [];
        this.runner = runner;
        var obj = {
            length: this.benchmarks.length,
            index: 0,
            suite: this,
            data: null
        }
        // Start out running the setup.
        RunNextSetup(obj);
        // return RunNextSetup(obj);
    }
}


class BenchmarkSuite_Config {
    constructor() {
        this.doWarmup = undefined;
        this.doDeterministic = undefined;
    }
}

// Keep track of all declared benchmark suites.
var BenchmarkSuite_suites = [];

var BenchmarkSuite_version = '9';

var BenchmarkSuite_config = new BenchmarkSuite_Config();

// Override the alert function to throw an exception instead.
function alert(s) {
    throw "Alert called with argument: " + s;
}

function RunNextSetup(obj) {
    if (obj.index < obj.length) {
        try {
            obj.suite.benchmarks[obj.index].Setup();
        } catch (e) {
            obj.suite.NotifyError(e);
            return null;
        }

        RunNextBenchmark(obj);
        return
    }
    obj.suite.NotifyResult();
    return null;
}

function RunNextBenchmark(obj) {
    try {
        obj.data = obj.suite.RunSingleBenchmark(obj.suite.benchmarks[obj.index], obj.data);
    } catch (e) {
        obj.suite.NotifyError(e);
        return null;
    }
    // If data is null, we're done with this benchmark.
    if (obj.data == null) {
        RunNextTearDown(obj)
    } else {
        RunNextBenchmark(obj);
    }
    // return (obj.data == null) ? RunNextTearDown(obj) : RunNextBenchmark(obj);
}

function RunNextTearDown(obj) {
    try {
        obj.suite.benchmarks[obj.index++].TearDown();
    } catch (e) {
        obj.suite.NotifyError(e);
        return null;
    }
    RunNextSetup(obj);
    // return RunNextSetup(obj);
}

function BenchmarkSuite_ResetRNG() {
    Math.random = (function() {
        var seed = 49734321;
        return function() {
            // Robert Jenkins' 32 bit integer hash function.
            seed = ((seed + 0x7ed55d16) + (seed << 12)) & 0xffffffff;
            seed = ((seed ^ 0xc761c23c) ^ (seed >>> 19)) & 0xffffffff;
            seed = ((seed + 0x165667b1) + (seed << 5)) & 0xffffffff;
            seed = ((seed + 0xd3a2646c) ^ (seed << 9)) & 0xffffffff;
            seed = ((seed + 0xfd7046c5) + (seed << 3)) & 0xffffffff;
            seed = ((seed ^ 0xb55a4f09) ^ (seed >>> 16)) & 0xffffffff;
            return (seed & 0xfffffff) / 0x10000000;
        };
    })();
}

var BenchmarkSuite_scores = [];

function BenchmarkSuite_RunSuites(runner, skipBenchmarks) {
    skipBenchmarks = typeof skipBenchmarks === 'undefined' ? [] : skipBenchmarks;
    var continuation = null;
    var suites = BenchmarkSuite_suites;
    var length = suites.length;
    var index = 0;

    while (continuation || index < length) {
        var suite = suites[index++];
        continuation = suite.RunStep(runner);
    }

    // show final result
    var score = BenchmarkSuite_GeometricMean(BenchmarkSuite_scores);
    var formatted = BenchmarkSuite_FormatScore(100 * score);
    runner.NotifyScore(formatted);
    // RunStep();
}

function BenchmarkSuite_CountBenchmarks() {
    var result = 0;
    var suites = BenchmarkSuite_suites;
    for (var i = 0; i < suites.length; i++) {
        result += suites[i].benchmarks.length;
    }
    return result;
}

function BenchmarkSuite_GeometricMean(numbers) {
    var log = 0;
    for (var i = 0; i < numbers.length; i++) {
        log += Math.log(numbers[i]);
    }
    return Math.pow(Math.E, log / numbers.length);
}

function BenchmarkSuite_GeometricMeanTime(measurements) {
    var log = 0;
    for (var i = 0; i < measurements.length; i++) {
        log += Math.log(measurements[i].time);
    }
    return Math.pow(Math.E, log / measurements.length);
}

function BenchmarkSuite_GeometricMeanLatency(measurements) {
    var log = 0;
    var hasLatencyResult = false;
    for (var i = 0; i < measurements.length; i++) {
        if (measurements[i].latency != 0) {
            log += Math.log(measurements[i].latency);
            hasLatencyResult = true;
        }
    }
    if (hasLatencyResult) {
        return Math.pow(Math.E, log / measurements.length);
    } else {
        return 0;
    }
}

function BenchmarkSuite_FormatScore(value) {
    if (value > 100) {
        return value.toFixed(0);
    } else {
        return value.toPrecision(3);
    }
}

function Measure(data, doDeterministic, benchmark) {
    var elapsed = 0;
    var start = new Date();
    for (var i = 0;
         (doDeterministic ?
             i < benchmark.deterministicIterations : elapsed < 1000); i++) {
        benchmark.run();
        elapsed = new Date() - start;
    }

    if (data != null) {
        data.runs += i;
        data.elapsed += elapsed;
    }
}


//----------------------------------splay start-------------------------------------//
// Copyright 2009 the V8 project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// This benchmark is based on a JavaScript log processing module used
// by the V8 profiler to generate execution time profiles for runs of
// JavaScript applications, and it effectively measures how fast the
// JavaScript engine is at allocating nodes and reclaiming the memory
// used for old nodes. Because of the way splay trees work, the engine
// also has to deal with a lot of changes to the large tree object
// graph.

var count = 0;

function GeneratePayloadTree(depth, tag) {
    if (depth == 0) {
        // return null;
        return {
            array: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
            string: 'String for key ' + tag + ' in leaf node'
        };
    } else {
        // return null;
        return {
            left: GeneratePayloadTree(depth - 1, tag),
            right: GeneratePayloadTree(depth - 1, tag)
        };
    }
}


function GenerateKey() {
    // The benchmark framework guarantees that Math.random is
    // deterministic; see base.js.
    return Math.random();
}

function SplayRMS() {
    return Math.round(Math.sqrt(splaySumOfSquaredPauses / splaySamples) * 10000);
}

function SplayUpdateStats(time) {
    var pause = time - splaySampleTimeStart;
    splaySampleTimeStart = time;
    splaySamples++;
    splaySumOfSquaredPauses += pause * pause;
}

function InsertNewNode() {
    // Insert new node with a unique key.
    var key;
    do {
        key = GenerateKey();
    } while (splayTree.find(key) != null);
    var payload = GeneratePayloadTree(kSplayTreePayloadDepth, String(key));
    splayTree.insert(key, payload);
    return key;
}


function SplaySetup() {
    // Check if the platform has the performance.now high resolution timer.
    // If not, throw exception and quit.
    if (!performance.now) {
        throw "PerformanceNowUnsupported";
    }

    splayTree = new SplayTree();
    splaySampleTimeStart = performance.now()
    for (var i = 0; i < kSplayTreeSize; i++) {
        InsertNewNode();
        if ((i + 1) % 20 == 19) {
            SplayUpdateStats(performance.now());
        }
    }
}


function SplayTearDown() {
    // Allow the garbage collector to reclaim the memory
    // used by the splay tree no matter how we exit the
    // tear down function.
    var keys = splayTree.exportKeys();
    splayTree = null;

    splaySamples = 0;
    splaySumOfSquaredPauses = 0;

    // Verify that the splay tree has the right size.
    var length = keys.length;
    if (length != kSplayTreeSize) {
        throw new Error("Splay tree has wrong size");
    }

    // Verify that the splay tree has sorted, unique keys.
    for (var i = 0; i < length - 1; i++) {
        if (keys[i] >= keys[i + 1]) {
            throw new Error("Splay tree not sorted");
        }
    }
}


function SplayRun() {
    // Replace a few nodes in the splay tree.
    for (var i = 0; i < kSplayTreeModifications; i++) {
        var key = InsertNewNode();
        var greatest = splayTree.findGreatestLessThan(key);
        if (greatest == null) splayTree.remove(key);
        else splayTree.remove(greatest.key);
    }
    SplayUpdateStats(performance.now());
}
class SplayTree {
    isEmpty() {
        return !this.root_;
    }
    insert(key, value) {

        if (this.isEmpty()) {
            this.root_ = new SplayTree_Node(key, value);
            return;
        }
        // Splay on the key to move the last node on the search path for
        // the key to the root of the tree.
        this.splay_(key);
        if (this.root_.key == key) {
            return;
        }
        var node = new SplayTree_Node(key, value);
        if (key > this.root_.key) {
            node.left = this.root_;
            node.right = this.root_.right;
            this.root_.right = null;
        } else {
            node.right = this.root_;
            node.left = this.root_.left;
            this.root_.left = null;
        }
        this.root_ = node;
    }
    remove(key) {
        if (this.isEmpty()) {
            throw Error('Key not found: ' + key);
        }
        this.splay_(key);
        if (this.root_.key != key) {
            throw Error('Key not found: ' + key);
        }
        // var removed = this.root_;
        if (!this.root_.left) {
            this.root_ = this.root_.right;
        } else {
            var right = this.root_.right;
            this.root_ = this.root_.left;
            // Splay to make sure that the new root has an empty right child.
            this.splay_(key);
            // Insert the original right child as the right child of the new
            // root.
            this.root_.right = right;
        }
        // return removed;
    }
    find(key) {
        if (this.isEmpty()) {
            return null;
        }
        this.splay_(key);
        return this.root_.key == key ? this.root_ : null;
    }
    findMax(opt_startNode) {
        if (this.isEmpty()) {
            return null;
        }
        var current = opt_startNode || this.root_;
        while (current.right) {
            current = current.right;
        }
        return current;
    }
    findGreatestLessThan(key) {
        if (this.isEmpty()) {
            return null;
        }
        // Splay on the key to move the node with the given key or the last
        // node on the search path to the top of the tree.
        this.splay_(key);
        // Now the result is either the root node or the greatest node in
        // the left subtree.
        if (this.root_.key < key) {
            return this.root_;
        } else if (this.root_.left) {
            return this.findMax(this.root_.left);
        } else {
            return null;
        }
    }
    exportKeys() {
        var result = [];
        if (!this.isEmpty()) {
            // this.root_.traverse_(function(node) { result.push(node.key); });
            this.root_.traverse_(result);

        }
        return result;
    }
    splay_(key) {
        if (this.isEmpty()) {
            return;
        }
        // Create a dummy node.  The use of the dummy node is a bit
        // counter-intuitive: The right child of the dummy node will hold
        // the L tree of the algorithm.  The left child of the dummy node
        // will hold the R tree of the algorithm.  Using a dummy node, left
        // and right will always be nodes and we avoid special cases.
        var dummy, left, right;
        dummy = left = right = new SplayTree_Node(null, null);
        var current = this.root_;
        while (true) {
            if (key < current.key) {
                if (!current.left) {
                    break;
                }
                if (key < current.left.key) {
                    // Rotate right.
                    var tmp = current.left;
                    current.left = tmp.right;
                    tmp.right = current;
                    current = tmp;
                    if (!current.left) {
                        break;
                    }
                }
                // Link right.
                right.left = current;
                right = current;
                current = current.left;
            } else if (key > current.key) {
                if (!current.right) {
                    break;
                }
                if (key > current.right.key) {
                    // Rotate left.
                    var tmp = current.right;
                    current.right = tmp.left;
                    tmp.left = current;
                    current = tmp;
                    if (!current.right) {
                        break;
                    }
                }
                // Link left.
                left.right = current;
                left = current;
                current = current.right;
            } else {
                break;
            }
        }
        // Assemble.
        left.right = current.left;
        right.left = current.right;
        current.left = dummy.right;
        current.right = dummy.left;
        this.root_ = current;
    }
}

class SplayTree_Node {
    constructor(key, value) {
        this.key = key;
        this.value = value;
        this.left = null;
        this.left = null;
        this.right = null;
    }
    traverse_(f) {
        var current = this;
        while (current) {
            var left = current.left;
            if (left) left.traverse_(f);
            f.push(current.key)
            // f(current);
            current = current.right;
        }
    }
}

BenchmarkSuite_suites = []

var Splay = new BenchmarkSuite('Splay', [81491, 2739514], [
    new Benchmark("Splay", true, false, 1400,
        SplayRun, SplaySetup, SplayTearDown, SplayRMS)
]);

var kSplayTreeSize = 8000;
var kSplayTreeModifications = 80;
var kSplayTreePayloadDepth = 5;

var splayTree = null;
var splaySampleTimeStart = 0.0;

var splaySamples = 0;
var splaySumOfSquaredPauses = 0;



//-------------------------------------splay end--------------------------------------------


function PrintResult(name, result) {
    console.log("JS_Benchmark testsplay " + name + ': ' + result);
}


function PrintError(name, error) {
    PrintResult(name, error);
    success = false;
}


function PrintScore(score) {
    if (success) {
        console.log('JS_Benchmark testsplay ' + 'Score (version ' + BenchmarkSuite_version + '): ' + score);
    }
}


// BenchmarkSuite_config.doWarmup = undefined;
// BenchmarkSuite_config.doDeterministic = undefined;
var success = true;

function splayScoreRun() {
    BenchmarkSuite_RunSuites({
        NotifyResult: PrintResult,
        NotifyError: PrintError,
        NotifyScore: PrintScore
    });
}

splayScoreRun()