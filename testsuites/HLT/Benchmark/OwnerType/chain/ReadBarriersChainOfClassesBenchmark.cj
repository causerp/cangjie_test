/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output

// Test the overhead of read barriers while iterating through a big chain of pre-allocated composite class instances
// (e.g. class H1 -> class H2 -> … -> class H32) and returns a field property held by the innermost of them.

package GC

import std.process.*
import std.time.*
import std.collection.*
import std.runtime.*

let KB = 1024
let MB = 1024 * 1024
var heapsize = { => var temp = Process.current.getEnv("cjHeapSize")??"256"; if (temp == "256") {return 256} else {return 0}}()
var heapsize_4kb = Int64(Float64(heapsize) * 0.6) * 1024 / 4 - 1
var heapsize_4mb = Int64(Float64(heapsize) * 0.6) / 4 - 1
var debug = { => var temp = Process.current.getEnv("GCDEBUG")??"false"; if (temp == "false") {return false} else {return true}}()

@When[backend == "cjnative"]
func getMemoryInfo(){
    var x = MemoryInfo.heapPhysicalMemory
    println("GetPhysicalMemorySize ${x}KB , ${Float64(x)/Float64(256*1024) * 100.0} %")
}

@When[backend != "cjnative"]
func getMemoryInfo(){
    // unsupported.
}

func printCostTime(n: Int64, cost: Int64, name: String){
	var a = Float64(n) / Float64(cost) * 1000000000.0
	var b = Float64(cost) / 1000000000.0
	print("result: ${name}, ${a} ops/s , ${b} s.\n")
}


class H1{
    var h2 : H2
    public H1(h2:H2){this.h2 = h2}
}

class H2{
    var h3 : H3
    public H2(h3:H3){this.h3 = h3}
}

class H3{
    var h4 : H4
    public H3(h4:H4){this.h4 = h4}
}

class H4{
    var h5 : H5
    public H4(h5:H5){this.h5 = h5}
}

class H5{
    var h6 : H6
    public H5(h6:H6){this.h6 = h6}
}

class H6{
    var h7 : H7
    public H6(h7:H7){this.h7 = h7}
}

class H7{
    var h8 : H8
    public H7(h8:H8){this.h8 = h8}
}

class H8{
    var h9 : H9
    public H8(h9:H9){this.h9 = h9}
}

class H9{
    var h10 : H10
    public H9(h10:H10){this.h10 = h10}
}

class H10{
    var h11 : H11
    public H10(h11:H11){this.h11 = h11}
}
class H11{
    var h12 : H12
    public H11(h12:H12){this.h12 = h12}
}

class H12{
    var h13 : H13
    public H12(h13:H13){this.h13 = h13}
}

class H13{
    var h14 : H14
    public H13(h14:H14){this.h14 = h14}
}

class H14{
    var h15 : H15
    public H14(h15:H15){this.h15 = h15}
}

class H15{
    var h16 : H16
    public H15(h16:H16){this.h16 = h16}
}

class H16{
    var h17 : H17
    public H16(h17:H17){this.h17 = h17}
}

class H17{
    var h18 : H18
    public H17(h18:H18){this.h18 = h18}
}

class H18{
    var h19 : H19
    public H18(h19:H19){this.h19 = h19}
}

class H19{
    var h20 : H20
    public H19(h20:H20){this.h20 = h20}
}

class H20{
    var h21 : H21
    public H20(h21:H21){this.h21 = h21}
}
class H21{
    var h22 : H22
    public H21(h22:H22){this.h22 = h22}
}

class H22{
    var h23 : H23
    public H22(h23:H23){this.h23 = h23}
}

class H23{
    var h24 : H24
    public H23(h24:H24){this.h24 = h24}
}

class H24{
    var h25 : H25
    public H24(h25:H25){this.h25 = h25}
}

class H25{
    var h26 : H26
    public H25(h26:H26){this.h26 = h26}
}

class H26{
    var h27 : H27
    public H26(h27:H27){this.h27 = h27}
}

class H27{
    var h28 : H28
    public H27(h28:H28){this.h28 = h28}
}

class H28{
    var h29 : H29
    public H28(h29:H29){this.h29 = h29}
}

class H29{
    var h30 : H30
    public H29(h30:H30){this.h30 = h30}
}


class H30{
    var h31 : H31
    public H30(h31:H31){this.h31 = h31}
}
class H31{
    var h32 : H32
    public H31(h32:H32){this.h32 = h32}
}

class H32{
    var aValue : Int64
    public H32(aValue:Int64){this.aValue = aValue}
}



func test() {
    var h1 = H1(H2(H3(H4(H5(H6(H7(H8(H9(H10(H11(H12(H13(H14(H15(H16(H17(H18(H19(H20(H21(H22(H23(H24(H25(H26(H27(H28(H29(H30(H31(H32(1))))))))))))))))))))))))))))))))
    return  h1.h2.h3.h4.h5.h6.h7.h8
         .h9.h10.h11.h12.h13.h14.h15.h16
         .h17.h18.h19.h20.h21.h22.h23.h24
         .h25.h26.h27.h28.h29.h30.h31.h32.aValue;
}

main(){
    let name = "ReadBarriersChainOfClassesBenchmark"
    var now = DateTime.now()
    var n = 1000000
    for (_ in 0..n){
        test()
    }
    var end = DateTime.now()
    var cost = (end-now).toNanoseconds()
    printCostTime(n, cost, name)
}
