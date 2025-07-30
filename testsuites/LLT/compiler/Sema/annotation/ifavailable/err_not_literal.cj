// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %f %cmp_opt

const v = 11

main() {
    @IfAvailable(APILevel:v, { => println(0) }, {=>println(3)})
}

/* SCAN
error: the first argument of @IfAvailable expression must be a literal expression
  ==> err_not_literal.cj:12:17:
   | 
12 |     @IfAvailable(APILevel:v, { => println(0) }, {=>println(3)})
   |                 ^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
