// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f 2>&1 | compare %f

class C1 {}

class C2 {}

class A<X> {
    public func foo<Y>(x: X) where Y <: X {
        x
    }
    public func foo<Y>() {}
    public static func goo<Y>(x: X) where Y <: X {
        x
    }
}

open class Base {}

open class Sub <: Base {}

class SSub <: Sub {}

class Sub2 <: Base {}

class B<X> where X <: Sub {
    public func f<Y>(x: Y): X where Y <: X {
        x
    }
}

main(): Int64 {
    let a = A<C1>()
    a.foo<C2>(C1())
    let b = a.foo<C2>
    let c = A<C1>.goo<C2>

    B<Sub>().f<Sub2>(Sub2())
    let x: Sub = B<Sub>().f<SSub>(SSub())
    0
}

/* SCAN
error: the upper bound 'Generics-X' of generic parameter 'Generics-Y' must be class or interface
  ==> generic_constraint5.cj:14:21:
   | 
14 |     public func foo<Y>(x: X) where Y <: X {
   |                     ^ 
   | 

error: the upper bound 'Generics-X' of generic parameter 'Generics-Y' must be class or interface
  ==> generic_constraint5.cj:18:28:
   | 
18 |     public static func goo<Y>(x: X) where Y <: X {
   |                            ^ 
   | 

error: the upper bound 'Generics-X' of generic parameter 'Generics-Y' must be class or interface
  ==> generic_constraint5.cj:32:19:
   | 
32 |     public func f<Y>(x: Y): X where Y <: X {
   |                   ^ 
   | 

error: generics type arguments do not match the constraint of '(Generics-X) -> Generics-X'
  ==> generic_constraint5.cj:39:11:
   | 
39 |     a.foo<C2>(C1())
   |           ^ 
   | 
note: 'Class-C2' is not a subtype of 'Class-C1'
  ==> generic_constraint5.cj:14:36:
   | 
14 |     public func foo<Y>(x: X) where Y <: X {
   |                                    ^ 
   | 

error: ambiguous use of 'foo'
  ==> generic_constraint5.cj:40:13:
   | 
40 |     let b = a.foo<C2>
   |             ^^^^^^^^ 
   | 
note: found candidate
  ==> generic_constraint5.cj:14:17:
   | 
14 |     public func foo<Y>(x: X) where Y <: X {
   |                 ^^^ 
   | 
note: found candidate
  ==> generic_constraint5.cj:17:17:
   | 
17 |     public func foo<Y>() {}
   |                 ^^^ 
   | 

error: generics type arguments do not match the constraint of '(Generics-X) -> Generics-X'
  ==> generic_constraint5.cj:41:23:
   | 
41 |     let c = A<C1>.goo<C2>
   |                       ^ 
   | 
note: 'Class-C2' is not a subtype of 'Class-C1'
  ==> generic_constraint5.cj:18:43:
   | 
18 |     public static func goo<Y>(x: X) where Y <: X {
   |                                           ^ 
   | 

error: generics type arguments do not match the constraint of '(Generics-Y) -> Generics-X'
  ==> generic_constraint5.cj:43:16:
   | 
43 |     B<Sub>().f<Sub2>(Sub2())
   |                ^ 
   | 
note: 'Class-Sub2' is not a subtype of 'Class-Sub'
  ==> generic_constraint5.cj:32:37:
   | 
32 |     public func f<Y>(x: Y): X where Y <: X {
   |                                     ^ 
   | 

7 errors generated, 7 errors printed.
*/
