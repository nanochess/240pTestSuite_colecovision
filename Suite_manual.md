# 240p suite for Colecovision/MSX/SG1000.

### Original program by Artemio Urbina. Colecovision/MSX/SG1000 version by Oscar Toledo G.

### Last revision: Jan/29/2024.

Choose items from the menu by moving the stick up and down using any controller.

Select item by pressing any side-buttons on any controller. Use also the keys # and *.

### Notes for Colecovision:

Tested in real hardware.

### Notes for MSX:

Tested in real hardware. MSX 2 has some better graphics.

Left-side button is space or button 1. Right-side button is M or button 2.

Keypad * is mapped to keyboard Z. Keypad # is mapped to keyboard X.

### Notes for SG1000:

Not yet tested in real hardware.

The keypad # is mapped to the pause button.

The early models with a single joystick cannot map to the keypad *.

On more recent models you can use the two buttons of the second controller as keypad * and # respectively.

## Test Patterns and Interactive Tests

Since the software is running on a gaming platform, there is some degree of interactivity not possible on regular video tests, we have tried to use this as best as possible when applicable. For the rest of the cases regular test patterns, with inspiration in other sources, have been used.

Here's a description of each one of the options, as well as any specific commands within them.

### Test Patterns > SMPTE Color Bars.

Currently the color levels in this test haven't been measured.

### Test Patterns > Color Bleed Check.

This pattern helps diagnose unneeded color up-sampling. It consists of one pixel width color bars alternating with one pixel width black bars.

You can change the vertical bars to a checker board with the left-side button. The idea for this pattern was provided by Konsolkongen, for use with the DVDO EDGE. 

### Test Patterns > Monoscope

Displays a pattern arrangement for monitor alignment.

The aspect ratio has been measured with calibrated NTSC monitors to make sure the red lines make a square.

Move the stick to the left and right to change the white lines to gray and black.

Designed by Keith Raney.

### Test Patterns > White & Black Screens.

As the name implies, the screen is filled with solid white.

Pressing the left side button will toggle between white, black, and the "ultrablack" border color.

A full white screen usually makes evident audio interference in some RGB cables.

The fully black screen might cause some displays or upscan converters to stop recognizing the signal, which is a common (and undesirable) condition during gameplay.

TODO: Measure the "ultrablack" color.

### Test Patterns > Grid

A grid which borrows its basic pattern from the CPS-2 grid. It is used to determine linearity on CRTs, but is presented here in order to align the screen and find out overscan on the display. It uses the full resolution of the target console, with a margin of red squares for the corners.

Consumer CRTs usually don't allow compensating for overscan, and many games don't draw outside the white square borders. You can measure how many pixels your display is cropping with the overscan test. 

### Test Patterns > Sharpness.

You should set the sharpness of your display to a value that shows clean black and gray transitions, with no white ghosting in between.

On most modern displays, the sharpness control is an edge-enhancement control, and most probably should be set to zero, or in the middle.

In some PVM/BVM displays this is also referred to as aperture.

### Test Patterns > VDP Color Bars.

Display all the VDP colors in a column arrangement.

Press the left-side button to switch to a row arrangement.

TODO: Measure voltage levels again with third arrangement.

### Video tests > Drop Shadow Test.

This is a crucial test for 240p upscan converters. It displays a simple sprite shadow (32 by 32 pixels) against a background, but the shadow is shown only on each other frame. On a CRT this achieves a transparency effect, since you are watching a 30hz shadow on a 60hz signal. No background detail should be lost and the shadow should be visible.

