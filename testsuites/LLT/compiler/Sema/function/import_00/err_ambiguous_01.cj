// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: m1
// DEPENDENCE: m2
// EXEC: %compiler %cmp_opt %compile_lib_opt %mod_name_opt m1 ./m1/p1.cj -o m1/p1.%middle
// EXEC: %compiler %cmp_opt %compile_lib_opt %mod_name_opt m2 ./m2/p1.cj -o m2/p1.%middle
// ERRCHECK: %compiler %cmp_opt m1/p1.%middle m2/p1.%middle %f -o %output

import m1.p1
import m2.p1

main() {
    println("${p1.f()}")
}

/* SCAN
warning: imported decl 'p1' is conflicted with other import
  ==> err_ambiguous_01.cj:14:11:
   | 
14 | import m2.p1
   |           ^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff package-import`
note: The previous was imported here
  ==> err_ambiguous_01.cj:13:11:
   | 
13 | import m1.p1
   |           ^^ 
   | 

error: ambiguous use of 'p1'
  ==> err_ambiguous_01.cj:17:16:
   | 
17 |     println("${p1.f()}")
   |                ^^ 
   | 
note: found imported candidate
  ==> err_ambiguous_01.cj:13:1:
   | 
13 | import m1.p1
   | ^^^^^^^^^^^^ 
   | 
note: found imported candidate
  ==> err_ambiguous_01.cj:14:1:
   | 
14 | import m2.p1
   | ^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
1 warning generated, 1 warning printed.
*/
