// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// ERRCHECK: %compiler %noColor %n.cj

class A {
    prop a: Int64
}

/* SCAN
error: property 'a' can not be abstract
  ==> property_body.cj:11:5:
   | 
11 |     prop a: Int64
   |     ^ 
   | 

error: class 'A' missing abstract modifier or abstract property 'a' should be implemented
  ==> property_body.cj:10:1:
   | 
10 | class A {
   | ^ 
   | 
note: unimplemented abstract property
  ==> property_body.cj:11:5:
   | 
11 |     prop a: Int64
   |     ^ 
   | 

error: 'main' is missing
 ==> property_body.cj:1:1:
  | 
1 | // Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
  | ^ 
  | 

3 errors generated, 3 errors printed.
*/
