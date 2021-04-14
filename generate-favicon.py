#!/usr/bin/env python3

import os
import sys

from PIL import Image


if len(sys.argv) > 0:
    filename = sys.argv[1]
    with Image.open(filename) as img:
        icon_sizes = [(16,16), (32, 32), (48, 48), (64,64)]
        img.save('favicon.ico', sizes = icon_sizes)

