// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

interface I<T> {
    static func f<T1, T2>(): Unit where T1 <: T2, T2 <: T {}
}

class A <: I<Int64> {
    public static func f<T1, T2>(): Unit where T1 <: Int64 {}
}

main() {}

/* SCAN
error: the upper bound 'Generics-T2' of generic parameter 'Generics-T1' must be class or interface
  ==> generic_upper_constraint_inheritance_05.cj:10:19:
   | 
10 |     static func f<T1, T2>(): Unit where T1 <: T2, T2 <: T {}
   |                   ^^ 
   | 

error: the upper bound 'Generics-T' of generic parameter 'Generics-T2' must be class or interface
  ==> generic_upper_constraint_inheritance_05.cj:10:23:
   | 
10 |     static func f<T1, T2>(): Unit where T1 <: T2, T2 <: T {}
   |                       ^^ 
   | 

error: the upper bound 'Int64' of generic parameter 'Generics-T1' must be class or interface
  ==> generic_upper_constraint_inheritance_05.cj:14:26:
   | 
14 |     public static func f<T1, T2>(): Unit where T1 <: Int64 {}
   |                          ^^ 
   | 

3 errors generated, 3 errors printed.
*/
