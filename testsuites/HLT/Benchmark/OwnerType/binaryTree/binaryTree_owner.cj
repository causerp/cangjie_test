/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.sync.*
import std.convert.*
import std.collection.*

open class Tree {
}

class Empty <: Tree {
}

class Node <: Tree {
    var left : ^Tree
    var right : ^Tree

    init(l:^Tree, r: ^Tree) {
        left = l
        right = r
    }
}

func itemCheck(tree:^Tree):UInt32{
    match (tree){
        case n: ^Node =>
            return 1 + itemCheck(n.left) + itemCheck(n.right)
        case _ => return 1
    }
}

func bottomUpTree(depth:UInt32):^Tree{
    if (depth > 0) {
        let l : ^Tree = bottomUpTree(depth - 1)
        let r : ^Tree = bottomUpTree(depth - 1)
        return ^Node(l, r)
    }
    return ^Empty()
}

class AllResult{
    public var outBuff :Array<String>
    public init(maxDepth:UInt32){
        outBuff = Array<String>(Int64(maxDepth),repeat:"")
    }
}

func Run(maxDepth:UInt32){
    let x = AllResult(maxDepth)
    for (depth in 1..=maxDepth:1) {
        var acc = UInt32(0)
        var a = bottomUpTree(depth)
        acc += itemCheck(a)
        var msg = "trees of depth ${depth}\t check: ${acc}"
        x.outBuff[Int64(depth - 1)] = msg
    }
    for (m in x.outBuff) {
        println(m)
    }
}

main(args: Array<String>){
    var n = UInt32.tryParse(args[0])??UInt32(21)
    Run(n)
}

