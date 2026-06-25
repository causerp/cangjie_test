// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (Linux and CJNATIVE) DEPENDENCE: dep.cj m_pkg.cj
// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt %compile_lib_opt --lto=full dep.cj -o dep.bc
// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt m_pkg.cj dep.bc --lto=full %cmp_macro
// (Linux and CJNATIVE) EXEC-0: test -f lib-macro_m_pkg.so
// (Linux and CJNATIVE) EXEC-1: test -f lib-macro_dep.so

package tmp_test

main(): Int64 {
    return 0
}
