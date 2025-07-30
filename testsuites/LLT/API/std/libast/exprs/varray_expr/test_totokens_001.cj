// EXEC: %compiler %cmp_opt_chir2hlir %f -o %output
// EXEC: %run %run_opt %output %run_args

internal import std.ast.*

main(): Int64 {
    let input = quote(
        let arr5: VArray<Int64, \$5> = VArray<Int64, \$5>{i => i}
    )
    var varray = (parseDecl(input) as VarDecl).getOrThrow()
    var initExpr = varray.expr
    if (initExpr.toTokens().size != 12) {
        return 1
    }
    if (initExpr.toTokens()[2].kind != TokenKind.INT64) {
        return 2
    }

    let input1 = quote(
        var varr: VArray<Int64, \$3> = VArray<Int64, \$3>(repeat: 1)
    )
    varray = (parseDecl(input1) as VarDecl).getOrThrow()
    initExpr = varray.expr
    if (initExpr.toTokens().size != 12) {
        return 3
    }
    if (initExpr.toTokens()[9].kind != TokenKind.COLON) {
        return 4
    }

    return 0
}
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
