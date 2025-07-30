// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

class Z<T> {
    public func foo() {}
}

class C<X> where X <: Z<C<Int32>> {
    init(input: X) {
        let a: Unit = input.foo()
    }
}

main(): Int64 {
    return 0
}

/* SCAN
error: generics type arguments do not match the constraint of 'Class-C<Generics-X>'
  ==> assumption2_test.cj:13:27:
   | 
13 | class C<X> where X <: Z<C<Int32>> {
   |                           ^ 
   | 
note: 'Int32' is not a subtype of 'Class-Z<Class-C<Int32>>'
  ==> assumption2_test.cj:13:18:
   | 
13 | class C<X> where X <: Z<C<Int32>> {
   |                  ^ 
   | 

error: generics type arguments do not match the constraint of 'Class-C<Generics-X>'
  ==> assumption2_test.cj:13:1:
   | 
13 | class C<X> where X <: Z<C<Int32>> {
   | ^ 
   | 

2 errors generated, 2 errors printed.
*/
