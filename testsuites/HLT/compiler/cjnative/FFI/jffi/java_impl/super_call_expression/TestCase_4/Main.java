/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package java_entry;

import UNNAMED.ChildClass;

public class Main {
  public static void main(String[] args) {
    final ChildClass childClass =
        new ChildClass(
            (byte) 1,
            new byte[114514],
            1,
            new int[114514],
            new float[114514],
            new double[114514],
            new float[114514],
            1L,
            114.514000F,
            new float[114514]);
    System.out.println("hello");
  }
}
