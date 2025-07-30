// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %n.%suffix 2>&1 | compare %f

type A<T> = Cl<T>

open class Base {}

class Cl<U> where U <: Base {}

class Sub<X> {
    public var a: A<X>
}

main() {
    return 0;
}

/* SCAN
error: generics type arguments do not match the constraint of 'Class-Cl<Generics-U>'
  ==> typealias9.cj:16:19:
   | 
16 |     public var a: A<X>
   |                   ^ 
   | 
note: 'Generics-X' is not a subtype of 'Class-Base'
  ==> typealias9.cj:13:19:
   | 
13 | class Cl<U> where U <: Base {}
   |                   ^ 
   | 

error: the uninitialized member variable 'a' is not initialized in the constructor of class or struct
  ==> typealias9.cj:16:5:
   | 
16 |     public var a: A<X>
   |     ^ 
   | 

2 errors generated, 2 errors printed.
*/
