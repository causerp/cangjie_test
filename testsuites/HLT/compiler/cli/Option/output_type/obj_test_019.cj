// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: foo.cj
// EXEC: %compiler %cmp_opt foo.cj --output-type=obj --compile-target=staticlib --experimental
// EXEC-PIPE-0: %compiler %cmp_opt foo.%object_file_suffix -lcangjie-std-core --output-type=staticlib --experimental -o %output


import foo.*

main(): Int64 {
    test()
}
