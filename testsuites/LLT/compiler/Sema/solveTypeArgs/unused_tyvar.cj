// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

interface M0_<T> {}

interface M1_<T> {}

interface M6_<T> {}

interface M7_<T> {}

func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
    0
}

interface I0_ <: M0_<I1_> {}

interface I1_ <: M6_<I3_> {}

interface I3_ <: M1_<I3_> {}

open class G1_ <: I1_ {}

main() {
    test({i: M0_<I1_> => G1_()})
}

/* SCAN
error: undeclared type name 'T3_'
  ==> unused_tyvar.cj:17:74:
   | 
17 | func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
   |                                                                          ^ 
   | 

error: undeclared type name 'T3_'
  ==> unused_tyvar.cj:17:80:
   | 
17 | func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
   |                                                                                ^ 
   | 

error: undeclared type name 'T3_'
  ==> unused_tyvar.cj:17:91:
   | 
17 | func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
   |                                                                                           ^ 
   | 

error: unable to infer generic argument of this function
  ==> unused_tyvar.cj:30:5:
   | 
30 |     test({i: M0_<I1_> => G1_()})
   |     ^^^^ 
   | 
note: following constraints for type variable 'Generics-T0_' cannot be solved:
      'Generics-T0_ <: Interface-M0_<Class-G1_>'
      'Generics-T0_ <: Interface-M0_<Interface-I1_>'
  ==> unused_tyvar.cj:17:11:
   | 
17 | func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
   |           ^^^ 
   | 
note: constraint 'Generics-T0_ <: Interface-M0_<Class-G1_>' may come from:
  ==> unused_tyvar.cj:17:46:
   | 
17 | func test<T0_, T1_>(i: ((T0_) -> T1_)) where T0_ <: M0_<T1_>, T1_ <: M6_<T3_>, T3_ <: M1_<T3_> {
   |                                              ^^^^^^^^^^^^^^^ 
   | 
note: constraint 'Generics-T0_ <: Interface-M0_<Interface-I1_>' may come from:
  ==> unused_tyvar.cj:30:10:
   | 
30 |     test({i: M0_<I1_> => G1_()})
   |          ^^^^^^^^^^^^^^^^^^^^^^ of type '(Interface-M0_<Interface-I1_>) -> Class-G1_', should match parameter type '(Generics-T0_) -> Generics-T1_'
   | 

4 errors generated, 4 errors printed.
*/
