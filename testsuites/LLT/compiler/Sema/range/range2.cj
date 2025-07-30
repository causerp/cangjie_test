// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %noColor %typecheck %f 2>&1 | compare %f

main() {
    var range1 = 1..Int64(10) : 3
    var range2 = 1..10 : true
    var range3 = 1.0..10.0 : 2.0
    var range4 = 1..10 : 0
    return 0
}

/* SCAN
error: cannot convert a boolean literal to type 'Int64'
  ==> range2.cj:11:26:
   | 
11 |     var range2 = 1..10 : true
   |                          ^ 
   | 

error: generics type arguments do not match the constraint of 'Struct-Range<Generics-T>'
  ==> range2.cj:12:18:
   | 
12 |     var range3 = 1.0..10.0 : 2.0
   |                  ^ 
   | 
note: 'Float' is not a subtype of 'Interface-Countable<Float>'
  ==> (package std.core)range.cj:12:45:

error: cannot convert a floating-point literal to type 'Int64'
  ==> range2.cj:12:30:
   | 
12 |     var range3 = 1.0..10.0 : 2.0
   |                              ^ 
   | 

error: step cannot be zero in range expression
  ==> range2.cj:13:26:
   | 
13 |     var range4 = 1..10 : 0
   |                          ^ 
   | 

4 errors generated, 4 errors printed.
*/
