#!/usr/bin/env bash 

convert app/assets/images/minecraft.svg -bordercolor white -border '20%' -negate -fill 'hsl(155, 90%, 37%)' -opaque '#000000' -colorize 20% -resize 80x80   app/assets/images/apple-touch-icon-80x80.png
convert app/assets/images/minecraft.svg -bordercolor white -border '20%' -negate -fill 'hsl(155, 90%, 37%)' -opaque '#000000' -colorize 20% -resize 152x152 app/assets/images/apple-touch-icon-152x152.png
convert app/assets/images/minecraft.svg -bordercolor white -border '20%' -negate -fill 'hsl(155, 90%, 37%)' -opaque '#000000' -colorize 20% -resize 167x167 app/assets/images/apple-touch-icon-167x167.png
convert app/assets/images/minecraft.svg -bordercolor white -border '20%' -negate -fill 'hsl(155, 90%, 37%)' -opaque '#000000' -colorize 20% -resize 180x180 app/assets/images/apple-touch-icon-180x180.png
