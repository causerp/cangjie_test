// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

main() {
    CPointerHandle()
    CPointerHandle<CType>()
    return 0
}

/* SCAN
error: unable to infer generic argument of this function
  ==> c_type_subtype.cj:10:5:
   | 
10 |     CPointerHandle()
   |     ^^^^^^^^^^^^^^ 
   | 
note: following constraints for type variable 'Generics-T' cannot be solved:
      'Generics-T <: Interface-CType'
   ==> (package std.core)array_common.cj:427:30:

error: generics type arguments do not match the constraint of 'Struct-CPointerHandle<Generics-T>'
  ==> c_type_subtype.cj:11:20:
   | 
11 |     CPointerHandle<CType>()
   |                    ^ 
   | 
note: 'Interface-CType' is not a subtype of 'Interface-CType'
   ==> (package std.core)array_common.cj:427:39:

2 errors generated, 2 errors printed.
*/
