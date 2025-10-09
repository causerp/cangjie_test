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
        System.out.println("run java Main");
        int[] arr0 = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        boolean[] arr1 = {true, false};
        long[] array0 = {666, 666};
        String[] array1 = {"仓颉", "!"};
        CangjieInvoke cjEntryPoint = new CangjieInvoke(arr0, arr1);
        System.out.println(cjEntryPoint.foo(array0, array1));
        System.out.println(cjEntryPoint.goo()[0]);
        System.out.println("hoo:" + CangjieInvoke.hoo(arr0).length);
    }
}