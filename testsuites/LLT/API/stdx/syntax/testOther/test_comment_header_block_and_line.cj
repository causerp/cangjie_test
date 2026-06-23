/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: sourceFile/comment_header_block_and_line.cj
// (not Windows) EXEC: dos2unix comment_header_block_and_line.cj
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
        let node = parseFile("comment_header_block_and_line.cj")
        file = (node.node.getOrThrow() as SourceFile).getOrThrow()
    }

    @TestCase
    func testCommentContent() {
        let comments = file.getOrThrow().comments
        // 2 comments: /* leading comment */, // line comment
        @Expect(comments.size, 2)
        @Expect(comments[0].content, "/* leading comment */")
        match (comments[0].kind) {
            case CommentKind.Block => ()
            case _ => @FailExpect("kind wrong")
        }
        @Expect(comments[1].content, "// line comment")
        match (comments[1].kind) {
            case CommentKind.Line => ()
            case _ => @FailExpect("kind wrong")
        }
    }

    @TestCase
    func testPackageComment() {
        let pkgHeader = file.getOrThrow().pkgHeader.getOrThrow()
        let comments = pkgHeader.comments
        // 1 comment: // trailing comment after package
        @Expect(comments.size, 1)
        @Expect(comments[0].content, "// trailing comment after package")
        match (comments[0].kind) {
            case CommentKind.Line => ()
            case _ => @FailExpect("kind wrong")
        }
    }

    @TestCase
    func testFileToString() {
        let node = parseFile("comment_header_block_and_line.cj")
        let input = String.fromUtf8(File.readFrom("comment_header_block_and_line.cj"))
        let file = (node.node.getOrThrow() as SourceFile).getOrThrow()
        @Expect(file.toString(), input)
    }
}
