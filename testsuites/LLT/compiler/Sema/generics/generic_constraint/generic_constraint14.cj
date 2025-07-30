// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

// Test for nested type error can be reported

public interface fatherInterface<T> where T <: UInt32 {
    static func foo1(): UInt32
    static func foo2<K>(a: K): UInt32 {
        foo1()
    }
}

public interface MyInterface<T> <: fatherInterface<T> where T <: UInt32 {
    static func foo3(): UInt32 {
        foo1() + foo1()
    }
}

public enum enum1<T> <: MyInterface<UInt32> {
    A(UInt32)

    public static func foo1(): UInt32 {
        1
    }
}

enum enum2<T> <: MyInterface<UInt32> {
    A(UInt32)

    public static func foo1(): UInt32 {
        2
    }
}

main() {
    var en1: enum1<MyInterface<UInt32>> = enum1<MyInterface<UInt32>>.A(
        enum1<MyInterface<UInt32>>.foo2<UInt32>(enum1<MyInterface<UInt32>>.foo1() + enum1<MyInterface<UInt16>>.foo1()))
}

/* SCAN
error: the upper bound 'UInt32' of generic parameter 'Generics-T' must be class or interface
  ==> generic_constraint14.cj:11:34:
   | 
11 | public interface fatherInterface<T> where T <: UInt32 {
   |                                  ^ 
   | 

error: the upper bound 'UInt32' of generic parameter 'Generics-T' must be class or interface
  ==> generic_constraint14.cj:18:30:
   | 
18 | public interface MyInterface<T> <: fatherInterface<T> where T <: UInt32 {
   |                              ^ 
   | 

error: generics type arguments do not match the constraint of 'Interface-MyInterface<Generics-T>'
  ==> generic_constraint14.cj:42:103:
   | 
42 |         enum1<MyInterface<UInt32>>.foo2<UInt32>(enum1<MyInterface<UInt32>>.foo1() + enum1<MyInterface<UInt16>>.foo1()))
   |                                                                                                       ^ 
   | 
note: 'UInt16' is not a subtype of 'UInt32'
  ==> generic_constraint14.cj:18:61:
   | 
18 | public interface MyInterface<T> <: fatherInterface<T> where T <: UInt32 {
   |                                                             ^ 
   | 

3 errors generated, 3 errors printed.
*/
