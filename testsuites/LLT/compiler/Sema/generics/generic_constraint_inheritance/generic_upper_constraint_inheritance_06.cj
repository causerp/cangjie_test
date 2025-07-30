// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

// Error reported on S <: I2. Constraint of 'func bar' should not report error.
struct S <: I2 {
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
  ==> generic_upper_constraint_inheritance_06.cj:20:10:
   | 
20 | func bar<T>(x: T) where T <: S & I2 {
   |          ^ 
   | 

error: the upper bound 'Struct-S' of generic parameter 'Generics-T' must be class or interface
  ==> generic_upper_constraint_inheritance_06.cj:23:9:
   | 
23 | class A<T> where T <: S & I2 {}
   |         ^ 
   | 

error: return type of 'foo' is not identical or not a subtype of the overridden/redefined/implement function
  ==> generic_upper_constraint_inheritance_06.cj:11:10:
   | 
11 |     func foo(): Int {
   |          ^^^ 
   | 
note: 'Int64' is not a subtype of 'Struct-String'
  ==> generic_upper_constraint_inheritance_06.cj:17:10:
   | 
17 |     func foo(): String
   |          ^^^ 
   | 

3 errors generated, 3 errors printed.
*/
