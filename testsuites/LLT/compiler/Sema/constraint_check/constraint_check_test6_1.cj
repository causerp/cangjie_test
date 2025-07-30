// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

// UpperBound: Array Type

func foo<T>() where T <: Array<Int32> {
    return 0
}

open class Base {}

class Child <: Base {}

func bar<T>() where T <: Array<(Int32, Base)> {
    return 0
}

func jay<T>() where T <: (Int32, Array<Base>) {
    return 0
}

main(): Int64 {
    foo<Array<Int32>>()
    bar<Array<(Int32, Base)>>()
    bar<Array<(Int32, Child)>>()
    jay<(Int32, Array<Base>)>()
    jay<(Int32, Array<Child>)>()
}

/* SCAN
error: the upper bound 'Struct-Array<Int32>' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test6_1.cj:11:10:
   | 
11 | func foo<T>() where T <: Array<Int32> {
   |          ^ 
   | 

error: the upper bound 'Struct-Array<Tuple<Int32, Class-Base>>' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test6_1.cj:19:10:
   | 
19 | func bar<T>() where T <: Array<(Int32, Base)> {
   |          ^ 
   | 

error: the upper bound 'Tuple<Int32, Struct-Array<Class-Base>>' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test6_1.cj:23:10:
   | 
23 | func jay<T>() where T <: (Int32, Array<Base>) {
   |          ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test6_1.cj:30:9:
   | 
30 |     bar<Array<(Int32, Child)>>()
   |         ^ 
   | 
note: 'Struct-Array<Tuple<Int32, Class-Child>>' is not a subtype of 'Struct-Array<Tuple<Int32, Class-Base>>'
  ==> constraint_check_test6_1.cj:19:21:
   | 
19 | func bar<T>() where T <: Array<(Int32, Base)> {
   |                     ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test6_1.cj:32:9:
   | 
32 |     jay<(Int32, Array<Child>)>()
   |         ^ 
   | 
note: 'Tuple<Int32, Struct-Array<Class-Child>>' is not a subtype of 'Tuple<Int32, Struct-Array<Class-Base>>'
  ==> constraint_check_test6_1.cj:23:21:
   | 
23 | func jay<T>() where T <: (Int32, Array<Base>) {
   |                     ^ 
   | 

5 errors generated, 5 errors printed.
*/
