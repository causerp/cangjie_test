/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: getPath.sh test_fj.txt
// (not Windows) EXEC-PIPE: chmod +x getPath.sh
// (not Windows) EXEC-PIPE: ./getPath.sh b
// (not Windows) EXEC-PIPE: %compiler %cmp_opt mypath.cj -o %output %f
// (not Windows) RUN-EXEC-PIPE: %run %run_opt %output %run_args
import std.posix.*

main() {
    var resulttrue1 = isBlk(mypath)
    if (resulttrue1 != true) {
        return 1
    }
    var resultfalse1 = isBlk("test_fj.txt")
    var resultfalse2 = isBlk("./test_notexists")
    if (resultfalse1 != false || resultfalse2 != false) {
        return 2
    }
    return 0
}
