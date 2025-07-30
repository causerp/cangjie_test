// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

interface Ser<T> {
    static func foo(): Unit
}

class AL<T> {}

extend<T> AL<T> <: Ser<AL<T>> where T <: Ser<T> {
    public static func foo(): Unit {}
}

abstract class DM <: Ser<DM> {}

main() {
    var a = AL<DM>()
}

/* SCAN
error: can not instantiate 'Generics-T' by interface or abstract class 'Class-DM' for it has unimplemented static member
  ==> interface_static_impl_with_generic11.cj:22:16:
   | 
22 |     var a = AL<DM>()
   |                ^ 
   | 

error: abstract class 'DM' cannot contain unimplemented static function 'foo'
  ==> interface_static_impl_with_generic11.cj:19:16:
   | 
19 | abstract class DM <: Ser<DM> {}
   |                ^^ 
   | 

2 errors generated, 2 errors printed.
*/
