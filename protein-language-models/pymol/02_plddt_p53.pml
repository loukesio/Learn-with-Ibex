# 02 · p53 from AlphaFold DB: folded core in blue, disordered tails in orange
@pymol/style.pml
@pymol/plddt.pml
load structures/AF-P04637-F1.pdb, p53
show cartoon, p53
plddt p53
orient p53
zoom p53, 2
ray 1920, 1260
png renders/plddt_p53.png
