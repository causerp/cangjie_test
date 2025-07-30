// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: testMultiFile01.cj testMultiFile02.cj
// (DEBUG_OPTION)EXEC: %compiler %debugCHIROpt testMultiFile01.cj testMultiFile02.cj -o %output 2>&1 | compare %f
// (CJNATIVE and DEBUG_OPTION) EXEC: %run %run_opt %output %run_args
// ASSERT: scan debug: consteval at testMultiFile02.cj:9:1 - testMultiFile02.cj:9:43 replaced initializer function `gv$_myConstInAnotherFile` with initializer constant(s).
// ASSERT: scan debug: consteval at testMultiFile01.cj:23:1 - testMultiFile01.cj:23:23 replaced initializer function `gv$_myConst0` with initializer constant(s).
// ASSERT: scan debug: consteval at testMultiFile01.cj:25:1 - testMultiFile01.cj:25:31 replaced initializer function `gv$_myConst1` with initializer constant(s).
// ASSERT: scan debug: consteval at testMultiFile01.cj:27:1 - testMultiFile01.cj:27:56 replaced initializer function `gv$_myConst2` with initializer constant(s).
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

package TestMultiFile

internal import std.posix.*

const func foo(x: Int64): Int64 {x + 1}

const myConst0 = 0 + 1

const myConst1 = O_RDONLY + 42

public const myConst2 = foo(101) + myConstInAnotherFile

main () {
    println("success!")
}