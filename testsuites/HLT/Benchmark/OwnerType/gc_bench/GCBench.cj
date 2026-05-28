/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output

import std.time.*
import std.runtime.*

open class Node_Root{}

class Node <: Node_Root{
	var left : Node_Root = Empty()
	var right: Node_Root = Empty()
	var i : Int32 = 0
	var j : Int32 = 0
	init(l:Node_Root, r:Node_Root) { left = l; right = r; }
	init() {}
}

class Empty <: Node_Root{}

let kStretchTreeDepth  : Int32  = 18 // about 16Mb
let kLongLivedTreeDepth  : Int32  = 16 // about 4Mb
let kArraySize  : Int64  = 500000 // about 4Mb
let kMinTreeDepth  : Int32  = 4
let kMaxTreeDepth  : Int32  = 16

func TreeSize(i: Int32) {
	return ((1 << (i + 1)) - 1);
}

func NumIters(i: Int32) {
    return 2 * TreeSize(kStretchTreeDepth) / TreeSize(i);
}

func Populate(iDepth: Int32, thisNode: Node_Root): Unit {
    if (iDepth<=0) {
        return;
    } else {
        var temp = (thisNode as Node).getOrThrow()
        temp.left  = Node();
        temp.right = Node();
        Populate (iDepth - 1, temp.left);
        Populate (iDepth - 1, temp.right);
    }
    ()
}

func MakeTree(iDepth: Int32): Node_Root {
    if (iDepth<=0) {
        return Node();
    } else {
        return Node(MakeTree(iDepth-1),
                MakeTree(iDepth-1));
    }
}

@When[backend == "cjnative"]
func PrintDiagnostics(){
    var lTotalMemory = MemoryInfo.maxHeapSize
    var lFreeMemory = lTotalMemory - MemoryInfo.allocatedHeapSize
    println(" Total memory available= ${lTotalMemory} bytes");
    println("  Free memory= ${lFreeMemory} bytes");
}

@When[backend != "cjnative"]
func PrintDiagnostics(){}

func TimeConstruction(depth: Int32) {
    var root : Node_Root
    var tStart : Int64
    var tFinish : Int64
    var iNumIters = NumIters(depth)
    var tempTree : Node_Root

    println("Creating ${iNumIters} trees of depth ${depth}")
    tStart = DateTime.now().toUnixTimeStamp().toMilliseconds()
    for (i in 1..iNumIters+1){
        tempTree = Node();
        Populate(depth, tempTree);
        tempTree = Empty();
    }
    tFinish = DateTime.now().toUnixTimeStamp().toMilliseconds()
    println("\tTop down construction took ${tFinish - tStart} msecs")
    tStart = DateTime.now().toUnixTimeStamp().toMilliseconds();
    for (i in 1..iNumIters+1){
            tempTree = MakeTree(depth)
            tempTree = Empty()
    }
    tFinish = DateTime.now().toUnixTimeStamp().toMilliseconds();
    println("\tBottom up construction took ${tFinish - tStart} msecs");
}

main(){
		var root : Node_Root
		var longLivedTree : Node_Root
		var tempTree : Node_Root
		var tStart: Int64
		var tFinish : Int64
		var tElapsed : Int64


		println("Garbage Collector Test")
		println(" Stretching memory with a binary tree of depth ${kStretchTreeDepth}")
		PrintDiagnostics();
		tStart = DateTime.now().toUnixTimeStamp().toMilliseconds();

		// Stretch the memory space quickly
		tempTree = MakeTree(kStretchTreeDepth);
		tempTree = Empty();

		// Create a long lived object
		println("Creating a long-lived binary tree of depth ${kLongLivedTreeDepth}")
		longLivedTree = Node();
		Populate(kLongLivedTreeDepth, longLivedTree);

		// Create long-lived array, filling half of it
		println(" Creating a long-lived array of ${kArraySize} doubles");
		var array = Array<Float64>(kArraySize, repeat:0.0)
		for (i in 1..kArraySize/2 + 1){
			array[i] = 1.0/Float64(i);
		}
		PrintDiagnostics();
        for (d in kMinTreeDepth..=kMaxTreeDepth:2){
			TimeConstruction(d)
		}

		if (longLivedTree is Empty || array[1000] != 1.0/Float64(1000)){
			println("Failed");
					// fake reference to LongLivedTree
					// and array
					// to keep them from being optimized away
		}

		tFinish = DateTime.now().toUnixTimeStamp().toMilliseconds();
		tElapsed = tFinish-tStart;
		PrintDiagnostics();
		println("Completed in ${tElapsed} ms.");
}