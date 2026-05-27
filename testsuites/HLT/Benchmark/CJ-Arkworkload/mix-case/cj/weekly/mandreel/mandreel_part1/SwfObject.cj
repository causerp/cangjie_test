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

import std.collection.*

public class CacheItf {
    var size: Int64 = 0
    var url: String = ""
}

public class Param {
    public var func_name: String = ""
    public var param: String = ""
    public var platform: String
    public var width: Int64 = 1024
    public var height: Int64 = 768
    public var antialiasing: Int64 = 0
    public var webglCanvas: String = "canvas"
    public var flashCanvas: String = "FlashDiv"
    public var workingFolderFlash: String = "data/as3/"
    public var workingFolderWebgl: String = "data/js/"
    public var swfFlash: String = "mandreel.swf"
    public var log: Bool = true
    public var mandreelJSCompressed: Bool = true
    public var disable_depth: Bool = true
    public var right_click_enable: Bool = true
    public var swfPreloader: Bool = true
    public var restore_context: Bool = true
    public var cache: CacheItf = CacheItf()

    init(platform: String) {
        this.platform = platform
    }

    func mandreelInit(): Unit {
    }
}

public class SwfObject {
    func hasFlashPlayerVersion(type1: String): Bool {
        return true
    }

    public func getObjectById(type1: String): Param {
        return Param(type1)
    }
}

public let swfObject = SwfObject()
