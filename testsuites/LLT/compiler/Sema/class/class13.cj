// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC:%frontendCompiler %typecheck %noColor %f 2>&1 | compare %f


main():Int64 {
    var a = Coo(1)
    return 0
}

class Coo{
    public init(
    a:Int64,
    ){ 

    }
}

/* SCAN
error: expected a parameter name after ',', found ')'
  ==> class13.cj:18:5:
   | 
18 |     ){ 
   |     ^ expected a parameter name here
   | 

1 error generated, 1 error printed.
*/
