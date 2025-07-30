// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

class X {}

interface Y {}

enum R<T> where T <: X & Y {
    e
}

var a = R<X>.e
var b = R<Y>.e

main(): Int64 {
    return 0
}

/* SCAN
error: generics type arguments do not match the constraint of 'Enum-R<Generics-T>'
  ==> constraint_instantiate_test7.cj:17:11:
   | 
17 | var a = R<X>.e
   |           ^ 
   | 
note: 'Class-X' is not a subtype of 'Interface-Y'
  ==> constraint_instantiate_test7.cj:13:17:
   | 
13 | enum R<T> where T <: X & Y {
   |                 ^ 
   | 

error: generics type arguments do not match the constraint of 'Enum-R<Generics-T>'
  ==> constraint_instantiate_test7.cj:18:11:
   | 
18 | var b = R<Y>.e
   |           ^ 
   | 
note: 'Interface-Y' is not a subtype of 'Class-X'
  ==> constraint_instantiate_test7.cj:13:17:
   | 
13 | enum R<T> where T <: X & Y {
   |                 ^ 
   | 

2 errors generated, 2 errors printed.
*/