This is a very revealing test since it exposes how the device is processing the signal. On devices that can't handle 240p signals, you can usually see that the signal is being interlaced with an odd and an even frame, as if it were regular 480i. This shows a shadow that doesn't flicker, with feathering (a line is drawn and the next one isn't).

Move shadow using the stick of any controller.

Press left button to alternate frame where shadow is drawn.

Press right button to toggle sprite.

Press key # to exit test.

### Video tests > Striped Sprite Test.

There are actually deinterlacers out there which can display the drop shadows correctly and still interpreted 240p as 480i. With a striped sprite it should be easy to tell if a processor tries to deinterlace (plus interpolate) or not.

Move shadow using the stick of any controller.

Press any side button or key # to exit test.

### Video tests > Lag Test.

This test is designed to be used with two displays connected at the same time. One being a CRT, or a display with a known lag as reference, and the other the display to test.

Using a camera, a picture should be taken of both screens at the same time. The picture will show the frame discrepancy between them.

The circles in the bottom help determine the frame even when the numbers are blurry.

Press any side button or the key # to exit test.

### Video tests > Timing & Reflex Test.

The main intention is to show a changing pattern on the screen, and given a visual and repetitive cue, play a beep alternating speakers. This can help you notice how you react to any lag (if present) when processing the signal. It must be stated that this is not a lag test.

As an added feature, the user can press the left-side button when the sprite is aligned with the one on the background, and the offset in frames form the actual intersection will be shown on screen. This can be repeated ten times and the software will calculate the average. Whenever the button was pressed before the actual intersection frame, the result will be ignored (but still shown onscreen).

The right-side button can be used to change the direction of the sprite from vertical to horizontal, or display both at the same time.

Of course the evaluation is dependent on reflexes and/or rhythm more than anything. The visual and audio cues are the more revealing aspects which the user should consider, of course the interactive factor can give an experienced player the hang of the system when testing it via different connections. Since a frame is around 16 ms (1000/60), that value must be considered the general error when using the test results. Press the right side button to change the moving sprite to vertical/horizontal movement or to show both.

Press key * to remove random variation.

Press key # to exit test.

### Video tests > Grid Scroll Test.

A grid is scrolled vertically or horizontally, which can be used to test linearity of the signal and how well the display copes with scrolling. 

Move stick up and down to accelerate or reduce speed.

Move stick left and right to switch square to diagonal pattern.

Press left button to pause movement.

Press right button to switch scroll direction in X or Y.

Press key * to reverse direction.

Press key # to exit test.

### Video tests > Horizontal Stripes.

A pattern consisting of a full screen of horizontal black and white stripes, one pixel tall each. This is a taxing pattern, specially when pressing the left-side button which enables alternating each frame the color of the lines. A good 240p video processor should show all frames. On several displays we've observed that the screen stays static on the first pattern displayed on screen and no change is shown. For this a Frame counter is present, which can be enabled with the keypad asterisk.

The user can also change the frames with the right-side button, which alternates the even and odd frame cadence for the automatic switching of patterns. 

Press key # to exit test.

### Video tests > Checkerboard.

Press left button to alternate pixels on each frame.

Press right button to switch pixels on each press.

Press key * to show frame count.

Press key # to exit test.

### Video tests > Backlit Zone Test.

This test is designed to evaluate how a display deals with dark scenes. A single sprite of variable size can be controlled by the user on top of a completely black background. The dimming zones can be easily spotted while doing this and the rest of the screen should - in theory - remain off. The sprite can be hidden with the right-side button, and the sprite size can be changed with the left-side button. 

### Audio test > Sound Test

It emits an approximate audio frequency of 1000 hz.

Press key # to exit test.

### Audio test > Audio Sync Test

It emits an approximate audio frequency of 1000 hz when the ball hits the wall.

Press key # to exit test.

### Audio test > MDFourier

It generates a tone test and noise test (SN76489 in Colecovision and SG1000).

Same for MSX (AY-3-8910) but added with SCC and FM (if available).

These are intended to be used with MDFourier. which can compare audio signatures and generate a series of graphs that show how they differ. These can help to identify how audio signatures vary between systems, to detect if the audio signals are modified by audio equipment, to find if modifications resulted in audible changes, to help tune emulators, FPGA implementations or mods, etc. 

### Hardware > Controller test.

Show hardware values of controller ports (Colecovision)

Currently not implemented on MSX or SG1000.

Press both side buttons on any controller to exit test.

### Hardware > BIOS data.

Shows BIOS checksum (CRC32 for Colecovision, SHA1 for MSX BIOS on first 32K)

It can take a few seconds to show the hash. In MSX emulation the test isn't useful as some emulators tend to patch the MSX BIOS.

The MSX version includes the MAME and BlueMSX System BIOS databases.

Not implemented in SG1000 as it doesn't has a BIOS.

Press any side button on any controller to exit test.

### Hardware > Memory viewer.

Shows memory contents starting at $0000 and can explore the whole 64K of Z80 addressing.

Displace address window by moving stick up or down on any controller.

Press any side button on any controller to exit test.

### Credits

Shows the credits for the 240p suite.

Original software: Artemio Urbina @artemio
Colecovision/MSX/SG1000 developer: Oscar Toledo G. @nanochess
Donna art: @pepe_salot
Menu art: @aftasher

