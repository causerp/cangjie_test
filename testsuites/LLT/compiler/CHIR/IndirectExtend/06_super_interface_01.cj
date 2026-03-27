// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

import std.reflect.*

interface I1<T> {
    func foo() { println(TypeInfo.of<T>()) }
}
interface I2 {
    func moo(): Unit
    func goo() { println("i am goo") }
}
interface I<T> <: I1<T> & I2 {}

abstract class A<T> {}
extend<T> A<T> <: I<T> {
    public func moo() { println(TypeInfo.of<T>()) }
}
open class B<T> <: A<T> {}
open class C <: B<Int32> {}

main() {
    let i: I<Int32> = C()
    i.foo()
    i.moo()
}

/* SCAN
Int32
Int32
*/
