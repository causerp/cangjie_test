// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

struct A {}

main() {
    sizeOf<VArray<A, $3>>()
}

/* SCAN
error: generics type arguments do not match the constraint of '() -> UIntNative'
  ==> varray_ctype01.cj:12:12:
   | 
12 |     sizeOf<VArray<A, $3>>()
   |            ^ 
   | 
note: 'VArray<Struct-A, $3>' is not a subtype of 'Interface-CType'
  ==> (package std.core)libc.cj:25:43:

1 error generated, 1 error printed.
*/
