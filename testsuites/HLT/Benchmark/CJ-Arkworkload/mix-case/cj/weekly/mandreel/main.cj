/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (LLVM) DEPENDENCE: mandreel_part1/CommonClassFile.cj
// (LLVM) DEPENDENCE: mandreel_part1/Image.cj
// (LLVM) DEPENDENCE: mandreel_part1/ImandreelCtxCanvas.cj
// (LLVM) DEPENDENCE: mandreel_part1/LZMA.cj
// (LLVM) DEPENDENCE: mandreel_part1/MandreelDocument.cj
// (LLVM) DEPENDENCE: mandreel_part1/MandreelElement.cj
// (LLVM) DEPENDENCE: mandreel_part1/MandreelTex.cj
// (LLVM) DEPENDENCE: mandreel_part1/MandreelWindow.cj
// (LLVM) DEPENDENCE: mandreel_part1/MouseEvent.cj
// (LLVM) DEPENDENCE: mandreel_part1/SwfObject.cj
// (LLVM) DEPENDENCE: commonFile.cj  mandreel.cj mandreelFile11.cj  mandreelFile13.cj  mandreelFile15.cj  mandreelFile2.cj  mandreelFile4.cj  mandreelFile6.cj  mandreelFile8.cj
// (LLVM) DEPENDENCE: mandreelFile10.cj  mandreelFile12.cj  mandreelFile14.cj  mandreelFile1.cj   mandreelFile3.cj  mandreelFile5.cj  mandreelFile7.cj  mandreelFile9.cj
// (LLVM) EXEC: %compiler %cmp_opt %optimization_level_2 --no-sub-pkg --apc *.cj -o %output
// (LLVM) RUN-EXEC: %export cjHeapSize=512mb && %run %run_opt %output %run_args 2>&1 | compare %f
// (LLVM) ASSERT: scan ms
// (LLVM) TIMEOUT: 1800


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

import std.time.*
import std.collection.*
import std.math.*

class Benchmark {
    public static func runIteration() : Unit {
        let start = DateTime.now()
        setupMandreel()
        for (_ in 0..1) {
            runMandreel();
        }
        let end = DateTime.now()
        println("mandreel: ms = ${Float64((end-start).toNanoseconds())/1000000.0}")
    }
}


class Timer {
   
    func getTime(): Float64 {
        let time = DateTime.now()
        return Float64(time.second) * 1000000.0 + Float64(time.nanosecond)/ 1000.0
    }
}

main() {
    Benchmark.runIteration()
}

