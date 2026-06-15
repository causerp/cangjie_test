// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package m_pkg

internal import std.ast.*
import dep.*

public macro M(attr: Tokens, input: Tokens): Tokens {
    return quote()
}
