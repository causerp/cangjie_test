/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./utils
// DEPENDENCE: ./line_number_utils
// EXEC: %compiler %cmp_opt -p utils --mock=on %compile_lib_opt --output p1.%middle
// EXEC: %compiler %cmp_opt -p line_number_utils --mock=on %compile_lib_opt --output p2.%middle
// EXEC: %compiler %cmp_opt p1.%middle p2.%middle %n.cj -o %output %cmp_utest_opt 2>&1
// EXEC-PIPE-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

import utils.*
import line_number_utils.*
import std.unittest.*
import std.unittest.mock.*
import std.unittest.testmacro.*
import std.unittest.mock.mockmacro.*

//
// Note: long version of the test is in HLT
//

class A {
    func a(): String {
        return "original"
    }

    func b(): String {
        return "original"
    }
}

class B {
    B(var j: Int64) {}

    func i(i: Int64): Int64 {
        return i + j
    }
}

@Test
public class SpyTest {
    let aSpy = spy<A>(A())

    @TestCase
    func simpleSpySetup(): Unit {
        success {
            @On(aSpy.a()).returns("a").times(2).then().throws(Exception("a"))

            @Assert(aSpy.a(), "a")
            @Assert(aSpy.a(), "a")
            assertThrows<Exception> {
                aSpy.a()
            }
            assertThrows<Exception> {
                aSpy.a()
            }
        }
    }

    @TestCase
    func spyCallsOriginalByDefault(): Unit {
        success {
            @Assert(aSpy.a(), "original")
            @Assert(aSpy.b(), "original")
            @Assert(aSpy.a(), "original")
            let spy2 = spy(A())
            @Assert(spy2.a(), "original")
            @Assert(spy2.b(), "original")
            @Assert(spy2.a(), "original")
        }
    }

    @TestCase
    func spiesCanUseInternalState(): Unit {
        success {
            let spy1 = spy(B(0))
            let spy2 = spy(B(2))
            @Assert(spy1.i(0), 0)
            @Assert(spy1.i(5), 5)
            @Assert(spy2.i(0), 2)
            @Assert(spy2.i(5), 7)
        }
    }

    @TestCase
    func spiesArgumentMatchers(): Unit {
        success {
            let spy = spy(B(5))
            @On(spy.i(3)).returns(100)
            @On(spy.i(4)).returns(200)
            @Assert(spy.i(5), 10)
            @Assert(spy.i(0), 5)
            @Assert(spy.i(3), 100)
            @Assert(spy.i(4), 200)
        }
    }
}
