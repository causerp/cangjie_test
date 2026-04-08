// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

import std.reflect.*

interface I<T> {
    func foo() { println(TypeInfo.of<T>()) }
}

abstract class A<T> {}
extend<T> A<T> <: I<T> {}
open class B <: A<Int64> {}

main() {
    let i: I<Int64> = B()
    i.foo()
}

/* SCAN
Int64
*/
