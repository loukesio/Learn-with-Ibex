# How a neural network learns · Instagram carousel

9 square slides (1080×1080); slides 2 and 6 are videos (`output/slide-02.mp4`: the network diagram per epoch; `output/slide-06.mp4`: decision boundary + loss per epoch; 18 s each, 4 frames per second) with `slide-02.png` / `slide-06.png` as stills.
The network is written in base R with no packages (`R/00_net.R`): 2 → 16 (tanh) → 1 (sigmoid), binary cross-entropy, mini-batch gradient descent,
so every number on the slides comes from code you can read in a minute.

```
R/            00_net.R (the network + training loop + plotting helpers), net_draw.R (the dark neon network drawing), 01–07 one script per figure, render_all.R, theme_seq.R
plots/        the six figures + run.rds (weights after every epoch) + overfit.rds
slides/       slide-01..09.png, slide-02.mp4, slide-06.mp4, caption.txt
```


## The run

| | |
|---|---|
| Data | two interleaving half-moons, noise 0.18: 200 training, 100 validation, 100 test points |
| Network | 2 inputs, 16 hidden tanh neurons, 1 sigmoid output: 48 weights + 17 biases = 65 parameters |
| Training | 60 epochs, batch 20 (10 updates per epoch), learning rate 0.5, seed 42 |
| Result | epoch 0: loss 0.65, accuracy 63% · epoch 60: loss 0.08, train 97%, validation 94%, test 99% (1 of 100 wrong) |
| Learning rate slide | same setup with lr 0.02 / 0.5 / 5 |
| Overfitting slide | 40 training points with noise 0.3, 64 hidden neurons, lr 0.3, batch 10, 600 epochs; validation loss lowest at epoch 49 (0.24), 0.73 at epoch 600 |

Instagram carousels accept video slides (MP4, ≤ 60 s) next to images; GIFs are not accepted. The first slide sets the crop, so the video is square like the rest.
