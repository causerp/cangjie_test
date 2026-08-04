/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// EXEC: %compiler %cmp_opt %f -o %output --test
// RUN-EXEC: %run %run_opt %output %run_args

import std.unicode.*

@Test
class Test_string_api_isBlank_fastpath {
    // 命中 isEmpty() 快速路径（O(1)，跳过 runes 迭代器初始化）
    @TestCase
    func test_empty_fast_path(): Unit {
        @Expect("".isBlank(), true)
        @Expect(#""#.isBlank(), true)
        @Expect("""
""".isBlank(), true)
    }

    // 命中 isAscii() 快速路径 + isAsciiBlank() => true
    @TestCase
    func test_ascii_whitespace_fast_path(): Unit {
        @Expect("\u{0009}".isBlank(), true)
        @Expect("\u{000A}".isBlank(), true)
        @Expect("\u{000B}".isBlank(), true)
        @Expect("\u{000C}".isBlank(), true)
        @Expect("\u{000D}".isBlank(), true)
        @Expect("\u{0020}".isBlank(), true)
        @Expect(" \u{0009}\u{000A}\u{000D}\u{000C}\u{000B}".isBlank(), true)
        @Expect("                    ".isBlank(), true)
    }

    // 命中 isAscii() 快速路径 + isAsciiBlank() => false（纯 ASCII 含非空白）
    @TestCase
    func test_ascii_non_blank_fast_path(): Unit {
        @Expect("a".isBlank(), false)
        @Expect("abc".isBlank(), false)
        @Expect("  abc  ".isBlank(), false)
        @Expect("\u{0009}value\u{000A}".isBlank(), false)
    }

    // isAscii() => false，回退到 runes() 路径 => true（纯 Unicode 空白）
    @TestCase
    func test_unicode_whitespace_fallback(): Unit {
        @Expect("\u{00A0}".isBlank(), true)
        @Expect("\u{3000}".isBlank(), true)
        @Expect("\u{2028}".isBlank(), true)
        @Expect("\u{00A0}\u{1680}\u{3000}".isBlank(), true)
    }

    // isAscii() => false，回退到 runes() 路径 => false（Unicode 非空白）
    @TestCase
    func test_unicode_non_blank_fallback(): Unit {
        @Expect("你好".isBlank(), false)
        @Expect("\u{3000}abc".isBlank(), false)
        @Expect("a\u{00A0}b".isBlank(), false)
    }

    // 混合 ASCII 空白 + Unicode 空白 => isAscii()=false => 回退 runes() => true
    @TestCase
    func test_mixed_ascii_unicode_whitespace(): Unit {
        @Expect(" \u{00A0}".isBlank(), true)
        @Expect("\u{0009}\u{3000}\u{000A}".isBlank(), true)
    }

    // 高压测试：256K 空串直接调用 isBlank()（命中 isEmpty() 快速路径）
    // 基准对照：优化前 ~27.8ms / 256K，优化后 ~1.7ms / 256K（约 16x）
    @TestCase
    func test_stress_empty_strings(): Unit {
        let dataSize = 256 * 1024
        let strings = Array<String>(dataSize) {_ => ""}
        var count = 0
        for (str in strings) {
            if (str.isBlank()) {
                count++
            }
        }
        @Expect(count, dataSize)
    }

    // 高压测试：256K 纯 ASCII 串（命中 isAscii() 快速路径，避免 UTF-8 解码）
    @TestCase
    func test_stress_ascii_strings(): Unit {
        let dataSize = 256 * 1024
        let blankStrings = Array<String>(dataSize) {_ => "    "}
        let nonBlankStrings = Array<String>(dataSize) {_ => "abc"}
        var blankCount = 0
        var nonBlankCount = 0
        for (str in blankStrings) {
            if (str.isBlank()) {
                blankCount++
            }
        }
        for (str in nonBlankStrings) {
            if (!str.isBlank()) {
                nonBlankCount++
            }
        }
        @Expect(blankCount, dataSize)
        @Expect(nonBlankCount, dataSize)
    }
}
