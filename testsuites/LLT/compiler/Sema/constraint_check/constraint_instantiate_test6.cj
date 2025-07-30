// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

class X {}

interface Y {}

interface R<T> where T <: X & Y {}

func test(a: R<X>, b: R<Y>) {}

main(): Int64 {
    return 0
}

/* SCAN
error: generics type arguments do not match the constraint of 'Interface-R<Generics-T>'
  ==> constraint_instantiate_test6.cj:15:16:
   | 
15 | func test(a: R<X>, b: R<Y>) {}
   |                ^ 
   | 
note: 'Class-X' is not a subtype of 'Interface-Y'
  ==> constraint_instantiate_test6.cj:13:22:
   | 
13 | interface R<T> where T <: X & Y {}
   |                      ^ 
   | 

error: generics type arguments do not match the constraint of 'Interface-R<Generics-T>'
  ==> constraint_instantiate_test6.cj:15:25:
   | 
15 | func test(a: R<X>, b: R<Y>) {}
   |                         ^ 
   | 
note: 'Interface-Y' is not a subtype of 'Class-X'
  ==> constraint_instantiate_test6.cj:13:22:
   | 
13 | interface R<T> where T <: X & Y {}
   |                      ^ 
   | 

2 errors generated, 2 errors printed.
*/
