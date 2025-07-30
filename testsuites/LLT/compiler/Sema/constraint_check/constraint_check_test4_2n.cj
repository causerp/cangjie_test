// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f
// UpperBound: Primitive Type

func foo<T>() where T <: Int32 {
    return 0
}

main(): Int64 {
    foo<Bool>()
}

/* SCAN
error: the upper bound 'Int32' of generic parameter 'Generics-T' must be class or interface
  ==> constraint_check_test4_2n.cj:10:10:
   | 
10 | func foo<T>() where T <: Int32 {
   |          ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Int64'
  ==> constraint_check_test4_2n.cj:15:9:
   | 
15 |     foo<Bool>()
   |         ^ 
   | 
note: 'Bool' is not a subtype of 'Int32'
  ==> constraint_check_test4_2n.cj:10:21:
   | 
10 | func foo<T>() where T <: Int32 {
   |                     ^ 
   | 

2 errors generated, 2 errors printed.
*/
