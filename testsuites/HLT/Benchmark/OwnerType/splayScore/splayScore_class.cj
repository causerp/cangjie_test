/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output

import std.time.*
import std.math
import std.math.*
import std.convert.*
import std.collection.*

class Performance {
    func now(){
        return DateTime.now()
    }
}

var performance = Performance()


var kSplayTreeSize = 8000;
var kSplayTreeModifications = 80;
var kSplayTreePayloadDepth = 5;

var splayTree : SplayTree = SplayTree_None();
var splaySampleTimeStart = DateTime.now()

var splaySamples = 0;
var splaySumOfSquaredPauses = 0;
var success = true;



class Benchmark{
    Benchmark(var name:String,
            var doWarmup:Bool,
            var doDeterministic:Bool,
            var deterministicIterations:Int64,
            var run!:()->Unit={=>},
            var Setup!:()->Unit={=>},
            var TearDown!:()->Unit={=>},
            var rmsResult!:()->Float64=SplayRMS,
            var minIterations!:Int64 = 32){}
}

class BenchmarkResult {
    BenchmarkResult(var benchmark:Benchmark,
    var time:Float64,
    var latency:Float64) {}
    func valueOf() {
        return this.time
    }
}


var BenchmarkSuite_suites = ArrayList<BenchmarkSuite>()
var BenchmarkSuite_version = "9";
var BenchmarkSuite_scores = ArrayList<Float64>()
var BenchmarkSuite_config = BenchmarkSuite_Config()


class BenchmarkSuite {
    var results = ArrayList<BenchmarkResult>()
    var runner = runner_()
    BenchmarkSuite (var name:String, var reference:ArrayList<Float64>, var benchmarks:ArrayList<Benchmark>){
        BenchmarkSuite_suites.add(this);
    }

    func NotifyStep(result:BenchmarkResult) {
        this.results.add(result);
    }
    func NotifyResult(){
        var mean = BenchmarkSuite_GeometricMeanTime(this.results);
        var score = Float64(this.reference[0]) / mean;
        BenchmarkSuite_scores.add(score);
        // if (this.runner.NotifyResult) {
            var formatted = BenchmarkSuite_FormatScore(100.0 * score);
            this.runner.NotifyResult(this.name, formatted);
        // }
        if (this.reference.size == 2) {
            var meanLatency = BenchmarkSuite_GeometricMeanLatency(this.results);
            if (meanLatency != 0.0) {
                var scoreLatency = this.reference[1] / meanLatency;
                BenchmarkSuite_scores.add(scoreLatency);
                // if (this.runner.NotifyResult) {
                    var formattedLatency = BenchmarkSuite_FormatScore(100.0 * scoreLatency)
                    this.runner.NotifyResult(this.name + "Latency", formattedLatency);
                // }
            }
        }
    }
    /*
    func NotifySkipped(runner:runner_) {
        BenchmarkSuite_scores.add(1); // push default reference score.
        if (runner.NotifyResult) {
            runner.NotifyResult(this.name, "Skipped");
        }
    }
    */
    func NotifyError(error:String) {
        this.runner.NotifyError(this.name, error);
    }
    func RunSingleBenchmark(benchmark:Benchmark, data_input: ?data_):?data_ {
        var data = data_input
        var config = BenchmarkSuite_config
        var doWarmup = config.doWarmup??benchmark.doWarmup
        var doDeterministic = config.doDeterministic??benchmark.doDeterministic
        var data_is_none = match(data){
            case Some(T) => false
            case None => true
        }
        if (!doWarmup && data_is_none) {
            data = data_()
        }
        if (data_is_none){
            Measure(None, doDeterministic, benchmark)
            return data_()
        } else {
            Measure(data, doDeterministic, benchmark);
            var temp = data.getOrThrow()
            if (temp.runs < benchmark.minIterations) {return data}
            var usec = (Float64(temp.elapsed) * Float64(1000)) / Float64(temp.runs)
            var rms = benchmark.rmsResult()
            this.NotifyStep(BenchmarkResult(benchmark, usec, rms))
            return None<data_>
        }
    }
    func RunStep(runner:runner_): Unit{
        BenchmarkSuite_ResetRNG()
        this.results = ArrayList<BenchmarkResult>()
        this.runner = runner
        var obj = obj_(
            this.benchmarks.size,
            0,
            this,
            None
        )
        // Start out running the setup.
        RunNextSetup(obj)
        // return RunNextSetup(obj);
    }
}

