/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// (CJNATIVE) EXEC: %compiler -Woff all %cmp_opt %f -g -o %output %cmp_utest_opt
// (CJNATIVE) RUN-EXEC-PIPE-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

import std.reflect.*
import std.collection.*

@Test
class TestStdSymbols {
    @TestCase
    func testArrayListByReflect() {
        let typeInfo = ClassTypeInfo.of<ArrayList<String>>()
        let constructor = typeInfo.getConstructor()
        let instance: ArrayList<String> = (constructor.apply() as ArrayList<String>).getOrThrow()
        instance.add("Hello, world")
        @Expect(instance.size, 1)
        @Expect(instance.toString(), "[Hello, world]")
    }
}