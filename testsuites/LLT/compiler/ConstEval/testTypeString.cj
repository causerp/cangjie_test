// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

`// (DEBUG_OPTION)EXEC: %compiler %debugCHIROpt %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan debug: consteval at testTypeString.cj:17:1 - testTypeString.cj:17:60 evaluated initializer function
// ASSERT: scan debug: consteval at testTypeString.cj:23:1 - testTypeString.cj:23:27 evaluated initializer function
// (CJNATIVE) ASSERT: scan debug: consteval at testTypeString.cj:27:1 - testTypeString.cj:27:25 evaluated initializer function
// (not CJNATIVE) ASSERT: scan debug: consteval at testTypeString.cj:27:1 - testTypeString.cj:27:25 evaluated from 1 nodes to 1 nodes
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests basic constant evaluation with `String` type.

const q: String = "constant evaluation is pretty neat, eh?"

const func append_answer(question: String): String {
  question + " yeah!"
}

const a = append_answer(q)

// Empty strings are lowered to CHIR differently so must be tested.

const empty: String = ""

main() {}

