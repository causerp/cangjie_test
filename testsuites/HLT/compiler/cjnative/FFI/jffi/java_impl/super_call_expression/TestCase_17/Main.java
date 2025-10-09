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
            1L,
            new double[114514],
            (char) 1,
            (char) 1,
            new int[114514],
            new short[114514],
            "hello",
            new double[114514],
            new long[114514],
            114.514000D);
    System.out.println("hello");
  }
}
