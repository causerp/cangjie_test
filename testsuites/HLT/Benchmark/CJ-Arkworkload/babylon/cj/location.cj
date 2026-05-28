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

func getLineInfo(aInput: String, offset: Int64) : Position0 {
    var line: Int64 = 1
    var cur: Int64 = 0
    let _match = lineBreakG.matcher(aInput)
    var flag: Bool = true
    var matchdata = _match.find()
    while (flag) {
        var matchdata = _match.find()
        if (matchdata.isNone()) {
            flag = false
            break
        }
        cur = matchdata.getOrThrow().matchPosition().start
        if (cur >= offset) {
            break
        }
        line++
    }
    let column = offset - cur
    return Position0(line, column)
}

public class Position0 {
    var line: Int64
    var col: Int64
    
    init(line: Int64, col: Int64) {
        this.line = line
        this.col = col
    }
}

public class SourceLocation {
    var start: ?Position0
    var end: ?Position0 = Option<Position0>.None
    var fileName: String = ""
    var identifierName: ?String = Option<String>.None
    
    init(start: ?Position0, end!: ?Position0 = Option<Position0>.None) {
        this.start = start
        this.end = end
    }
}
