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
import std.math.*

let Z_NUM: Float64 = 10.0
let ADD_TIMES: Int64 = 2
let I_NUM: Int64 = 3

class Simulator {
    var aircraft: ArrayList<CallSign> = ArrayList<CallSign>()
    
    init(numAircraft: Int64) {
        for (i in 0..numAircraft) {
            aircraft.add(CallSign("foo" + "${i}"))
        }
    }
    
    func simulate(time: Float64): ArrayList<Aircraft> {
        var frame: ArrayList<Aircraft> = ArrayList<Aircraft>()
        
        for (i in 0..aircraft.size:ADD_TIMES) {
            frame.add(Aircraft(aircraft[i], Vector3D(time, cos(time) * Float64(ADD_TIMES) + Float64(i * I_NUM), Z_NUM)))
            frame.add(Aircraft(aircraft[i + 1], Vector3D(time, sin(time) * Float64(ADD_TIMES) + Float64(i * I_NUM), Z_NUM)))
        }
        
        return frame
    }
}


