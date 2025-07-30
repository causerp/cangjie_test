// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f 2>&1 | compare %f

// Constraint check should pass
interface I {
    static func f<T1, T2, T3, T4>(): Unit where T1 <: T2, T2 <: T3, T3 <: T4 {}
}

class A <: I {
    public static func f<T1, T2, T3, T4>(): Unit where T1 <: T4 {}
}

main() {
}

/* SCAN
error: the upper bound 'Generics-T2' of generic parameter 'Generics-T1' must be class or interface
  ==> generic_upper_constraint_inheritance_04.cj:11:19:
   | 
11 |     static func f<T1, T2, T3, T4>(): Unit where T1 <: T2, T2 <: T3, T3 <: T4 {}
   |                   ^^ 
   | 

error: the upper bound 'Generics-T3' of generic parameter 'Generics-T2' must be class or interface
  ==> generic_upper_constraint_inheritance_04.cj:11:23:
   | 
11 |     static func f<T1, T2, T3, T4>(): Unit where T1 <: T2, T2 <: T3, T3 <: T4 {}
   |                       ^^ 
   | 

error: the upper bound 'Generics-T4' of generic parameter 'Generics-T3' must be class or interface
  ==> generic_upper_constraint_inheritance_04.cj:11:27:
   | 
11 |     static func f<T1, T2, T3, T4>(): Unit where T1 <: T2, T2 <: T3, T3 <: T4 {}
   |                           ^^ 
   | 

error: the upper bound 'Generics-T4' of generic parameter 'Generics-T1' must be class or interface
  ==> generic_upper_constraint_inheritance_04.cj:15:26:
   | 
15 |     public static func f<T1, T2, T3, T4>(): Unit where T1 <: T4 {}
   |                          ^^ 
   | 

4 errors generated, 4 errors printed.
*/
