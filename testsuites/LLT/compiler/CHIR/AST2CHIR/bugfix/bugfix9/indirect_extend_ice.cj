/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %enableO2 %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.*

main(): Int64 {
    var str: Array<Mut<Int64>> = [Mut<Int64>(), subMut<Int64>()]
    return 0
}

open class Mut<T> <: Hashable {
    public func test(x: Int64): Int64 {
        return x
    }
    public open func hashCode(): Int64 {
        return 9
    }
}

class subMut<T> <: Mut<T> {
    public func test1(x: Int64): Int64 {
        return x
    }
    public override func hashCode(): Int64 {
        return 10
    }
}

extend<T> Mut<T> <: Equatable<Mut<T>> {
    public operator func ==(that: Mut<T>): Bool {
        return true;
    }
    public operator func !=(that: Mut<T>): Bool {
        return false
    }
}
