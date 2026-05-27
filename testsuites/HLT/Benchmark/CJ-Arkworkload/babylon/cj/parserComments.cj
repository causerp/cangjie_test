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

// 定义见 parser.cj
// extend Array<T> {
//     public func splice(start: Int64, deleteCount: Int64) : ArrayList<T> {
//         var deleteItems: ArrayList<T> = ArrayList<T>()
//         for (i in (0..this.size)) {
//             if (i > start && i < deleteCount) {
//                 deleteItems.add(this[i])
//             }
//         }
//         return deleteItems
//     }
    
//     public func slice(start: Int64, end!: ?Int64 = Option<Int64>.None) : ArrayList<T> {
//         if (end.isNone()) {
//             return ArrayList<T>(this.slice(Range(start,this.size-1,1,true,true,true)))
//         }
//         return ArrayList<T>(this.slice(Range(start,end-1,1,true,true,true)))
//     }
// }

