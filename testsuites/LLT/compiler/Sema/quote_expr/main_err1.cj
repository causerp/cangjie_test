// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: testa.cj err1.cj
// EXEC: %compiler %cmp_macro testa.cj
// ERRCHECK: %compiler %f %noColor -o %output

import define_10004.*

main() {
    var a = quote(1+1) // empty lambda
    a.dump()
    return 0
}

/* SCAN
error: import 'std.ast' to use the 'quote' expression
  ==> main_err1.cj:14:13:
   | 
14 |     var a = quote(1+1) // empty lambda
   |             ^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
