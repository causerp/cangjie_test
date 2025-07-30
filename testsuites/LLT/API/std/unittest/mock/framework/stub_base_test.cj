/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./utils
// DEPENDENCE: ./stub_utils
// EXEC: %compiler %cmp_opt -p utils --mock=on %compile_lib_opt --output p1.%middle
// EXEC: %compiler %cmp_opt -p stub_utils --mock=on %compile_lib_opt --output p2.%middle
// EXEC: %compiler %cmp_opt p1.%middle p2.%middle %n.cj -o %output %cmp_utest_opt 2>&1
// EXEC-PIPE-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

import utils.*
import stub_utils.*
import std.collection.*
import std.unittest.*
import std.unittest.mock.*
import std.unittest.testmacro.*
import std.unittest.mock.mockmacro.*

//
// Note: long version of the test is in HLT
//

@Test
public class StubTest {
    let id = mock<BookId>()
    let db = mock<BookDB>()
    let pm = PreviewManager(db)

    @TestCase
    func testBasicConfiguration(): Unit {
        success {
            @On(
                db.getText(id)
            ).returns(
                "Chapter 1\nOnce upon a time...\nChapter 2\nThere was a princess\nChapter 3\nAnd a dragon")

            assertEquals(pm.getPreview(id), "Chapter 1\nOnce upon a time...\n")
        }
    }

    @TestCase
    func sameMatcher(): Unit {
        success {
            let realId = BookId()
            @On(
                db.getText(Matchers.same(realId))
            ).returns(
                "Chapter 1\nDragon ate the princess.\n")
            @On(
                db.getText(Matchers.same(id))
            ).returns(
                "Chapter 1\nOnce upon a time...\nChapter 2\nThere was a princess\nChapter 3\nAnd a dragon")
            assertEquals(pm.getPreview(realId), "Preview not available")
            assertEquals(pm.getPreview(id), "Chapter 1\nOnce upon a time...\n")
        }
    }

    @TestCase
    func stubShadowing(): Unit {
        success {
            @On(
                db.getText(same(id))
            ).returns("a")
            assertEquals(db.getText(id), "a")
            @On(
                db.getText(Matchers.same(id))
            ).returns("b")
            assertEquals(db.getText(id), "b")
            @On(
                db.getText(same(id))
            ).returns("c")
            assertEquals(db.getText(id), "c")
        }
    }

    @TestCase
    func successfulChain(): Unit {
        success {
            @On(
                db.getText(id)
            ).returns("a").once().then().returns("b")
            assertEquals(db.getText(id), "a")
            assertEquals(db.getText(id), "b")
            assertEquals(db.getText(id), "b")
            assertEquals(db.getText(id), "b")
        }
    }

    @TestCase
    func eqMatcher(): Unit {
        success {
            @On(
                db.get(eq(A(5)))
            ).returns("a")

            @On(
                db.get(eq(A(6)))
            ).returns("b")

            assertEquals(db.get(A(5)), "a")
            assertEquals(db.get(A(6)), "b")
        }
    }

    @TestCase
    func defaultMatcher(): Unit {
        success {
            @On(
                db.get(default(A(5)))
            ).returns("a")

            @On(
                db.get(default(A(6)))
            ).returns("b")

            assertEquals(db.get(A(6)), "b")
            assertEquals(db.get(A(5)), "a")

            @On(
                db.getText(default(id))
            ).returns("c")

            assertEquals(db.getText(id), "c")
        }
    }

    @TestCase
    func anyMatcher(): Unit {
        success {
            @On(
                db.get(any())
            ).returns("a")

            assertEquals(db.get(A(6)), "a")
            assertEquals(db.get(A(5)), "a")
            assertEquals(db.get(A(6)), "a")
            assertEquals(db.get(A(-2)), "a")

            @On(
                db.get(any())
            ).returns("b")

            assertEquals(db.get(A(6)), "b")
            assertEquals(db.get(Base()), "b")
            assertEquals(db.get(B()), "b")
        }
    }

    @TestCase
    func ofTypeMatcher(): Unit {
        success {
            @On(
                db.get(any())
            ).returns("a")

            @On(
                db.get(ofType<A>())
            ).returns("b")

            assertEquals(db.get(A(6)), "b")
            assertEquals(db.get(A(7)), "b")
            assertEquals(db.get(B()), "a")
            assertEquals(db.get(Base()), "a")
        }
    }

    @TestCase
    func argThatMatcher(): Unit {
        success {
            @On(
                db.get(any())
            ).returns("a")
            @On(
                db.get(argThat { a: A => a.n == 6 || a.n == 8 })
            ).returns("b")

            assertEquals(db.get(A(6)), "b")
            assertEquals(db.get(A(7)), "a")
            assertEquals(db.get(A(8)), "b")
            assertEquals(db.get(Base()), "a")
            assertEquals(db.get(B()), "a")
        }
    }

    @TestCase
    func argThatNotMatcher(): Unit {
        success {
            @On(
                db.get(any())
            ).returns("a")
            @On(
                db.get(argThatNot { a: A => a.n == 6 || a.n == 8 })
            ).returns("b")

            assertEquals(db.get(A(6)), "a")
            assertEquals(db.get(A(7)), "b")
            assertEquals(db.get(A(8)), "a")
            assertEquals(db.get(Base()), "b")
            assertEquals(db.get(B()), "b")
        }
    }
}
