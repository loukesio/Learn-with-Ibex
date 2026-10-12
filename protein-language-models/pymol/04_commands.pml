# 04 · The five PyMOL commands every structure needs: load, show, color, select, png
@pymol/style.pml
load structures/1EMA.pdb, gfp
remove solvent
show cartoon, gfp
color 0xA8CF6A, gfp
select chromo, resn CRO
show sticks, chromo
color 0xE8197F, chromo and elem C
set cartoon_transparency, 0.35, gfp
orient gfp
turn x, -20
zoom gfp, 2
ray 1920, 1260
png renders/gfp_chromophore.png
