package default.Arrary

func test11() {
    let arr :Array<Int64> = [1,2,3,4,5]
    let b:Array<Array<Int64>>= [arr]
    let c = [b]
    let d:Array<Array<Array<Array<Int64>>>> = [c]

    var a1 = d[0][0][0][0] -1
    var a2 = c[1]

}


/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
