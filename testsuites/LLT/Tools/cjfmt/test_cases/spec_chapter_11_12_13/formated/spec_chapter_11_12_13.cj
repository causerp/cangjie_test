// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// src/b/b.cj
package a.b

import {std.time, std.fs as fileSystem, std.io.*}

main() {
    try {
        throw ArithmeticException()
    } catch (e: Exception) { // Caught.
        print("Exception and its subtypes can be caught here")
    }

    var a = 1

    func throwE() {
        if (a == 1) {
            ChildOne()
        } else {
            ChildTwo()
        }
    }

    try {
        throwE()
    } catch (e: ChildOne | ChildTwo) {
        e.whatFather() // ok: e is an object of Father

        //e.whatChildOne() // error: e is an object of Father
        //e.whatChild() // error: e is an object of Father
        print(e.father) // ok: e is an object of Father
        //print(e.childOne) // error: e is an object of Father
        //print(e.childOTwo) // error: e is an object of Father
    }

    // Catch with exceptionTypePattern.
    try {
        throw IndexOutOfBoundsException()
    } catch (e: ArithmeticException | IndexOutOfBoundsException) {
        print("exception info: " + e.toString())
    } catch (e: Exception) {
        print("neither ArithmeticException nor IndexOutOfBoundsException, exception info: " + e.toString())
    } finally {
        print("the finally block is executed")
    }
    return 0
}

// Case 1
foreign func free(ptr: CPointer<Int8>): Unit

// Case 2
@C
func callableInC(ptr: CPointer<Int8>) {
    print("This function is defined in Cangjie.")
}

// Case 3
let f1: CFunc<(CPointer<Int8>) -> Unit> = {
    ptr => print("This function is defined with CFunc lambda.")
}

foreign func atexit(cb: CFunc<() -> Unit>): Unit

main() {
    var ptr = CPointer<Int8>()
    var f = CFunc<() -> Unit>(ptr)
    unsafe {
        f()
    } // core dumped when running, because the pointer is nullptr.
}

// CFunc 的参数和返回类型不允许依赖外部的泛型参数。
func call<T>(f: CFunc<(T) -> Unit>, x: T) where T <: CType { // error
    unsafe {
        f(x)
    }
}

func f<T>(x: T) where T <: CType {
    let g: CFunc<(T) -> T> = {x: T => x} // error
}

class A<T> where T <: CType {
    let x: CFunc<(T) -> Unit> // error
}

func try1() {
    // Catch with wildcardPattern.
    let arrayTest: Array<Int64> = Array<Int64>([0, 1, 2])

    try {
        let lastElement = arrayTest[3]
    } catch (_) {
        print("catch an exception!")
    }
}

class MyResource <: Resource {
    var flag = false

    public func isClosed() {
        flag
    }

    public func close() {
        flag = true
    }

    public func hasNextLine() {
        false
    }
    public func readLine() {
        "line"
    }

    public func writeLine(_: String) {}
}

main() {
    try (input = MyResource(), output = MyResource()) {
        while (input.hasNextLine()) {
            let lineString = input.readLine()
            output.writeLine(lineString)
        }
    } catch (e: Exception) {
        print("Exception happened when executing the try-with-resources expression")
    } finally {
        print("end of the try-with-resources expression")
    }

    try {
        var freshExc = None<Exception> // A fresh variable that could store any exceptions
        let input = MyResource()

        try {
            var freshExc = None<Exception>
            let output = MyResource()
            try {
                while (input.hasNextLine()) {
                    let lineString = input.readLine()
                    output.writeLine(lineString)
                }
            } catch (e: Exception) {
                freshExc = e
            } finally {
                try {
                    if (!output.isClosed()) {
                        output.close()
                    }
                } catch (e: Exception) {
                    match (freshExc) {
                        case Some(v) => throw v // Exception raised from the user code will be thrown
                        case None => throw e
                    }
                }

                match (freshExc) {
                    case Some(v) => throw v
                    case None => ()
                }
            }
        } catch (e: Exception) {
            freshExc = e
        } finally {
            try {
                if (!input.isClosed()) {
                    input.close()
                }
            } catch (e: Exception) {
                match (freshExc) {
                    case Some(v) => throw v
                    case None => throw e
                }
            }
            match (freshExc) {
                case Some(v) => throw v
                case None => ()
            }
        }
    } catch (e: Exception) {
        print("Exception happened when executing the try-with-resources expression")
    } finally {
        print("end of the try-with-resources expression")
    }
}

func throw1() {
    // Catch with exceptionTypePattern.
    let listTest = [0, 1, 2]

    try {
        throw ArithmeticException()
        let temp = listTest[0] + 1 // Will never be executed.
    } catch (e: ArithmeticException) {
        print("an arithmeticException happened: " + e.toString())
    } finally {
        print("the finally block is executed")
    }
}

