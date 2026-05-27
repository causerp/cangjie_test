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

public class MandreelWindow {
    var Float64Array: ArrayList<Float64> = ArrayList<Float64>()
    var Float32Array: ArrayList<Float32> = ArrayList<Float32>()
    var Int32Array: ArrayList<Int32> = ArrayList<Int32>()
    var Uint32Array: ArrayList<UInt32> = ArrayList<UInt32>()
    var Int16Array: ArrayList<Int16> = ArrayList<Int16>()
    var Uint16Array: ArrayList<UInt16> = ArrayList<UInt16>()
    var Int8Array: ArrayList<Int8> = ArrayList<Int8>()
    var Uint8Array: ArrayList<UInt8> = ArrayList<UInt8>()
    var MozBlobBuilder: Int64 = 0
    var WebKitBlobBuilder: Int64 = 0
    var BlobBuilder: Int64 = 0
    var requestFileSystem: Int64 = 0
    var webkitRequestFileSystem: Int64 = 0
    public var indexedDB: Int64 = 0
    var webkitIndexedDB: Int64 = 0
    var mozIndexedDB: Int64 = 0
    var dump: String = ""
    var method: String = ""
    var PERSISTENT: String = ""
    var IDBTransaction: ?String = Option<String>.None
    var webkitIDBTransaction: ?String = Option<String>.None
    var IDBKeyRange: ?String = Option<String>.None
    var webkitIDBKeyRange: ?String = Option<String>.None
    var document: MandreelDocument = MandreelDocument()
    var localStorage:?GetItemARR = Option<GetItemARR>.None
}

public let mandreelWindow = MandreelWindow()

class GetItemARR {
   func getItem(fun: ?String) : ?String {
     return fun
   }

  func removeItem(fun: String) : Unit {

  }

  func setItem(key: String, value: String) : Unit {
  }
}

