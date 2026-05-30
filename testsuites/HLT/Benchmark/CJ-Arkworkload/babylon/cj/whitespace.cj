/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import std.regex.*

let lineBreak = Regex("\\r\\n?|\\n|\u{2028}|\u{2029}")

let lineBreakG = lineBreak

// 仓颉暂不支持 Unicode 正则

let nonASCIIwhitespace =["\u{1680}","\u{180e}","\u{2000}","\u{2001}","\u{2002}","\u{2003}","\u{2004}","\u{2005}","\u{2006}","\u{2007}","\u{2008}","\u{2009}","\u{200a}","\u{202f}","\u{205f}","\u{3000}","\u{feff}"]
