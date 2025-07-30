// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f
// UpperBound: Tuple Type

func foo<T>() where T <: (Int32, Int32) {
    return 0
}

open class Base {}

class Child <: Base {}

class C {}

func bar<T>() where T <: (Int32, Child) {
    return 0
}

main(): Int64 {
    foo<(Int32, Int64)>()
    bar<(Int32, Base)>()
    bar<(Int32, Child)>() // OK
    bar<(Int32, C)>()
    bar<(Int64, Child)>()
    bar<(C, Child)>()
}

/* SCAN
error: the upper bound 'Tuple<Int32, Int32>' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test5_2n.cj:10:10:
   | 
10 | func foo<T>() where T <: (Int32, Int32) {
   |          ^ 
   | 

error: the upper bound 'Tuple<Int32, Class-Child>' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test5_2n.cj:20:10:
   | 
20 | func bar<T>() where T <: (Int32, Child) {
   |          ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test5_2n.cj:25:9:
   | 
25 |     foo<(Int32, Int64)>()
   |         ^ 
   | 
note: 'Tuple<Int32, Int64>' is not a subtype of 'Tuple<Int32, Int32>'
  ==> constraint_check_test5_2n.cj:10:21:
   | 
10 | func foo<T>() where T <: (Int32, Int32) {
   |                     ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test5_2n.cj:26:9:
   | 
26 |     bar<(Int32, Base)>()
   |         ^ 
   | 
note: 'Tuple<Int32, Class-Base>' is not a subtype of 'Tuple<Int32, Class-Child>'
  ==> constraint_check_test5_2n.cj:20:21:
   | 
20 | func bar<T>() where T <: (Int32, Child) {
   |                     ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test5_2n.cj:28:9:
   | 
28 |     bar<(Int32, C)>()
   |         ^ 
   | 
note: 'Tuple<Int32, Class-C>' is not a subtype of 'Tuple<Int32, Class-Child>'
  ==> constraint_check_test5_2n.cj:20:21:
   | 
20 | func bar<T>() where T <: (Int32, Child) {
   |                     ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test5_2n.cj:29:9:
   | 
29 |     bar<(Int64, Child)>()
   |         ^ 
   | 
note: 'Tuple<Int64, Class-Child>' is not a subtype of 'Tuple<Int32, Class-Child>'
  ==> constraint_check_test5_2n.cj:20:21:
   | 
20 | func bar<T>() where T <: (Int32, Child) {
   |                     ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test5_2n.cj:30:9:
   | 
30 |     bar<(C, Child)>()
   |         ^ 
   | 
note: 'Tuple<Class-C, Class-Child>' is not a subtype of 'Tuple<Int32, Class-Child>'
  ==> constraint_check_test5_2n.cj:20:21:
   | 
20 | func bar<T>() where T <: (Int32, Child) {
   |                     ^ 
   | 

7 errors generated, 7 errors printed.
*/
