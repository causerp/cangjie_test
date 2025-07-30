// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %n.%suffix 2>&1 | compare %f

interface I {}

extend Int <: I {}

extend<T> Option<T> <: I where T <: I {}

class Cl<U1, U2> where U1 <: I, U2 <: I {}

type A<T1, T2, T3> = Cl<Option<T1>, Option<T1>> // ok

func f<X>(a: A<X, X, X>) { // error
    A<X, X, X>() // error
    A<Int, Int, Int>() // ok
}

main() {}

/* SCAN
warning: type arg(s) Generics-T2,Generics-T3 are not used
  ==> typealias29.cj:17:1:
   | 
17 | type A<T1, T2, T3> = Cl<Option<T1>, Option<T1>> // ok
   | ^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`

error: generics type arguments do not match the constraint of 'Class-Cl<Generics-U1, Generics-U2>'
  ==> typealias29.cj:19:14:
   | 
19 | func f<X>(a: A<X, X, X>) { // error
   |              ^ 
   | 
note: 'Enum-Option<Generics-X>' is not a subtype of 'Interface-I'
  ==> typealias29.cj:15:24:
   | 
15 | class Cl<U1, U2> where U1 <: I, U2 <: I {}
   |                        ^ 
   | 

error: generics type arguments do not match the constraint of 'Class-Cl<Generics-U1, Generics-U2>'
  ==> typealias29.cj:20:5:
   | 
20 |     A<X, X, X>() // error
   |     ^ 
   | 
note: 'Enum-Option<Generics-X>' is not a subtype of 'Interface-I'
  ==> typealias29.cj:15:24:
   | 
15 | class Cl<U1, U2> where U1 <: I, U2 <: I {}
   |                        ^ 
   | 

2 errors generated, 2 errors printed.
1 warning generated, 1 warning printed.
*/
