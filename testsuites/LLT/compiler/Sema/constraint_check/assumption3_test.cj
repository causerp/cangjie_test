// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

class C<X> where X <: C<C<C<C<Int32>>>> {
    func foo() {}
    public init(input: X) {
        let a: Unit = input.foo()
    }
}

interface I<X> where X <: I<I<I<I<Int32>>>> {}

main(): Int64 {
    return 0
}

/* SCAN
error: generics type arguments do not match the constraint of 'Class-C<Generics-X>'
 ==> assumption3_test.cj:9:31:
  | 
9 | class C<X> where X <: C<C<C<C<Int32>>>> {
  |                               ^ 
  | 
note: 'Int32' is not a subtype of 'Class-C<Class-C<Class-C<Class-C<Int32>>>>'
 ==> assumption3_test.cj:9:18:
  | 
9 | class C<X> where X <: C<C<C<C<Int32>>>> {
  |                  ^ 
  | 

error: generics type arguments do not match the constraint of 'Class-C<Generics-X>'
 ==> assumption3_test.cj:9:1:
  | 
9 | class C<X> where X <: C<C<C<C<Int32>>>> {
  | ^ 
  | 

error: generics type arguments do not match the constraint of 'Interface-I<Generics-X>'
  ==> assumption3_test.cj:16:35:
   | 
16 | interface I<X> where X <: I<I<I<I<Int32>>>> {}
   |                                   ^ 
   | 
note: 'Int32' is not a subtype of 'Interface-I<Interface-I<Interface-I<Interface-I<Int32>>>>'
  ==> assumption3_test.cj:16:22:
   | 
16 | interface I<X> where X <: I<I<I<I<Int32>>>> {}
   |                      ^ 
   | 

error: generics type arguments do not match the constraint of 'Interface-I<Generics-X>'
  ==> assumption3_test.cj:16:1:
   | 
16 | interface I<X> where X <: I<I<I<I<Int32>>>> {}
   | ^ 
   | 

4 errors generated, 4 errors printed.
*/
