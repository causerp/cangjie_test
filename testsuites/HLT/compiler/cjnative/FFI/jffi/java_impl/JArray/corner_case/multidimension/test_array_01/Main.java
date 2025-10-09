/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package com.java.app;

import UNNAMED.CangjieInvoke;

public class Main {
    public static void main(String[] args) {
        System.out.println("run java");
        int[][] arr = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
        CangjieInvoke cjEntryPoint = new CangjieInvoke(arr);
        System.out.println("aInt.length: " + cjEntryPoint.aInt.length);
        System.out.println("arr[2][2]: " + cjEntryPoint.aInt[2][2]);
    }
}