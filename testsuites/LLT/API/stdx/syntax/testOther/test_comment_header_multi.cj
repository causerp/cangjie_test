/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: sourceFile/comment_header_multi.cj
// (not Windows) EXEC: dos2unix comment_header_multi.cj
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.syntax.*
import std.fs.*
import std.collection.ArrayList

@Test
class Test {
    var file: ?SourceFile = None

    @BeforeAll
    func readDecls(): Unit {
        let node = parseFile("comment_header_multi.cj")
        file = (node.node.getOrThrow() as SourceFile).getOrThrow()
    }

    @TestCase
    func testCommentContent() {
        let comments = file.getOrThrow().comments
        // 3 comments: /* comment 1 */, /* comment 2 */, /* comment after package */
        @Expect(comments.size, 3)
        @Expect(comments[0].content, "/* comment 1 */")
        match (comments[0].kind) {
            case CommentKind.Block => ()
            case _ => @FailExpect("kind wrong")
        }
        @Expect(comments[1].content, "/* comment 2 */")
        match (comments[1].kind) {
            case CommentKind.Block => ()
            case _ => @FailExpect("kind wrong")
        }
        @Expect(comments[2].content, "/* comment after package */")
        match (comments[2].kind) {
            case CommentKind.Block => ()
            case _ => @FailExpect("kind wrong")
        }
    }

    @TestCase
    func testFileToString() {
        let node = parseFile("comment_header_multi.cj")
        let input = String.fromUtf8(File.readFrom("comment_header_multi.cj"))
        let file = (node.node.getOrThrow() as SourceFile).getOrThrow()
        @Expect(file.toString(), input)
    }
}
