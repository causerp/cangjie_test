/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package test

internal import jmodule.pkg1.*

main(): Int64 {
    var node = Node(80)
    node.setVal(100)

    println(node.getVal())
    return 0
}
