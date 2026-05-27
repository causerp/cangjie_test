class N_A_A_A : N_A_A
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