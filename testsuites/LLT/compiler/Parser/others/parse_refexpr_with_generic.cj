// ERRCHECK:%frontendCompiler %cmp_opt %f

main():Unit{
    Option<(,)>.Some(1)
}

/* SCAN
error: expected type name after '(', found ','
 ==> parse_refexpr_with_generic.cj:4:13:
  | 
4 |     Option<(,)>.Some(1)
  |            ~^ expected type name here
  |            |
  |            after '('
  | 

error: expected type name after ',', found ')'
 ==> parse_refexpr_with_generic.cj:4:14:
  | 
4 |     Option<(,)>.Some(1)
  |             ~^ expected type name here
  |             |
  |             after ','
  | 

2 errors generated, 2 errors printed.
*/

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
