SVG images can be edited in inkscape, cleaned up using scour.py from 
http://www.coderead.com/scour, and converted with ImageMagick's convert.
$ convert -background None wxlualogo.svg -resize 128x128 wxlualogo.png/xpm
The xpm then needs to be changed so it's const char* and
the variable name changed to "image_xpm" by appending "_xpm" to it.

OSX bundle .icns can be made using makeicns from
http://amnoid.de/icns/makeicns.html 
Use ImageMagick's convert to make a 512x512 icon then run
$ makeicns-1.1/makeicns -in wxlualogo-512.png -out wxlualogo.icns
to get a .icns file with 512, 256, 128, 32, and 16 pixel icons to
use in the app bundle.
