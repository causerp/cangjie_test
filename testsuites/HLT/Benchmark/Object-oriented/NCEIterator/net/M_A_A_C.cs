class M_A_A_C : M_A_A
{
    public override ElementKind Kind => Property;

    public override ElementKind KindVerified
    {
        get
        {
            ++CallCount;
            return Property;
        }
    }
}