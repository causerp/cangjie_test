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

import std.convert.*
import std.collection.*
import std.time.*
import std.math.*
import std.regex.*
import std.core.*

class File {
    var fileName: String
    var data: String
    static var directory = HashMap<String, File>()
    init( fileNames: String,  datas: String) {
        fileName = fileNames
        data = datas
        if ( (File.directory.get(fileName).isSome())) {
            print("Creating file named " + "${fileName}" + " that already exists")
            return
        } else {
            File.directory.add(fileName , this)
        }
    }
    static func open( fileName: String) : File {
        return File.directory.get(fileName).getOrThrow()
    }
    func read() : String {
        return data
    }
}
