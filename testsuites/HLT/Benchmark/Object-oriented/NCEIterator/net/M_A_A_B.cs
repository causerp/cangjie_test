class M_A_A_B : M_A_A
{
    private const ElementKind MethodKind = Method;

    public override ElementKind Kind => MethodKind;

    public override ElementKind KindVerified
    {
        get
        {
            ++CallCount;
            return MethodKind;
        }
    }
}