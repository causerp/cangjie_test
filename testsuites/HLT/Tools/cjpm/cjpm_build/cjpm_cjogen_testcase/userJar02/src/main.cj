/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package test

internal import java8.java.lang.Math as JMath

main() {
    // static field
    println("E = ${JMath.E}") // E = 2.718282
    println("PI = ${JMath.PI}") // PI = 3.141593

    // static method
    println("max(1, 3) = ${JMath.max(1, 3)}")
    println("min(3, 1) = ${JMath.min(3, 1)}")
}