class BenchmarkSuite_Config {
    var doWarmup : ?Bool = None
    var doDeterministic : ?Bool = None
}

func alert(s:String) {
    throw Exception("Alert called with argument: " + s)
}

func RunNextSetup(obj:obj_):Unit {
    if (obj.index < obj.length) {
        try {
            obj.suite.benchmarks[obj.index].Setup();
        } catch (e:Exception) {
            e.printStackTrace()
            obj.suite.NotifyError(e.message);
            return
        }

        RunNextBenchmark(obj);
        return
    }
    obj.suite.NotifyResult();
    return
}

func RunNextBenchmark(obj:obj_):Unit {
    try {
        obj.data = obj.suite.RunSingleBenchmark(obj.suite.benchmarks[obj.index], obj.data);
    } catch (e:Exception) {
        obj.suite.NotifyError(e.message);
        return;
    }
    // If data is null, we're done with this benchmark.
    match (obj.data){
        case Some(T) => RunNextBenchmark(obj)
        case None => RunNextTearDown(obj)
    }
}

func RunNextTearDown(obj:obj_) :Unit{
    try {
        obj.suite.benchmarks[obj.index].TearDown()
        obj.index+=1
    } catch (e:Exception) {
        obj.suite.NotifyError(e.message)
        return
    }
    RunNextSetup(obj)
    return
}



@OverflowWrapping
func foo(x:Int64){
    return UInt64(x)
}

func uright(x:Int64,y:Int64){
    return Int64(foo(x) >> y)
}

var seed : Int64 = 49734321

func BenchmarkSuite_ResetRNG() {
    seed = 49734321
}

@OverflowWrapping
func Math_random(){
    // Robert Jenkins' 32 bit integer hash function.
    // https://gist.github.com/badboy/6267743
    seed = ((seed + 0x7ed55d16) + (seed << 12)) & 0xffffffff;
    seed = ((seed ^ 0xc761c23c) ^ (uright(seed , 19))) & 0xffffffff;
    seed = ((seed + 0x165667b1) + (seed << 5)) & 0xffffffff;
    seed = ((seed + 0xd3a2646c) ^ (seed << 9)) & 0xffffffff;
    seed = ((seed + 0xfd7046c5) + (seed << 3)) & 0xffffffff;
    seed = ((seed ^ 0xb55a4f09) ^ (uright(seed , 16))) & 0xffffffff;
    return Float64((seed & 0xfffffff)) / Float64(0x10000000);
}


func BenchmarkSuite_RunSuites(runner:runner_) {
    var continuation = false;
    var suites = BenchmarkSuite_suites;
    var length = suites.size;
    var index = 0;
    while (continuation || index < length) {
        var suite = suites[index];
        index += 1
        // return undefined is js
        // continuation = suite.RunStep(runner);
        suite.RunStep(runner)
    }

    // show final result
    var score = BenchmarkSuite_GeometricMean(BenchmarkSuite_scores);
    var formatted = BenchmarkSuite_FormatScore(100.0 * score);
    runner.NotifyScore(formatted);
}

func BenchmarkSuite_GeometricMean(numbers:ArrayList<Float64>) {
    var log = 0.0;
    for (i in 0..numbers.size){
        log += math.log(numbers[i])
    }
    return math.pow(Float64.GetE(), log / Float64(numbers.size))
}

