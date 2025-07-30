// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-1: %compiler %cmp_opt %f -o %output
// Was ICE, should quit normally

@Differentiable
func foo(x:Float64,y:Float64){
    return x * y
}

class A{
    public func goo(x:Float64, y:Float = {
        let valWithGrad_res = @ValWithGrad(foo,x,y)
        let (foo_res, foo_grad) = valWithGrad_res
        return (foo_res, foo_grad)
    }
}


main(){
    return 0
}

