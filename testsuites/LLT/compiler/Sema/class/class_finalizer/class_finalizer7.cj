// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %n.cj -o %n.%suffix 2>&1 | compare %f

class E {
    ~init(): Unit {
    }
}

/* SCAN
error: there should be no return value type in a finalizer
  ==> class_finalizer7.cj:10:14:
   | 
10 |     ~init(): Unit {
   |              ^ 
   | 

error: 'main' is missing
 ==> class_finalizer7.cj:1:1:
  | 
1 | // Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
  | ^ 
  | 

2 errors generated, 2 errors printed.
*/
