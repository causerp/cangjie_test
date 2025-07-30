// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %cmp_opt %f 2>&1 | compare %f

enum A<T> {
    a(T)

    public static func foo() {
        test()
    }
    public func test() {}
}

class B {}

func test<T>() where T <: Option<B> {}

main(): Int64 {
    test<B>()
    return 1
}

/* SCAN
error: the upper bound 'Enum-Option<Class-B>' of generic parameter 'Generics-T' must be class or interface
  ==> enum26_1.cj:20:11:
   | 
20 | func test<T>() where T <: Option<B> {}
   |           ^ 
   | 

error: 'test' is non-static member, cannot be accessed by static function 'foo'
  ==> enum26_1.cj:13:9:
   | 
13 |         test()
   |         ^ 
   | 

error: generics type arguments do not match the constraint of '() -> Unit'
  ==> enum26_1.cj:23:10:
   | 
23 |     test<B>()
   |          ^ 
   | 
note: 'Class-B' is not a subtype of 'Enum-Option<Class-B>'
  ==> enum26_1.cj:20:22:
   | 
20 | func test<T>() where T <: Option<B> {}
   |                      ^ 
   | 

3 errors generated, 3 errors printed.
*/
