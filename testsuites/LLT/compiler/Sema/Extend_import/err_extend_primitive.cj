// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

import std.convert.Formattable
import std.math.abs

main() {
    println(pow(1.2, 2.3))
}

/* SCAN
error: undeclared identifier 'pow'
  ==> err_extend_primitive.cj:13:13:
   | 
13 |     println(pow(1.2, 2.3))
   |             ^ 
   | 

1 error generated, 1 error printed.
*/
