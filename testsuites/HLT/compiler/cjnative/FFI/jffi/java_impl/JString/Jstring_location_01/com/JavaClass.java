/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package com;

public class JavaClass{
    public String str = "JavaClass str";

    public JavaClass() {
        System.out.println("in JavaClass Init");
    }
    public String loaction_return() {
        System.out.println("in JavaClass loaction_return");
        return "JavaClass loaction_return";
    }
    public void loaction_param(String param) {
        System.out.println("in JavaClass loaction_param:" + param);
    }

}