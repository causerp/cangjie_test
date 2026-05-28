abstract class N
{
    protected readonly bool IsMarkedValue = Random.Shared.NextBoolean();

    public virtual bool IsMarked => IsMarkedValue;

    public virtual bool IsMarkedVerified
    {
        get
        {
            CallCount++;
            return IsMarkedValue;
        }
    }
}