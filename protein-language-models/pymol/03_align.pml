# 03 · ESMFold vs AlphaFold 2 for the same sequence: superpose and measure RMSD
@pymol/style.pml
load structures/AF-P42212-F1.pdb, af2
load structures/ESMFold-P42212.pdb, esm
show cartoon
color 0x2E7DBE, af2
color 0xE8197F, esm
align esm, af2
orient af2
turn y, -30
zoom af2, 2
set cartoon_transparency, 0.25, esm
ray 1920, 1260
png renders/align_gfp.png
