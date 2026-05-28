interface M_A : A
{
    ElementKind Kind { get; }
    ElementKind KindVerified { get; }
    bool Cascading { get; }
    bool CascadingVerified { get; }
    bool Constrained { get; }
    bool ConstrainedVerified { get; }
}