func BenchmarkSuite_GeometricMeanTime(measurements:ArrayList<BenchmarkResult>) {
    var log = 0.0;
    for (i in 0..measurements.size){
        log += math.log(Float64(measurements[i].time))
    }
    return math.pow(Float64.GetE(), log / Float64(measurements.size))
}

func BenchmarkSuite_GeometricMeanLatency(measurements:ArrayList<BenchmarkResult>) {
    var log = 0.0;
    var hasLatencyResult = false;
    for ( i in 0..measurements.size){
        if (measurements[i].latency != 0.0){
            log += math.log(measurements[i].latency);
            hasLatencyResult = true;
        }
    }
    if (hasLatencyResult) {
        return math.pow(Float64.GetE(), log / Float64(measurements.size));
    } else {
        return 0.0;
    }
}

// TODO
func BenchmarkSuite_FormatScore(value: Float64) :String{
    if (value > 100.0) {
        return value.format("10.0")
    } else {
        return value.format("10.3")
    }
}

func Measure(data: ?data_, doDeterministic: Bool, benchmark:Benchmark) {
    var elapsed = 0;
    var start = DateTime.now();
    var flag = 0
    // doDeterministic is always false
    var i = 0
    while (if (doDeterministic){
        i < benchmark.deterministicIterations
    } else {
        elapsed < 1000
    }){
        benchmark.run()
        elapsed = (DateTime.now() - start).toMilliseconds();
        i++
    }

    match (data){
        case Some(T) => T.runs += i; T.elapsed += elapsed;
        case None => ()
    }
}

var count = 0;

open class TreeRoot{}

open class Tree <: TreeRoot{
    var left : TreeRoot = Tree_None()
    var right : TreeRoot = Tree_None()
    var array : Array<Int64> = Array<Int64>()
    var string : String = ""
    init(left:TreeRoot,right:TreeRoot){
        this.left = left
        this.right = right
    }
    init(array:Array<Int64>,string:String){
        this.array = array
        this.string = string
    }
}

class Tree_None <: TreeRoot{}


class data_{
    data_ (var runs!:Int64 = 0, var elapsed!:Int64 = 0){}
}

class obj_{
    obj_(var length : Int64, var index : Int64, var suite : BenchmarkSuite, var data : ?data_){}
}

class runner_{
    runner_(var NotifyResult !: (String, String)->Unit = PrintResult,
    var NotifyError !: (String, String)->Unit = PrintError,
    var NotifyScore !: (String)->Unit = PrintScore){
    }
}


func GeneratePayloadTree(depth:Int64, tag:String):Tree {
    if (depth == 0) {
        return Tree(
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
            "String for key " + tag + " in leaf node"
        )
    } else {
        // return null;
        return Tree(
            GeneratePayloadTree(depth - 1, tag),
            GeneratePayloadTree(depth - 1, tag)
        )
    }
}

func GenerateKey() {
    return Math_random()
}






func InsertNewNode() {
    // Insert new node with a unique key.
    var key : Float64 = 0.0
    do {
        key = GenerateKey();
    } while (splayTree.find(key));
    var payload = GeneratePayloadTree(kSplayTreePayloadDepth, key.toString());
    splayTree.insert(key, payload);
    return key;
}

func SplaySetup() {
    // Check if the platform has the performance.now high resolution timer.
    // If not, throw exception and quit.
    // if (!performance.now) {
    //     throw Exception("PerformanceNowUnsupported");
    // }

    splayTree = SplayTree();
    splaySampleTimeStart = performance.now()
    for ( i in 0..kSplayTreeSize){
        InsertNewNode();
        if ((i + 1) % 20 == 19) {
            SplayUpdateStats(performance.now());
        }
    }
}

