# Heegner computation trigger

This draft branch runs eight exact generator searches for the `(p,q)=(43,71)` perfect-cuboid frontier:

1. PARI `ellheegner` on the original minimal curve;
2. deeper mwrank 2-descent;
3. a fixed Heegner discriminant `D=-50231`;
4. PARI `ellheegner` independently on all four curves in the 2-isogeny class.
