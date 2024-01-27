# 240pTestSuite_colecovision

### What is this?

This is a port of the Artemio's 240p Test suite for Colecovision consoles, MSX 1/2/2+ computers, and Sega SG1000 consoles. It is a software suite developed to help in the evaluation of capture cards, upscalers, upscan converters, line doublers, and of course TV processiong of 240p video and scaled signals.

The original 240p Test Suite is available at [https://github.com/ArtemioUrbina/240pTestSuite](https://github.com/ArtemioUrbina/240pTestSuite)

More info about the 240p Test Suite is available at [https://junkerhq.net/240p/](https://junkerhq.net/240p/)

### How to use it.

Your options to use the suite.rom file are:

* Your favorite Colecovision/MSX/SG1000 emulator (BlueMSX, OpenMSX or CoolCV).
* Load the file into a flash cartridge like the AtariMAX Ultimate SD Colecovision cartridge or the MSX MegaFlash SD cartridge.
* Program the file into an EPROM and put it into a cartridge PCB for Colecovision/MSX/SG1000.

Detailed usage instructions are in the Suite_manual.md file.

The mapper used for the MSX version is SCC.

### How to assemble

For assembling yourself the source code, you require tniASM v0.44 or v0.45 available freely from [http://www.tni.nl/products/tniasm.html](http://www.tni.nl/products/tniasm.html)

You only need to assemble the file suite.asm and it includes all the other required files (edit the COLECO, MSX or SG1000 label accordingly).

There are some batch files coming from the development environment (WinXP) that create the required images (images.bat) and assemble the code (e.bat).

Other utilities required are Pletter to compress the VDP data, and TMSColor to convert the bitmaps to the VDP format. Both are included in source code form.

===============================================================================
Original 240p Test Suite is © Copyright 2011-2021 Artemio Urbina

Colecovision/MSX/SG1000 version is © Copyright 2023-2024 Oscar Toledo G.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
