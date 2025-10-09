/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package com;

public class JavaClass implements I1{
    public JavaClass() {
        System.out.println("in JavaClass Init");
    }

    public static int bar() {
        System.out.println("in JavaClass bar");
        return 2;
    }
}