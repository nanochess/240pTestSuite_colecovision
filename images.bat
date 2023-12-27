@echo off
tmscolor -c1 -t80 bars1.bmp bars1.dat
tmscolor -c1 -tc0 bars2.bmp bars2.dat
tmscolor -c1 circles.bmp circles.dat
pletter circles.dat 0 6144 circles0.bin
tmscolor -c1 sharpness.bmp sharpness.dat
pletter sharpness.dat 0 6144 sharpness0.bin
pletter sharpness.dat 6144 6144 sharpness1.bin
tmscolor -c1 -m title.bmp title.dat
pletter title.dat 0 6144 title0.bin
pletter title.dat 6144 6144 title1.bin 
pletter title.dat 12288 128 title2.bin
tmscolor -c1 -m donna.bmp donna.dat
pletter donna.dat 0 6144 donna0.bin
pletter donna.dat 6144 6144 donna1.bin
pletter donna.dat 12288 64 donna2.bin
tmscolor -s striped.bmp striped.dat
tmscolor -c1 circle.bmp circle.dat
tmscolor -c1 digits.bmp digits.dat
tmscolor -s lag-per.bmp lag-per.dat
tmscolor -c1 -m monoscope.bmp monoscope.dat
pletter monoscope.dat 0 6144 monoscope0.bin
pletter monoscope.dat 6144 6144 monoscope1.bin
tmscolor -c1 controller.bmp controller.dat
