@echo off
tmscolor -c1 -t80 bars1.bmp bars1.dat
tmscolor -c1 circles.bmp circles.dat
pletter circles.dat 0 6144 circles0.bin
tmscolor -c1 sharpness.bmp sharpness.dat
pletter sharpness.dat 0 6144 sharpness0.bin
pletter sharpness.dat 6144 6144 sharpness1.bin
tmscolor -c1 -m title.bmp title.dat
pletter title.dat 0 6144 title0.bin
pletter title.dat 6144 6144 title1.bin 
pletter title.dat 12288 128 title2.bin

