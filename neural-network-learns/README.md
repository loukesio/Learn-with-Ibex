# How a neural network learns · Instagram carousel

9 square slides (1080×1080); slides 2 and 6 are videos (`output/slide-02.mp4`: the network diagram per epoch; `output/slide-06.mp4`: decision boundary + loss per epoch; 18 s each, 4 frames per second) with `slide-02.png` / `slide-06.png` as stills.
The task: is a DNA variant disease-causing? Four features per variant (allele frequency, conservation, protein impact, splice distance) go in, one probability comes out.
The variants are simulated with a rule that mimics real genetics (rare + conserved + damaging = pathogenic), so the labels are known and the network has to rediscover the rule.
The network is base R with no packages (`R/00_net.R`): 4 → 8 (tanh) → 1 (sigmoid), binary cross-entropy, mini-batch gradient descent.

```
R/            00_net.R (the network + training loop + plotting helpers), net_draw.R (the dark neon network drawing), 01–07 one script per figure, render_all.R, theme_seq.R
plots/        the six figures + run.rds (weights after every epoch) + overfit.rds
slides/       slide-01..09.png, slide-02.mp4, slide-06.mp4, caption.txt
```


## The run

| | |
|---|---|
| Data | simulated variants: 200 training, 100 validation, 100 test; features log10(allele frequency), conservation, protein impact, log10(splice distance), standardised |
| Network | 4 inputs, 8 hidden tanh neurons, 1 sigmoid output: 40 weights + 9 biases = 49 parameters |
| Training | 60 epochs, batch 20 (10 updates per epoch), learning rate 0.5, seed 42 |
| Result | epoch 0: loss 0.78, accuracy 52% · epoch 60: loss 0.13, train 95%, validation 90%, test 92% (8 of 100 wrong: 5 false alarms, 3 misses) |
| Learning rate slide | same setup with lr 0.02 / 0.5 / 5 |
| Overfitting slide | 40 training variants, 32 hidden neurons, lr 0.05, batch 10, 600 epochs; validation loss lowest at epoch 25 (0.27), 0.50 at epoch 600 |

Instagram carousels accept video slides (MP4, ≤ 60 s) next to images; GIFs are not accepted. The first slide sets the crop, so the video is square like the rest.
