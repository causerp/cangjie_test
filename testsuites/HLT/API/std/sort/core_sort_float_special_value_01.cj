/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC-PIPE: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args

import std.sort.*

func orderedByComparable<T>(data: Array<T>): Bool where T <: Comparable<T> {
    for (i in 1..data.size) {
        if (data[i - 1].compare(data[i]) == Ordering.GT) {
            return false
        }
    }
    return true
}

func countMatches<T>(data: Array<T>, predicate: (T) -> Bool): Int64 {
    var count = 0
    for (value in data) {
        if (predicate(value)) {
            count++
        }
    }
    return count
}

func float16Signature(data: Array<Float16>): Array<Int64> {
    return [
        countMatches(data, {value => value.isNaN()}),
        countMatches(data, {value => value == Float16.Inf}),
        countMatches(data, {value => value == -Float16.Inf}),
        countMatches(data, {value => value.toBits() == UInt16(0)}),
        countMatches(data, {value => value.toBits() == UInt16(0x8000)}),
        countMatches(data, {value => value == -1.0}),
        countMatches(data, {value => value == 1.0})
    ]
}

func float32Signature(data: Array<Float32>): Array<Int64> {
    return [
        countMatches(data, {value => value.isNaN()}),
        countMatches(data, {value => value == Float32.Inf}),
        countMatches(data, {value => value == -Float32.Inf}),
        countMatches(data, {value => value.toBits() == UInt32(0)}),
        countMatches(data, {value => value.toBits() == UInt32(0x80000000)}),
        countMatches(data, {value => value == -1.0}),
        countMatches(data, {value => value == 1.0})
    ]
}

func float64Signature(data: Array<Float64>): Array<Int64> {
    return [
        countMatches(data, {value => value.isNaN()}),
        countMatches(data, {value => value == Float64.Inf}),
        countMatches(data, {value => value == -Float64.Inf}),
        countMatches(data, {value => value.toBits() == UInt64(0)}),
        countMatches(data, {value => value.toBits() == 0x8000000000000000u64}),
        countMatches(data, {value => value == -1.0}),
        countMatches(data, {value => value == 1.0})
    ]
}

main(): Int64 {
    var f16: Array<Float16> = [
        Float16.NaN,
        Float16.Inf,
        -0.0,
        0.0,
        -Float16.Inf,
        1.0,
        -1.0,
        Float16.NaN,
        -0.0,
        0.0
    ]
    var f32: Array<Float32> = [
        Float32.NaN,
        Float32.Inf,
        -0.0,
        0.0,
        -Float32.Inf,
        1.0,
        -1.0,
        Float32.NaN,
        -0.0,
        0.0
    ]
    var f64: Array<Float64> = [
        Float64.NaN,
        Float64.Inf,
        -0.0,
        0.0,
        -Float64.Inf,
        1.0,
        -1.0,
        Float64.NaN,
        -0.0,
        0.0
    ]
    let f16Before = float16Signature(f16)
    let f32Before = float32Signature(f32)
    let f64Before = float64Signature(f64)

    stableSort(f16)
    unstableSort(f32)
    stableSort(f64)

    if (!orderedByComparable(f16) || float16Signature(f16) != f16Before) {
        return 1
    }
    if (!orderedByComparable(f32) || float32Signature(f32) != f32Before) {
        return 2
    }
    if (!orderedByComparable(f64) || float64Signature(f64) != f64Before) {
        return 3
    }
    return 0
}
