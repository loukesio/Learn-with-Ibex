# 01 · ESMFold prediction of GFP (ESM Atlas API), coloured by pLDDT
@pymol/style.pml
@pymol/plddt.pml
load structures/ESMFold-P42212.pdb, esm
alter esm, b = b * 100        # ESM Atlas writes pLDDT on a 0-1 scale; AlphaFold uses 0-100
show cartoon, esm
plddt esm
orient esm
turn y, -30
zoom esm, 2
ray 1920, 1260
png renders/esmfold_gfp.png
