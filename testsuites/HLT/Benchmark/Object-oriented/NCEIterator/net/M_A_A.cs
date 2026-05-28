abstract class M_A_A : M_A
{
    protected M_A_A()
    {
        switch (Cascading)
        {
            case true when _constrained:
                CheckableCount++;
                break;
            case false:
                NonCascadingCount++;
                break;
        }
    }

    public abstract ElementKind Kind { get; }
    public abstract ElementKind KindVerified { get; }

    public bool Cascading { get; } = Random.Shared.NextBoolean();

    public bool CascadingVerified
    {
        get
        {
            ++CallCount;
            return Cascading;
        }
    }

    private readonly bool _constrained = Random.Shared.NextBoolean();

    public virtual bool Constrained => _constrained;

    public virtual bool ConstrainedVerified
    {
        get
        {
            ++CallCount;
            return _constrained;
        }
    }
}