/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// EXEC: %compiler %cmp_opt %overflow_wrapping %f -o %output
// (not Windows) RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// (Windows) RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 1>log.txt && bash -c "dos2unix log.txt" && bash -c "cat log.txt" | compare %f
/* SCAN-IN
test2
11.000000
12.000000
13.000000
25.000000
12.100000
13.000000
14.000000
15.000000
16.000000
17.000000
18.000000
19.000000
20.000000
21.000000
22.000000
23.000000
24.000000
25.000000
37.000000
24.100000
25.000000
test2
0.100000
1.000000
2.000000
3.000000
4.000000
5.000000
6.000000
7.000000
8.000000
9.000000
62.100000
10.000000
10.000000
10.000000
20.000000
10.100000
11.000000
12.000000
13.000000
14.000000
15.000000
16.000000
17.000000
18.000000
19.000000
20.000000
20.000000
20.000000
20.000000
30.000000
20.100000
21.000000
 */

func throwException(a: Int64, b: Int64, c: Int64, d: Int64, e: Int64, f: Int64, g: Int64, h: Int64): Int64 {
    if (a + b + c + d + e + f + g + h > 100) {
        throw Exception()
    } else {
        throwException(a + 1, b + 1, c + 1, d + 1, e + 1, f + 1, g + 1, h + 1)
        print(20.toString())
    }
    return 1
}

func test2(input: Float64): Float64 {
    var a0: Float64 = 0.1 * input
    var a1: Float64 = 1.0 * input
    var a2: Float64 = 2.0 * input
    var a3: Float64 = 3.0 * input
    var a4: Float64 = 4.0 * input
    var a5: Float64 = 5.0 * input
    var a6: Float64 = 6.0 * input
    var a7: Float64 = 7.0 * input
    var a8: Float64 = 8.0 * input
    var a9: Float64 = 9.0 * input
    var a10: Float64 = 10.0 * input
    try {
        a10 = a1 * 10.0
        throwException(10, 10, 100, 5, 10, 10, 10, 10)
    } catch (_) {
    }
    var a11: Float64 = a10 + input
    var a12: Float64 = a11 + input
    var a13: Float64 = a12 + input
    var a14: Float64 = a12 + a13
    var a15: Float64 = a12 + a0
    var a16: Float64 = a12 + a1
    var a17: Float64 = a12 + a2
    var a18: Float64 = a12 + a3
    var a19: Float64 = a12 + a4
    var a20: Float64 = a12 + a5
    var a21: Float64 = a12 + a6
    var a22: Float64 = a12 + a7
    var a23: Float64 = a12 + a8
    var a24: Float64 = a12 + a9
    var a25: Float64 = a12 + a10
    var a26: Float64 = a12 + a11
    var a27: Float64 = a12 + a12
    var a28: Float64 = a12 + a13
    var a29: Float64 = a12 + a14
    var a30: Float64 = a12 + a15
    var a31: Float64 = a12 + a16
    println("test2")
    println(a11.toString())
    println(a12.toString())
    println(a13.toString())
    println(a14.toString())
    println(a15.toString())
    println(a16.toString())
    println(a17.toString())
    println(a18.toString())
    println(a19.toString())
    println(a20.toString())
    println(a21.toString())
    println(a22.toString())
    println(a23.toString())
    println(a24.toString())
    println(a25.toString())
    println(a26.toString())
    println(a27.toString())
    println(a28.toString())
    println(a29.toString())
    println(a30.toString())
    println(a31.toString())
    println("test2")

    return a0 + a1 - a2 + a3 - a4 + a5 * a6 + a7 + a8 + a9 + a10
}

func test1(input: Float64) {
    var a0: Float64 = 0.1 + input
    var a1: Float64 = 1.0 + input
    var a2: Float64 = 2.0 + input
    var a3: Float64 = 3.0 + input
    var a4: Float64 = 4.0 + input
    var a5: Float64 = 5.0 + input
    var a6: Float64 = 6.0 + input
    var a7: Float64 = 7.0 + input
    var a8: Float64 = 8.0 + input
    var a9: Float64 = 9.0 + input
    var a10: Float64 = 10.0 + input
    var a11: Float64 = a10 + input
    var a12: Float64 = a11 + input
    var a13: Float64 = a12 + input
    var a14: Float64 = a12 + a13
    var a15: Float64 = a12 + a0
    var a16: Float64 = a12 + a1
    var a17: Float64 = a12 + a2
    var a18: Float64 = a12 + a3
    var a19: Float64 = a12 + a4
    var a20: Float64 = a12 + a5
    var a21: Float64 = a12 + a6
    var a22: Float64 = a12 + a7
    var a23: Float64 = a12 + a8
    var a24: Float64 = a12 + a9
    var a25: Float64 = a12 + a10
    var a26: Float64 = a12 + a11
    var a27: Float64 = a12 + a12
    var a28: Float64 = a12 + a13
    var a29: Float64 = a12 + a14
    var a30: Float64 = a12 + a15
    var a31: Float64 = a12 + a16
    try {
        a10 = test2(a1)
        throwException(10, 10, 100, 5, 10, 10, 10, 10)
    } catch (_) {
    }
    println(a0.toString())
    println(a1.toString())
    println(a2.toString())
    println(a3.toString())
    println(a4.toString())
    println(a5.toString())
    println(a6.toString())
    println(a7.toString())
    println(a8.toString())
    println(a9.toString())
    println(a10.toString())
    println(a11.toString())
    println(a12.toString())
    println(a13.toString())
    println(a14.toString())
    println(a15.toString())
    println(a16.toString())
    println(a17.toString())
    println(a18.toString())
    println(a19.toString())
    println(a20.toString())
    println(a21.toString())
    println(a22.toString())
    println(a23.toString())
    println(a24.toString())
    println(a25.toString())
    println(a26.toString())
    println(a27.toString())
    println(a28.toString())
    println(a29.toString())
    println(a30.toString())
    println(a31.toString())
}

main(): Int64 {
    test1(0.0)
    return 0
}
