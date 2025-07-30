// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

interface I {}

class A<T> where T <: I {}

extend<T> A<T> where T <: String {}

main() {}

/* SCAN
error: the upper bound 'Struct-String' of generic parameter 'Generics-T' must be class or interface
  ==> generic_upper_constraint_inheritance_11.cj:13:8:
   | 
13 | extend<T> A<T> where T <: String {}
   |        ^ 
   | 

1 error generated, 1 error printed.
*/
