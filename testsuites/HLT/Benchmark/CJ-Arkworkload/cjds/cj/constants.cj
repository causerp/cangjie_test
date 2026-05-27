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

let MAX_VALUE: Float64 = 1000.0
let MAX_Z_VALUE: Float64 = 10.0
let SIZE_DOUBLE: Float64 = 2.0

class Constants {
    static let MIN_X: Float64 = 0.0
    static let MIN_Y: Float64 = 0.0
    static let MAX_X: Float64 = MAX_VALUE
    static let MAX_Y: Float64 = MAX_VALUE
    static let MIN_Z: Float64 = 0.0
    static let MAX_Z: Float64 = MAX_Z_VALUE
    static let PROXIMITY_RADIUS: Float64 = 1.0
    static let GOOD_VOXEL_SIZE: Float64 = Constants.PROXIMITY_RADIUS * SIZE_DOUBLE
}

