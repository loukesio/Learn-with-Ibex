# 05 · Same protein, surface view: the barrel seen from outside
@pymol/style.pml
load structures/AF-P42212-F1.pdb, gfp
show surface, gfp
set transparency, 0.0
spectrum b, orange_yellow_cyan_blue, gfp, minimum=50, maximum=100
orient gfp
turn y, 60
zoom gfp, 2
ray 1920, 1260
png renders/surface_gfp.png
