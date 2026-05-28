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
public interface B2QueryWrapper {
    public func queryCallback(proxyId: Int64) : Bool
}

public interface B2RayCastWrapper {
    public func rayCastCallback(input: B2RayCastInput, proxyId: Int64) : Float64
}

public interface B2BroadPhaseWrapper {
    public func addPair(proxyUserDataA: B2FixtureProxy, proxyUserDataB: B2FixtureProxy):Unit{}
}
