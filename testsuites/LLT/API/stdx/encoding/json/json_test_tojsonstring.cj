/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler  %import-cangjie-stdx  %cmp_opt %f %cmp_utest_opt -o %output
// EXEC-PIPE:%set_stdx_path %run %run_opt %output %run_utest_opt %run_args

import stdx.encoding.json.*

let ja = JsonValue.fromStr(##"[null, true, [123, false], {"key1": " ", "key2": "\\a"}]"##).asArray()
let jo = JsonValue
    .fromStr(##"{"null": null, "bool": true, "array": [123, false], "object": {"key1": " ", "key2": "\\a"}}"##)
    .asObject()

@Test
public class JsonToJsonStringTest {
    @TestCase
    func jsonArrayIllegalDepth(): Unit {
        try {
            ja.toJsonString(-1, bracketInNewLine: false, indent: "  ")
            @Expect(false)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Depth cannot be negative.")
        }
    }

    @TestCase
    func jsonArrayDepthIsZero(): Unit {
        let expectStr = ##"[
  null,
  true,
  [
    123,
    false
  ],
  {
    "key1": " ",
    "key2": "\\a"
  }
]"##
        @Expect(ja.toJsonString(0, bracketInNewLine: false, indent: "  "), expectStr)
    }

    @TestCase
    func jsonArrayDepthIsOne(): Unit {
        let expectStr = ##"[
    null,
    true,
    [
      123,
      false
    ],
    {
      "key1": " ",
      "key2": "\\a"
    }
  ]"##
        @Expect(ja.toJsonString(1, bracketInNewLine: false, indent: "  "), expectStr)
    }

    @TestCase
    func jsonArrayNewLineIsTrue(): Unit {
        let expectStr = ##"  [
    null,
    true,
    [
      123,
      false
    ],
    {
      "key1": " ",
      "key2": "\\a"
    }
  ]"##
        @Expect(ja.toJsonString(1, bracketInNewLine: true, indent: "  "), expectStr)
    }

    @TestCase
    func jsonArrayIndentIsEmpty(): Unit {
        let expectStr = ##"[
null,
true,
[
123,
false
],
{
"key1": " ",
"key2": "\\a"
}
]"##
        @Expect(ja.toJsonString(1, bracketInNewLine: false, indent: ""), expectStr)
    }

    @TestCase
    func jsonArrayIllegalIndent(): Unit {
        try {
            ja.toJsonString(0, bracketInNewLine: false, indent: "abc")
            @Expect(false)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Indent must be an empty string or any combination of spaces and tabs.")
        }
    }

    @TestCase
    func jsonArrayIndentIsTabs(): Unit {
        let expectStr = "[\n\t\tnull,\n\t\ttrue,\n\t\t[\n\t\t\t123,\n\t\t\tfalse\n\t\t],\n\t\t{\n\t\t\t\"key1\": \" \",\n\t\t\t\"key2\": \"\\\\a\"\n\t\t}\n\t]"
        @Expect(ja.toJsonString(1, bracketInNewLine: false, indent: "\t"), expectStr)
    }

    @TestCase
    func jsonArrayIndentIsSpacesAndTabs(): Unit {
        let expectStr = "[\n \t \tnull,\n \t \ttrue,\n \t \t[\n \t \t \t123,\n \t \t \tfalse\n \t \t],\n \t \t{\n \t \t \t\"key1\": \" \",\n \t \t \t\"key2\": \"\\\\a\"\n \t \t}\n \t]"
        @Expect(ja.toJsonString(1, bracketInNewLine: false, indent: " \t"), expectStr)
    }

    @TestCase
    func jsonObjectIllegalDepth(): Unit {
        try {
            jo.toJsonString(-1, bracketInNewLine: false, indent: "  ")
            @Expect(false)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Depth cannot be negative.")
        }
    }

    @TestCase
    func jsonObjectDepthIsZero(): Unit {
        let expectStr = ##"{
  "null": null,
  "bool": true,
  "array": [
    123,
    false
  ],
  "object": {
    "key1": " ",
    "key2": "\\a"
  }
}"##
        @Expect(jo.toJsonString(0, bracketInNewLine: false, indent: "  "), expectStr)
    }

    @TestCase
    func jsonObjectDepthIsOne(): Unit {
        let expectStr = ##"{
    "null": null,
    "bool": true,
    "array": [
      123,
      false
    ],
    "object": {
      "key1": " ",
      "key2": "\\a"
    }
  }"##
        @Expect(jo.toJsonString(1, bracketInNewLine: false, indent: "  "), expectStr)
    }

    @TestCase
    func jsonObjectNewLineIsTrue(): Unit {
        let expectStr = ##"  {
    "null": null,
    "bool": true,
    "array": [
      123,
      false
    ],
    "object": {
      "key1": " ",
      "key2": "\\a"
    }
  }"##
        @Expect(jo.toJsonString(1, bracketInNewLine: true, indent: "  "), expectStr)
    }

    @TestCase
    func jsonObjectIllegalIndent(): Unit {
        try {
            jo.toJsonString(1, bracketInNewLine: false, indent: "abc")
            @Expect(false)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Indent must be an empty string or any combination of spaces and tabs.")
        }
    }

    @TestCase
    func jsonObjectIndentIsEmpty(): Unit {
        let expectStr = ##"{
"null": null,
"bool": true,
"array": [
123,
false
],
"object": {
"key1": " ",
"key2": "\\a"
}
}"##
        @Expect(jo.toJsonString(1, bracketInNewLine: false, indent: ""), expectStr)
    }

    @TestCase
    func jsonObjectIndentIsTabs(): Unit {
        let expectStr = "{\n\t\t\"null\": null,\n\t\t\"bool\": true,\n\t\t\"array\": [\n\t\t\t123,\n\t\t\tfalse\n\t\t],\n\t\t\"object\": {\n\t\t\t\"key1\": \" \",\n\t\t\t\"key2\": \"\\\\a\"\n\t\t}\n\t}"
        @Expect(jo.toJsonString(1, bracketInNewLine: false, indent: "\t"), expectStr)
    }

    @TestCase
    func jsonObjectIndentIsSpacesAndTabs(): Unit {
        let expectStr = "{\n \t \t\"null\": null,\n \t \t\"bool\": true,\n \t \t\"array\": [\n \t \t \t123,\n \t \t \tfalse\n \t \t],\n \t \t\"object\": {\n \t \t \t\"key1\": \" \",\n \t \t \t\"key2\": \"\\\\a\"\n \t \t}\n \t}"
        @Expect(jo.toJsonString(1, bracketInNewLine: false, indent: " \t"), expectStr)
    }
}
