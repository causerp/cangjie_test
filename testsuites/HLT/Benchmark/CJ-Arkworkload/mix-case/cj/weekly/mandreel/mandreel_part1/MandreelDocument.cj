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

public class MandreelDocument {
    var fullscreenEnabled: Bool = true
    var movieName: String = ""

    func createElement(element_type: String) : MandreelElement {
        let element = MandreelElement(element_type)
        element.parentNode = MandreelElement("dummy_parent")
        return element
    }
    
    public func getElementById(name: String) : ?MandreelBase {
        if (name == "canvas") {
            return MandreelCanvas()
        } else if (name == "canvasDiv") {
            return MandreelCanvasDiv()
        } else {
            return Option<MandreelBase>.None
        }
    }
    
   func getElementsByTagName(element: String) : ArrayList<MandreelElement> {
        if (element == "script") {
            return ArrayList<MandreelElement>.of(this.createElement(element))
        } else {
            return ArrayList<MandreelElement>()
        }
    }
    
}

public var mandreelDocument = MandreelDocument()