func SplayTearDown() {
    // Allow the garbage collector to reclaim the memory
    // used by the splay tree no matter how we exit the
    // tear down function.
    var keys = splayTree.exportKeys()
    splayTree = SplayTree_None();

    splaySamples = 0;
    splaySumOfSquaredPauses = 0;

    // Verify that the splay tree has the right size.
    var length = keys.size;
    if (length != kSplayTreeSize) {
        throw Exception("Splay tree has wrong size ${length} ${kSplayTreeSize}");
    }

    // Verify that the splay tree has sorted, unique keys.
    for (i in 0..length - 1){
        if (keys[i] >= keys[i + 1]) {
            throw Exception("Splay tree not sorted");
        }
    }
}

func SplayRun() {
    // Replace a few nodes in the splay tree.
    for (i in 0..kSplayTreeModifications){
        var key = InsertNewNode();
        var greatest = splayTree.findGreatestLessThan(key);
        match (greatest){
            case T:Value => splayTree.remove(T.key)
            case T:Empty => splayTree.remove(key)
            case _ => ()
        }
    }
    SplayUpdateStats(performance.now());
}

open class SplayTree{
    var root_ : Node = Empty()
    func isEmpty() {
        empty(root_)
    }

    func insert(key:Float64, value:Tree){

        if (this.isEmpty()) {
            this.root_ = Value(key, value);
            return;
        }
        // Splay on the key to move the last node on the search path for
        // the key to the root of the tree.
        this.splay_(key);
        var temp = (this.root_ as Value).getOrThrow()
        if (temp.key == key) {
            return;
        }
        var node = Value(key, value);
        if (key > temp.key) {

            node.left = temp
            node.right = temp.right
            temp.right = Empty()
        } else {
            node.right = temp
            node.left = temp.left
            temp.left = Empty()
        }
        this.root_ = node

    }

    func remove(key:Float64){
        if (this.isEmpty()) {
            throw Exception("isEmpty Key not found: " + key.toString());
        }

        this.splay_(key);
        if ((this.root_ as Value) .getOrThrow().key != key) {
            throw Exception("!= Key not found: " + key.toString());
        }

        var temp = (this.root_ as Value) .getOrThrow()
        match (temp.left){
            case x:Value => var right = temp.right
                            this.root_ = temp.left;
                            // Splay to make sure that the new root has an empty right child.
                            this.splay_(key);
                            // Insert the original right child as the right child of the new
                            // root.
                            var cur_root = (this.root_ as Value) .getOrThrow()
                            cur_root.right = right;
            case x:Empty => this.root_ = temp.right
            case _ => ()
        }
        // return removed;
    }

    func find(key:Float64) : Bool{
        if (this.isEmpty()) {
            return false
        }

        this.splay_(key);
        var temp = (this.root_ as Value) .getOrThrow() // will not throw.
        return match((temp.key) == key){
            case true => true
            case false => false
        }
    }
    func findMax(opt_startNode: Node ): Node {
        if (this.isEmpty()) {
            return Empty()
        }

        var current : Node
        if (!empty(opt_startNode)){
            current = opt_startNode
        } else {
            current = this.root_
        }

        while (!empty((current as Value).getOrThrow().right)){
            current = (current as Value).getOrThrow().right
        }
        return current;
    }

