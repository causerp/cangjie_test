// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

struct Data {
    var a: UInt8 = 0
    var b: UInt16 = 0
    var c: UInt32 = 0
    var d: UInt64 = 0
    var e: Int8 = 0
    var f: Int16 = 0
    var g: Int32 = 0
    var h: Int64 = 0
}

main() {
    println(alignOf<Data>())
    println(sizeOf<Data>())
}

/* SCAN-TXT
error: generics type arguments do not match the constraint of '() -> UIntNative'
  ==> not_ctype.cj:15:21:
   | 
15 |     println(alignOf<Data>())
   |                     ^ 
   | 
note: 'Struct-Data' is not a subtype of 'Interface-CType'
  ==> (package std.core)libc.cj:29:44:

error: generics type arguments do not match the constraint of '() -> UIntNative'
  ==> not_ctype.cj:16:20:
   | 
16 |     println(sizeOf<Data>())
   |                    ^ 
   | 
note: 'Struct-Data' is not a subtype of 'Interface-CType'
  ==> (package std.core)libc.cj:25:43:

2 errors generated, 2 errors printed.
*/
// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
