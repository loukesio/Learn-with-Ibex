# Transthyretin (AlphaFold DB P02766): every ClinVar missense position as a sphere, pathogenic pink, benign teal
@../protein-lm/pymol/style.pml
load data/AF-P02766-F1.pdb, ttr
remove resi 1-20
show cartoon, ttr
color 0xDDE3EA, ttr
@pymol/sel.pml
show spheres, (patho or benign) and name CA
set sphere_scale, 0.9
color 0xE8197F, patho and name CA
color 0x1A8C8F, benign and name CA
set cartoon_transparency, 0.15
orient ttr
turn x, -30
zoom ttr, 1
ray 1920, 1260
png renders/ttr_variants.png
