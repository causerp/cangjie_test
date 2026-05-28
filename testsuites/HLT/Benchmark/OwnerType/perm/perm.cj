/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output

import std.collection.*
import std.time.*

class Integer{
    Integer(var x!: Int64 = 0){}
}

func permute(nums:ArrayList<Integer>){
    var res : ArrayList<ArrayList<Integer>> = ArrayList<ArrayList<Integer>>()
    func backtrack(nums:ArrayList<Integer>, tmp: ArrayList<Integer>): Unit{
        if (nums.size == 0){
            res.add(tmp)
            return
        }
        for (i in 0..nums.size){
            var next_nums = nums.clone()
            var next_temp = tmp.clone()
            next_nums.remove(at: i)
            next_temp.add(nums[i])
            backtrack( next_nums , next_temp)
        }
    }
    backtrack(nums, ArrayList<Integer>())
    return res
}

func MPermNKL(M:Int64,N:Int64,K:Int64,L:Int64){
    var nums = ArrayList<Integer>(N,{x:Int64=>Integer(x:x+1)})
    var result : ArrayList<ArrayList<Integer>> = ArrayList<ArrayList<Integer>>()
    for (i in 0..M){
        result = permute(nums)
        println("${result.size}")
        var delete_nums = result.size * L / K
        for (j in 0..delete_nums){
            result[j] = ArrayList<Integer>()  // garbage collection
        }
    }
}

func TenPermNineTwoOne(){
    MPermNKL(10,9,2,1)
}

func printCostTime(n: Int64, cost: Int64, name: String){
	var a = Float64(n) / Float64(cost) * 1000000000.0
	var b = Float64(cost) / 1000000000.0
	print("result: ${name}, ${a} ops/s , ${b} s.\n")
}

main(){
    var now = DateTime.now()
    var n = 1000000
    TenPermNineTwoOne()
    var end = DateTime.now()
    var cost = (end-now).toNanoseconds()
    printCostTime(n, cost, "10Perm921")
}