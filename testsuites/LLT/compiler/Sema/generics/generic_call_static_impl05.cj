// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %noColor %f -o %n.%suffix 2>&1 | compare %f

interface I1 {
    mut static prop a: Int64
    static func f(): Unit
}

interface I2 <: I1 {}

abstract class I3 {}

extend I3 <: I2 {}

func f<T>(): Unit where T <: I2 {
    T.a = 1
    T.f()
}

main() {
    f<I3>()
}

/* SCAN
error: can not instantiate 'Generics-T' by interface or abstract class 'Class-I3' for it has unimplemented static member
  ==> generic_call_static_impl05.cj:26:7:
   | 
26 |     f<I3>()
   |       ^ 
   | 

error: implementation of property 'a' is needed in 'extend I3'
  ==> generic_call_static_impl05.cj:18:1:
   | 
18 | extend I3 <: I2 {}
   | ^ 
   | 
note: unimplemented interface property
  ==> generic_call_static_impl05.cj:10:5:
   | 
10 |     mut static prop a: Int64
   |     ^ 
   | 

2 errors generated, 2 errors printed.
*/
