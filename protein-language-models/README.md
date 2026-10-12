# Protein language models · Instagram carousel

8 square slides (1080×1080) on ESM-2, ESMFold, pLDDT, AlphaFold 2 vs ESMFold, PyMOL basics, and ESM3 / AlphaFold 3.
Every structure image is a real prediction or crystal structure rendered headless with open-source PyMOL.

```
structures/   inputs: AlphaFold DB models (AF-P42212 GFP, AF-P04637 p53, AF-P69905 haemoglobin α, v6),
              ESMFold-P42212.pdb from the ESM Atlas API, PDB 1EMA (GFP crystal structure), P42212.fasta
pymol/        style.pml (shared look), plddt.pml (AlphaFold DB colour bands), 01–06 one script per render, crop.py
renders/      the six PNGs the slides use (1920×1260 ray-traced, then cropped to the molecule)
slides/       slide-01..08.png + caption.txt
```

## Rebuild

```bash
conda create -n pymol -c conda-forge pymol-open-source python=3.11
for s in pymol/0*.pml; do pymol -cq "$s"; done     # renders/*.png
python3 pymol/crop.py                               # trim white margins (needs Pillow)
```

## Data

| Slide | Structure | Source |
|---|---|---|
| 2 | haemoglobin α, rainbow N→C | AlphaFold DB AF-P69905-F1 v6 (mean pLDDT 98) |
| 3 | GFP, ESMFold, coloured by pLDDT | `curl -X POST --data "$SEQ" https://api.esmatlas.com/foldSequence/v1/pdb/` (pLDDT in the B-factor column on a 0–1 scale; `alter esm, b=b*100`) |
| 4 | p53, coloured by pLDDT | AlphaFold DB AF-P04637-F1 v6 (mean 75; 53% of residues ≥ 90, 30% < 50) |
| 5 | GFP, AlphaFold 2 (blue) vs ESMFold (pink) | `align esm, af2` → RMSD 5.035 Å over 1,327 atoms; AF2 mean pLDDT 96.6, ESMFold mean 43 |
| 6 | GFP crystal structure, chromophore (CRO) as sticks | RCSB PDB 1EMA |
| 7 | GFP surface, spectrum on pLDDT 50–100 | AlphaFold DB AF-P42212-F1 v6 |

pLDDT bands and colours follow AlphaFold DB: ≥ 90 #0053D6, 70–90 #65CBF3, 50–70 #FFDB13, < 50 #FF7D45.
Facts on the slides: ESM-2 / ESMFold, Lin et al., Science 2023; ESM3 and esmGFP, Hayes et al., Science 2025 (98B parameters, 58% identity);
AlphaFold 3, Abramson et al., Nature 2024 (non-commercial licence). The ESMFold result for GFP is genuinely low-confidence on the public API; that is the point of slide 5, not an error.