    func findGreatestLessThan(key:Float64):Node {
        if (this.isEmpty()) {
            return Empty()
        }


        // Splay on the key to move the node with the given key or the last
        // node on the search path to the top of the tree.
        this.splay_(key);
        // Now the result is either the root node or the greatest node in
        // the left subtree.

        var temp = (this.root_ as Value).getOrThrow() // will not throw.

        if (temp.key < key) {
            return this.root_;
        } else if (!empty(temp.left)) { // should go into here but not.
            return this.findMax(temp.left);
        } else {
            return Empty()
        }
    }
    func exportKeys() {
        var result = ArrayList<Float64>()
        match (this.root_){
            case T : Value => traverse_(T, result)
            case _ => ()
        }
        return result;
    }
    func splay_(key:Float64) {
        if (this.isEmpty()) {
            return
        }

        // Create a dummy node.  The use of the dummy node is a bit
        // counter-intuitive: The right child of the dummy node will hold
        // the L tree of the algorithm.  The left child of the dummy node
        // will hold the R tree of the algorithm.  Using a dummy node, left
        // and right will always be nodes and we avoid special cases.
        var dummy : Value = Value()
        var left = dummy
        var right = dummy
        var current : Value = (this.root_ as Value).getOrThrow() // will not be empty
        while (true) {
            if (key < current.key) {
                if (empty(current.left)){
                    break
                }
                if (key < (current.left as Value).getOrThrow().key) {
                    var tmp = (current.left as Value).getOrThrow()
                    current.left = tmp.right
                    tmp.right = current
                    current = tmp
                    if (empty(current.left)){
                        break
                    }
                }
                // Link right.
                right.left = current;
                right = current
                current = (current.left as Value).getOrThrow()
            } else if (key > current.key) {
                if (empty(current.right)){
                    break
                }
                if (key > (current.right as Value).getOrThrow().key) {
                    var tmp = (current.right as Value).getOrThrow()
                    current.right = tmp.left
                    tmp.left = current
                    current = tmp
                    if (empty(current.right)){
                        break
                    }
                }
                // Link left.
                left.right = current;
                left = current;
                current = (current.right as Value).getOrThrow()
            } else {
                break
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

class SplayTree_None <: SplayTree{}


open class Node{
    var key : Float64 = 0.0
    var value : TreeRoot = Tree_None()
    init(){}
    init(key:Float64, value:TreeRoot) {
        this.key = key;
        this.value = value;
    }
}

open class Empty <: Node{}

open class Value <: Node{
    var left : Node = Empty()
    var right : Node = Empty()
    init(){}
    init(key:Float64, value:TreeRoot) {
        this.key = key;
        this.value = value;
    }
    /*
    func traverse_(f:ArrayList<Float64>):Unit {
        var current : Node = this // can not be owned type.
        while (!empty(current)) {
            var current_ : Value = (current as Value).getOrThrow()
            var left : Node = current_.left
            if (!empty(left)){
                var left_ : Value = (left as Value).getOrThrow()
                left_.traverse_(f)
            }
            f.add(current.key)
            current = current_.right
        }
    }
    */
}

func traverse_(c:Node, f:ArrayList<Float64>):Unit {
    var current = c
    while (!empty(current)) {
        var current_ : Value = (current as Value).getOrThrow()
        var left : Node = current_.left
        if (!empty(left)){
            var left_ : Value = (left as Value).getOrThrow()
            traverse_(left_,f)
        }
        f.add(current.key)
        current = current_.right
    }
}

func empty(x: Node){
    if (x is Empty){
        return true
    }
    return false
}

var Splay = BenchmarkSuite("Splay", ArrayList<Float64>([81491.0, 2739514.0]), ArrayList<Benchmark>([
    Benchmark("Splay", true, false, 1400,
        run:SplayRun, Setup:SplaySetup, TearDown:SplayTearDown, rmsResult:SplayRMS)
]));


func SplayRMS() {
    return math.round(math.sqrt( Float64(splaySumOfSquaredPauses) / Float64(splaySamples)) * 10000.0);
}

func PrintResult(name:String, result:String) {
    println("JS_Benchmark testsplay " + name + ": " + result);
}


func PrintError(name:String, error:String) {
    PrintResult(name, error);
    success = false;
}


func PrintScore(score:String) {
    if (success) {
        println("JS_Benchmark testsplay " + "Score (version " + BenchmarkSuite_version + "): " + score);
    }
}

func SplayUpdateStats(t:DateTime) {
    var pause = t - splaySampleTimeStart;
    splaySampleTimeStart = t;
    splaySamples++;
    splaySumOfSquaredPauses += pause.toMilliseconds() * pause.toMilliseconds();
}


func splayScoreRun() {
    BenchmarkSuite_RunSuites(runner_())
}

main(){
    splayScoreRun()
    return
}
