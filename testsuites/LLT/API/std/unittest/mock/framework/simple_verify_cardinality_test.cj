/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./utils
// EXEC: %compiler %cmp_opt -p utils --mock=on %compile_lib_opt --output p1.%middle
// EXEC: %compiler %cmp_opt p1.%middle %n.cj -o %output %cmp_utest_opt 2>&1
// EXEC-PIPE-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

import utils.*
import std.unittest.*
import std.unittest.mock.*
import std.unittest.testmacro.*
import std.unittest.mock.mockmacro.*

//
// Note: long version of the test is in HLT
//

public class Example {
    public func a(): String {
        ""
    }
    public func b(): String {
        ""
    }
    public func c(): String {
        ""
    }
}

@Test
public class VerifyCardinalityTest {
    private let e = mock<Example>()

    @TestCase
    func testSimple(): Unit {
        success {
            @On(e.a()).returns("")

            e.a()

            Verify.that(@Called(e.a()))
        }
    }

    @TestCase
    func testSimpleCardinality(): Unit {
        success {
            @On(e.a()).returns("")

            e.a()

            Verify.that(@Called(e.a()).once())
        }
    }

    @TestCase
    func testTimesCardinalitySuccess(): Unit {
        success {
            @On(e.a()).returns("").anyTimes()
            @On(e.b()).returns("").anyTimes()
            @On(e.c()).returns("").anyTimes()

            e.a()
            e.a()
            e.a()
            e.b()
            e.b()
            e.c()

            Verify.that(@Called(e.c()).times(1))
            Verify.that(@Called(e.b()).times(2))
            Verify.that(@Called(e.a()).times(3))
        }
    }
}
