// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

import std.reflect.*

main() {
    var i: A<SSS<Int>,SSS<Int>> = B<SSS<Int>,SSS<Int>>()
    i.foo()
}

interface I<T1,V1> {
    func foo() { println(TypeInfo.of<V1>()) }
}
struct SSS<M> {}
open class A<T,V> {}
extend<R> A<SSS<R>,SSS<R>> <: I<R,SSS<R>> {}
open class B<T2,V2> <: A<T2,V2> {}

/* SCAN
default.SSS<Int64>
*/
