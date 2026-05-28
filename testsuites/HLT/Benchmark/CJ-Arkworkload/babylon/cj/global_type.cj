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

public class ParserError <: Exception {

    var pos: ?Int64
    
    var loc: Position0
    
    var message0: String

    init(pos: ?Int64, loc: Position0, message0: String) {
        this.pos = pos
        this.loc = loc
        this.message0 = message0
    }
    
}

public class SyntaxError <: Exception {
    
}

public class RegConfig {

    var pattern: String
    
    var flags: String
    
    var value: ?Any = Option<Any>.None // string | number | RegConfig | boolean | null = null
    
    init(pattern: String, flags: String) {
        this.pattern = pattern
        this.flags = flags
    }

}

public class Comment {

    var _type: String
    
    var value: String
    
    var start: Int64
    
    var end: Int64
    
    var loc: SourceLocation
    
    init(_type: String, value: String, start: Int, end: Int, loc: SourceLocation) {
        this._type = _type
        this.value = value
        this.start = start
        this.end = end
        this.loc = loc
    }

}

public class Label {

    static let loopLabel = Label("loop")
    
    static let switchLabel = Label("switch")
    
    var kind: String
    
    var name: ?String = Option<String>.None
    
    var statementStart: ?Int64 = Option<Int64>.None
    
    static func `init`(kind: String, name: String, statementStart: Int64): Label {
        let lab = Label(kind)
        lab.name = name
        lab.statementStart = statementStart
        return lab
    }
    
    init(kind: String) {
        this.kind = kind
    }

}
