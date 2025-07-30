// ERRCHECK: %compiler %cmp_opt %f -o %output

main() {
   // a tuple is of at least two dimensions
   var x: (Int64, ) = (1, ) // err
   var y: (Int64, Int64, ) = (1, 2) // ok
   println(y)
}

/* SCAN
error: expected type name after ',', found ')'
 ==> tupletype.cj:5:19:
  | 
5 |    var x: (Int64, ) = (1, ) // err
  |                 ~ ^ expected type name here
  |                 |
  |                 after ','
  | 

error: expected expression after ',', found ')'
 ==> tupletype.cj:5:27:
  | 
5 |    var x: (Int64, ) = (1, ) // err
  |                           ^ expected expression here
  | 

2 errors generated, 2 errors printed.
*/

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
