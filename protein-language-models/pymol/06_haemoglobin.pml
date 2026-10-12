# 06 · Haemoglobin alpha from AlphaFold DB (pLDDT 98), rainbow from N to C terminus
@pymol/style.pml
load structures/AF-P69905-F1.pdb, hba
show cartoon, hba
spectrum count, rainbow, hba and name CA
orient hba
zoom hba, 2
ray 1920, 1260
png renders/rainbow_hba.png
