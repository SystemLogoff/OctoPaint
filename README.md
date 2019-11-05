# OctoPaint
 Quick and Lazy Image Converter for Chip8/Octo Games

## Guide
Run the OctoPaint.love file though Love2D.

Drag an image on top of the window.

Hit ```C``` to convert the image.

Paste it into your Chip8/Octo game.

### Love2D Links
* 32 Bit Windows Love2d - https://bitbucket.org/rude/love/downloads/love-11.3-win32.zip
* 64 Bit Windows Love2d - https://bitbucket.org/rude/love/downloads/love-11.3-win64.zip
* Mac x64 Love2d - https://bitbucket.org/rude/love/downloads/love-11.3-macos.zip
* Linux x64/x86 AppImage Love2d - https://bitbucket.org/rude/love/downloads/love-11.3-x86_64.AppImage

## Standard Size Viewer (64x32)
http://johnearnest.github.io/Octo/index.html?key=cbyaycJC
```
: main
v1 := 0
v2 := 0
v3 := 8
i := tile_0
loop
loop
sprite v1 v2 8
i += v3
v1 += 8
while v1 != 64 again
v2 += 8
v1 := 0
while v2 != 32 again

return
: tile_0
# Converted Image Here
```
http://johnearnest.github.io/Octo/index.html?key=iuqs0Cfm
## Superchip Size Viewer (128x64)
```
: main
v1 := 0
v2 := 0
v3 := 8
i := tile_0
hires
loop
loop
sprite v1 v2 8
i += v3
v1 += 8
while v1 != 128 again
v2 += 8
v1 := 0
while v2 != 64 again

return
: tile_0
# Converted Image Here
```
