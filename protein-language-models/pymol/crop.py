# Trim the white margins of every render to the molecule (plus padding) so it fills the slide card.
import sys, pathlib
from PIL import Image, ImageChops
for f in pathlib.Path('renders').glob('*.png'):
    im = Image.open(f).convert('RGB')
    bg = Image.new('RGB', im.size, (255, 255, 255))
    box = ImageChops.difference(im, bg).convert('L').point(lambda v: 255 if v > 8 else 0).getbbox()
    if not box: continue
    pad = 40; l, t, r, b = box
    l, t, r, b = max(l - pad, 0), max(t - pad, 0), min(r + pad, im.width), min(b + pad, im.height)
    # keep a 3:2 frame around the content so every card gets the same shape
    w, h = r - l, b - t; cx, cy = (l + r) / 2, (t + b) / 2
    if w / h < 1.5: w = h * 1.5
    else: h = w / 1.5
    canvas = Image.new('RGB', (int(w), int(h)), (255, 255, 255))
    crop = im.crop((l, t, r, b)); canvas.paste(crop, (int((w - crop.width) / 2), int((h - crop.height) / 2)))
    canvas.save(f); print(f.name, canvas.size)