// Caught by catchE().
func catchE() {
    let listTest = [0, 1, 2]

    try {
        throwE() // caught by catchE()
    } catch (e: IndexOutOfBoundsException) {
        print("an IndexOutOfBoundsException happened: " + e.toString())
    }
}

// Terminate function is executed.
func notCatchE() {
    let listTest = [0, 1, 2]
    throwE()
}

// func throwE()
func throwE() {
    throw IndexOutOfBoundsException()
}

// 13.1.2.3 inout 参数
foreign func foo1(ptr: CPointer<Int32>): Unit

@C
func foo2(ptr: CPointer<Int32>): Unit {
    let n = unsafe { ptr.read() }
    println("*ptr = ${n}")
}

let foo3: CFunc<(CPointer<Int32>) -> Unit> = {
    ptr =>
    let n = unsafe { ptr.read() }
    println("*ptr = ${n}")
}

struct Data {
    var n: Int32 = 0
}

class A {
    var data = Data()
}

main() {
    var n: Int32 = 0

    unsafe {
        foo1(inout n) // OK
        foo2(inout n) // OK
        foo3(inout n) // OK
    }

    var data = Data()
    var a = A()

    unsafe {
        foo1(inout data.n) // OK
        foo1(inout a.data.n) // Error, n is derived indirectly from instance member variables of class A
    }
}

// 13.1.2.4 调用约定
@CallingConv[CDECL] // Can be omitted in default.
foreign func clock(): Int32

main() {
    println(clock())
}

// 在仓颉编程语言中调用 add 函数，代码示例如下：
foreign func add(x: Int64, y: Int64): Int64

main() {
    let x1: Int64 = 42
    let y1: Int64 = 42
    var ret1 = unsafe {
        add(x1, y1)
    }
}

// CPointer 可以使用类型名构造一个实例，它的值对应 C 语言的 NULL。
func test() {
    let p = CPointer<Int64>()
    let r1 = p.isNull() // r1 == true
}

// 仓颉支持使用 CFunc 类型的变量作为参数，构造出 CPointer 类型的变量，其中 CPointer 的泛型参数
// T 可以是满足 CType 约束的任意类型。使用方式如下：
foreign func rand(): Int32

main() {
    var ptr = CPointer<Int8>(rand)
    0
}

unsafe func acquireArrayRawData<T>(arr: Array<T>): CPointerHandle<T> where T <: CType {}

unsafe func releaseArrayRawData<T>(h: CPointerHandle<T>): Unit where T <: CType {}

struct CPointerHandle<T> {
    let pointer: CPointer<T>
    let array: Array<T>
}

// 参考如下示例，假设我们要把一个 Array<UInt8> 写入到文件中，可以这样做：
foreign func fwrite(buf: CPointer<UInt8>, size: UIntNative, count: UIntNative, stream: CPointer<Unit>): UIntNative

func writeFile(buffer: Array<UInt8>, file: CPointer<Unit>) {
    unsafe {
        let h = acquireArrayRawData(buffer)
        fwrite(h.pointer, 1, buffer.size, file)
        releaseArrayRawData(h)
    }
}

@C
struct Point2D {
    var x: Float32
    var y: Float32
}

@C
struct S {
    var a: VArray<Int32, $2> = VArray<Int32, $2>(item: 0)
    var b: VArray<Int32, $0> = VArray<Int32, $0>(item: 0)
}

@Java
public class CJClass {
    public func foo(str: JString): Unit {
        // do something
    }
}

@Java
class JStrExample {
    var a: String = "Cangjie string" // compiler error
    var b: JString = J"JString" // Single line literal
}

main() {
    try {
        var s = J"abc"
        var n = Integer.parseInt(s) // It will throw exception.
        let array = JArray<Int64>([0, 1, 2, 3, 4, 5])
        var el = array[n]
    } catch (e: JavaException) {
        var cause: Throwable = e.getCause()
        match (cause) {
            case _: NumberFormatException => print("Wrong parseInt input!")
            case _: ArrayIndexOutOfBoundsException => print("Out of Bounds!")
            case _ => ()
        }
    }
}

main() {
    var arrayList = JArrayList<Integer>()
    arrayList.add(Integer(1))
    arrayList.add(Integer(3))
    arrayList.add(Integer(5))
    var iter = arrayList.iterator()
    while (iter.hasNext()) {
        iter.next().toString()
    }
}

main() {
    var obj = RawTypeExample()
    let a: ?C0<JObject> = obj.a // ok
    let b: ?C1<JNumber> = obj.b // ok
    let c = obj.c // compile error
    let d = obj.createC2() // compile error
}

// pure cangjie class
class CangjieClass {
    @JavaAnno[J"value"] // compile error, annotation types from java can only be used in @Java-modified types.
    func a(): Unit {}
}

@Java
class JavaClass {
    @JavaAnno[J"value"] // OK
    func a(): Unit {}
}
