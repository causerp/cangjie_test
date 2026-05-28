class M_A_A_A : M_A_A
{
    public override ElementKind Kind => Bean;

    public override ElementKind KindVerified
    {
        get
        {
            ++CallCount;
            return Bean;
        }
    }
}