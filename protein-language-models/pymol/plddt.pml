# Colour an AlphaFold/ESMFold model by pLDDT (stored in the B-factor column), AlphaFold DB palette.
# Usage inside PyMOL:  @pymol/plddt.pml   then  plddt <object>
python
from pymol import cmd
def plddt(obj):
    cmd.color("0x0053D6", f"{obj} and b > 90")
    cmd.color("0x65CBF3", f"{obj} and b > 70 and b < 90.01")
    cmd.color("0xFFDB13", f"{obj} and b > 50 and b < 70.01")
    cmd.color("0xFF7D45", f"{obj} and b < 50.01")
cmd.extend("plddt", plddt)
python end
