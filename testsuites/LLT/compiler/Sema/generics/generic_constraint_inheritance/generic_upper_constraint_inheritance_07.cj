// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

struct S {
    func foo(): Int {
        1
    }
}

interface I2 {
    func foo(): String
}

func bar<T>(x: T) where T <: S & I2 {
}

class A<T> where T <: S & I2 {}

main() {
}

/* SCAN
error: the upper bound 'Struct-S' of generic parameter 'Generics-T' must be class or interface
  ==> generic_upper_constraint_inheritance_07.cj:19:10:
   | 
19 | func bar<T>(x: T) where T <: S & I2 {
   |          ^ 
   | 

error: the upper bound 'Struct-S' of generic parameter 'Generics-T' must be class or interface
  ==> generic_upper_constraint_inheritance_07.cj:22:9:
   | 
22 | class A<T> where T <: S & I2 {}
   |         ^ 
   | 

2 errors generated, 2 errors printed.
*/
