// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (DEBUG_OPTION)EXEC: %compiler %compile_exe_opt %debugCHIROpt %n.cj -o %output 2>&1 | compare %f
// (DEBUG_OPTION)EXEC: %run %run_opt %output %run_args
// ASSERT: scan debug: consteval at testTypeArray.cj:26:1 - testTypeArray.cj:26:40 evaluated initializer function `gv$_a`
// ASSERT: scan debug: consteval at testTypeArray.cj:27:1 - testTypeArray.cj:27:41 evaluated initializer function `gv$_b`
// ASSERT: scan debug: consteval at testTypeArray.cj:28:1 - testTypeArray.cj:28:41 evaluated initializer function `gv$_c`
// ASSERT: scan debug: consteval at testTypeArray.cj:29:1 - testTypeArray.cj:29:42 evaluated initializer function `gv$_d`
// ASSERT: scan debug: consteval at testTypeArray.cj:30:1 - testTypeArray.cj:30:41 evaluated initializer function `gv$_e`
// ASSERT: scan debug: consteval at testTypeArray.cj:31:1 - testTypeArray.cj:31:42 evaluated initializer function `gv$_f`
// ASSERT: scan debug: consteval at testTypeArray.cj:32:1 - testTypeArray.cj:32:41 evaluated initializer function `gv$_g`
// ASSERT: scan debug: consteval at testTypeArray.cj:33:1 - testTypeArray.cj:33:42 evaluated initializer function `gv$_h`
// ASSERT: scan debug: consteval at testTypeArray.cj:34:1 - testTypeArray.cj:34:50 evaluated initializer function `gv$_i`
// ASSERT: scan debug: consteval at testTypeArray.cj:35:1 - testTypeArray.cj:35:43 evaluated initializer function `gv$_j`
// ASSERT: scan debug: consteval at testTypeArray.cj:36:1 - testTypeArray.cj:36:49 evaluated initializer function `gv$_k`
// ASSERT: scan debug: consteval at testTypeArray.cj:42:1 - testTypeArray.cj:42:52 evaluated initializer function `gv$_first_numbers_when_counting`
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests basic constant evaluation with `Array` type.

const a: VArray<Int8, $3> = [ 1, 2, 3 ]
const b: VArray<UInt8, $3> = [ 1, 2, 3 ]
const c: VArray<Int16, $3> = [ 1, 2, 3 ]
const d: VArray<UInt16, $3> = [ 1, 2, 3 ]
const e: VArray<Int32, $3> = [ 1, 2, 3 ]
const f: VArray<UInt32, $3> = [ 1, 2, 3 ]
const g: VArray<Int64, $3> = [ 1, 2, 3 ]
const h: VArray<UInt64, $3> = [ 1, 2, 3 ]
const i: VArray<Bool, $3> = [ true, false, true ]
const j: VArray<Unit, $3> = [ (), (), () ]
const k: VArray<Rune, $3> = [ r'b', r'a', r't' ]

const func one_two_three(): VArray<Int64, $3> {
  [ 0, 1, 2 ]
}

const first_numbers_when_counting = one_two_three()

main() {}
