package a

private interface A {}

public class AC <: A {}

public class C {
    private let a = AC()
}

main(): Unit {
}
