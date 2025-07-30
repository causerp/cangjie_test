// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (DEBUG_OPTION)EXEC: %compiler %debugCHIROpt %n.cj -o %output 2>&1 | compare %f
// (CJNATIVE and DEBUG_OPTION) EXEC: %run %run_opt %output %run_args
// (CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:23:5 - testTypeAny.cj:23:36 function `gv$_a1` not evaluated successfully.
// (CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:24:5 - testTypeAny.cj:24:40 function `gv$_a2` not evaluated successfully.
// (CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:27:1 - testTypeAny.cj:27:26 function `gv$_a1` not evaluated successfully.
// (CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:28:1 - testTypeAny.cj:28:28 function `gv$_a2` not evaluated successfully.
// (not CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:23:5 - testTypeAny.cj:23:36 function `gv$_a1` not evaluated successfully.
// (not CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:24:5 - testTypeAny.cj:24:40 function `gv$_a2` not evaluated successfully.
// (not CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:27:1 - testTypeAny.cj:27:26 function `gv$_a1` not evaluated successfully.
// (not CJNATIVE and DEBUG_OPTION) ASSERT: scan debug: consteval at testTypeAny.cj:28:1 - testTypeAny.cj:28:28 function `gv$_a2` not evaluated successfully.
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests basic constant evaluation with `Any` type.

public class CC {
    public static const a1: Any = 3
    public static const a2: Any = false
}

public const a1: Any = 12
public const a2: Any = true

main() {}
