// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

import std.reflect.*

main() {
    // let x: I<Int32,SSS<QQQ<Int64>>> = B<Int64,SSS<Int32>>()
    // x.foo()
    // this should pass, but there is a sema bug
    B<Int64,SSS<Int32>>().foo()
}

extend<R,P,Q> A<SSS<R>,P,Q> <: I<R,SSS<P>> where Q<:I0 {}
class SSS<T> {}
extend<T> SSS<T> <: I0 where T <: ToString {}

open class A<A1,A2,A3> {}
class B<T2,V2> <: A<V2,QQQ<T2>,V2> {}
interface I<T1,T2> {
    func foo() { println(TypeInfo.of<T2>()) }
}
interface I0 {}
class QQQ<T> {}

/* SCAN
default.SSS<default.QQQ<Int64>>
*/
