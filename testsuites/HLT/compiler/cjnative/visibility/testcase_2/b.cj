package a

private enum A<T0, T1, T2> {
    | AA
}

public class B {
    private let a = A<Int64, Bool, String>.AA
}
