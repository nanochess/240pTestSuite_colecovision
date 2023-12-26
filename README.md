# 240pTestSuite_colecovision

### How to use it.

Your options to use the suite.rom file are:

* Your favorite Colecovision/MSX emulator (BlueMSX or CoolCV).
* Load the file into a flash cartridge like the AtariMAX Ultimate SD Colecovision cartridge.
* Program the file into an EPROM and put it into a cartridge PCB for Colecovision.

Detailed usage instructions are in the suite.txt file.

### How to assemble

You require tniASM v0.44 or v0.45 available freely from [http://www.tni.nl/products/tniasm.html](http://www.tni.nl/products/tniasm.html)

You only need to assemble the file suite.asm and it includes all the other required files (edit the COLECO or MSX label accordingly).

There are some files coming from the development environment (WinXP) that create the required images (images.bat) and assemble the code (e.bat).

Other utilities required are Pletter to compress the VDP data, and TMSColor to convert the bitmaps to the VDP format.

===============================================================================
Original 240p Test Suite is © Copyright 2011-2021 Artemio Urbina

Colecovision/MSX version is © Copyright 2023 Oscar Toledo G.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
