// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt  %f  -o %output 2>&1 | compare %f

class Aoo<T> where T <: Bool & Object {
    public var a: T
    public init(x: T) {
        a = x
    }
}

main() {
    var a = Aoo<Bool>(false)
    if (!a.a) {
        return 1
    }
    return 0
}

/* SCAN
error: the upper bound 'Bool' of generic parameter 'Generics-T' must be class or interface
 ==> err_invalid_upper.cj:9:11:
  | 
9 | class Aoo<T> where T <: Bool & Object {
  |           ^ 
  | 

error: generics type arguments do not match the constraint of 'Class-Aoo<Generics-T>'
  ==> err_invalid_upper.cj:17:17:
   | 
17 |     var a = Aoo<Bool>(false)
   |                 ^ 
   | 
note: 'Bool' is not a subtype of 'Class-Object'
 ==> err_invalid_upper.cj:9:20:
  | 
9 | class Aoo<T> where T <: Bool & Object {
  |                    ^ 
  | 

2 errors generated, 2 errors printed.
*/
