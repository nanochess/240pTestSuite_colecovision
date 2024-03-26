        ;
        ; 240p test suite (video tests unit)
        ;
        ; Original program Copyright (C) 2011 Artemio Urbina. @artemio
        ; Colecovision/MSX/SG1000 version Copyright (C) 2023-2024 Oscar Toledo G. @nanochess
	;
	; This program is free software; you can redistribute it and/or modify
	; it under the terms of the GNU General Public License as published by
	; the Free Software Foundation; either version 2 of the License, or
	; (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU General Public License for more details.
	;
	; You should have received a copy of the GNU General Public License along
	; with this program; if not, write to the Free Software Foundation, Inc.,
	; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ; Creation date: Dec/20/2023.
	; Revision date: Dec/21/2023. Added Grid Scroll Test.
        ; Revision date: Dec/22/2023. Added Checkerboard.
        ; Revision date: Dec/25/2023. Added Drop Shadow Test and Striped
        ;                             Sprite Test. Added Lag Test.
        ; Revision date: Dec/29/2023. Adapted tests for improved Donna
        ;                             background.
        ; Revision date: Jan/04/2024. Moved Checkerboard test below, and
        ;                             added Backlit Zone Test.
        ;

menu_video:
        dw $0820
        db "*Drop Shadow Test",0
        dw $0920
        db "*Striped Sprite Test",0
        dw $0a20
        db "*Lag Test",0        
        dw $0b20
        db "*Timing & Reflex Test",0
        dw $0c20
        db "*Grid Scroll Test",0
        dw $0d20
        db "*Horizontal Stripes",0
        dw $0e20
        db "*Checkerboard",0
        dw $0f20
        db "*Backlit Zone Test",0
        dw $1120
        db "*Back to Main Menu",0
        dw $0000                      

video_menu:
        call clean_menu
        ld hl,menu_video
        call build_menu

        or a
        jp z,drop_shadow
        dec a
        jp z,striped_sprite
        dec a
        jp z,lag_test
        dec a
        jp z,timing_reflex_test
        dec a
        jp z,grid_scroll
        dec a
        jp z,draw_stripes
        dec a
        jp z,checkerboard
        dec a
        jp z,backlit_zone_test        
        
        jp main_menu

        ;
        ; Drop Shadow test
        ;
drop_shadow:
        call DISSCR
    if MSX
        call is_it_msx2
        jp nc,.0
        call clear_sprites2
        ld a,4
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,msx2_donna_palette
        call set_palette
        ld hl,donnam2
        ld de,$0000
        call unpack2
        ld a,2
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,striped
        ld de,$f100
        ld bc,$0100
        call nmi_off
        call LDIRVM2
        call nmi_on
        ld hl,MSX2_SPRITE_SAT-$0200
        ld bc,$0040
        ld a,$01        ; MSX2 sprite color for each line.
        call nmi_off
        call FILVRM2
        call nmi_on
        jp .11
.0:        
    endif
        call clear_sprites
        call highres
        ld hl,donna0
        ld de,$0000
        call unpack
        ld hl,donna1
        ld de,$2000
        call unpack
        ld hl,donna2
        ld de,$1800
        call unpack
        ld hl,striped
        ld de,$1900
        ld bc,$0100
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,donna3
        ld de,$3f90
        ld bc,$001c
        call nmi_off
        call LDIRVM
        call nmi_on
.11:
        call ENASCR
        xor a
        ld (cframe),a
        ld (invert),a
        ld a,$70
        ld (x),a
        ld a,$50
        ld (y),a
        ld a,$20
        ld (buffer+2),a
        add a,$04
        ld (buffer+6),a
        add a,$04
        ld (buffer+10),a
        add a,$04
        ld (buffer+14),a
        ld a,$01
        ld (buffer+3),a
        ld (buffer+7),a
        ld (buffer+11),a
        ld (buffer+15),a
.1:
        ld a,(cframe)
        ld b,a
        ld a,(invert)
        cp b
        jr nz,.2
        ld a,(y)
        dec a
        ld (buffer),a
        ld (buffer+4),a
        add a,16
        ld (buffer+8),a
        ld (buffer+12),a
        ld a,(x)
        ld (buffer+1),a
        ld (buffer+9),a
        add a,16
        ld (buffer+5),a
        ld (buffer+13),a
        jr .3
.2:
    if MSX
        call is_it_msx2
        ld a,$d1
        jr nc,$+4
        ld a,$d8
    else
        ld a,$d1
    endif
        ld (buffer),a
        ld (buffer+4),a
        ld (buffer+8),a
        ld (buffer+12),a
.3:

        halt
        ld hl,buffer
        ld bc,$0010
    if MSX
        call is_it_msx2
        jp nc,.10
        ld de,MSX2_SPRITE_SAT
        call LDIRVM2
        jr .12
.10:
    endif
        ld de,$3f80
        call LDIRVM
.12:
        ld a,(cframe)
        xor 1
        ld (cframe),a

        call read_joystick_button_debounce
        bit 0,a
        jr nz,.4
        push af
        ld a,(y)
        or a
        jr z,$+3
        dec a
        ld (y),a
        pop af
.4:
        bit 1,a
        jr nz,.5
        push af
        ld a,(x)
        cp $e0
        jr z,$+3
        inc a
        ld (x),a
        pop af
.5:
        bit 2,a
        jr nz,.6
        push af
    if MSX
        call is_it_msx2
        ld b,$a0
        jr nc,$+4
        ld b,$b4
    else
        ld b,$a0
    endif
        ld a,(y)
        cp b
        jr z,$+3
        inc a
        ld (y),a
        pop af
.6:
        bit 3,a
        jr nz,.7
        push af
        ld a,(x)
        or a
        jr z,$+3
        dec a
        ld (x),a
        pop af
.7:
        bit 6,a
        jr nz,.8
        push af
        ld a,15
        ld (debounce),a
        ld a,(invert)
        xor 1
        ld (invert),a
        pop af
.8:
        bit 7,a
        jr nz,.9
        push af
        ld a,15
        ld (debounce),a
        ld a,(buffer+2)
        cp $20
        ld a,$30
        jr z,$+4
        ld a,$20
        ld (buffer+2),a
        add a,$04
        ld (buffer+6),a
        add a,$04
        ld (buffer+10),a
        add a,$04
        ld (buffer+14),a
        pop af
.9:
        cpl
        and $20
        jp z,.1
        ld a,15
        ld (debounce),a

        call reload_menu
        jp video_menu

        ;
        ; Striped Sprite test
        ;
striped_sprite:
        call DISSCR
    if MSX
        call is_it_msx2
        jp nc,.0
        call clear_sprites2
        ld a,4
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,msx2_donna_palette
        call set_palette
        ld hl,donnam2
        ld de,$0000
        call unpack2
        ld a,2
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,striped
        ld de,$f100
        ld bc,$0100
        call nmi_off
        call LDIRVM2
        call nmi_on
        ld hl,MSX2_SPRITE_SAT-$0200
        ld bc,$0040
        ld a,$01        ; MSX2 sprite color for each line.
        call nmi_off
        call FILVRM2
        call nmi_on
        jp .11
.0:        
    endif
        call clear_sprites
        call highres
        ld hl,donna0
        ld de,$0000
        call unpack
        ld hl,donna1
        ld de,$2000
        call unpack
        ld hl,donna2
        ld de,$1800
        call unpack
        ld hl,striped
        ld de,$1900
        ld bc,$0100
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,donna3
        ld de,$3f90
        ld bc,$001c
        call nmi_off
        call LDIRVM
        call nmi_on
.11:
        call ENASCR
        ld a,$70
        ld (x),a
        ld a,$50
        ld (y),a
        ld a,$20
        ld (buffer+2),a
        add a,$04
        ld (buffer+6),a
        add a,$04
        ld (buffer+10),a
        add a,$04
        ld (buffer+14),a
        ld a,$01
        ld (buffer+3),a
        ld (buffer+7),a
        ld (buffer+11),a
        ld (buffer+15),a
.1:
        ld a,(y)
        dec a
        ld (buffer),a
        ld (buffer+4),a
        add a,16
        ld (buffer+8),a
        ld (buffer+12),a
        ld a,(x)
        ld (buffer+1),a
        ld (buffer+9),a
        add a,16
        ld (buffer+5),a
        ld (buffer+13),a

        halt
        ld hl,buffer
        ld bc,$0010
    if MSX
        call is_it_msx2
        jp nc,.10
        ld de,MSX2_SPRITE_SAT
        call LDIRVM2
        jr .12
.10:
    endif
        ld de,$3f80
        call LDIRVM
.12:

        call read_joystick_button_debounce
        bit 0,a
        jr nz,.4
        push af
        ld a,(y)
        or a
        jr z,$+3
        dec a
        ld (y),a
        pop af
.4:
        bit 1,a
        jr nz,.5
        push af
        ld a,(x)
        cp $e0
        jr z,$+3
        inc a
        ld (x),a
        pop af
.5:
        bit 2,a
        jr nz,.6
        push af
    if MSX
        call is_it_msx2
        ld b,$a0
        jr nc,$+4
        ld b,$b4
    else
        ld b,$a0
    endif
        ld a,(y)
        cp b
        jr z,$+3
        inc a
        ld (y),a
        pop af
.6:
        bit 3,a
        jr nz,.7
        push af
        ld a,(x)
        or a
        jr z,$+3
        dec a
        ld (x),a
        pop af
.7:
        cpl
        and $e0
        jp z,.1
        ld a,15
        ld (debounce),a

        call reload_menu
        jp video_menu

        ;
        ; Grid Scroll test
        ;
grid_scroll:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR
        ld a,1
        ld (speed),a
        ld (acc),a
        xor a
        ld (x),a
        ld (y),a
        ld (pause),a
        ld (direction),a
        ld (back),a
        ld a,$ff
        ld (oldbuttons),a

.1:     halt
        ld a,(speed)
        cp 1
        jr nc,$+4
        ld a,1
        cp 6
        jr c,$+4
        ld a,5
        ld (speed),a

        ld a,(pause)
        or a
        jr nz,.2
        ld a,(direction)
        or a
        jr z,.3
        ld a,(acc)
        or a
        ld a,(speed)
        jp p,$+5
        neg
        ld b,a
        ld a,(x)
        add a,b
        ld (x),a
        jr .2

.3:
        ld a,(acc)
        or a
        ld a,(speed)
        jp p,$+5
        neg
        ld b,a
        ld a,(y)
        add a,b
        ld (y),a
.2:
        ld a,(back)
        or a
        ld hl,.square
        jr z,$+5
        ld hl,.diagonal

        ld a,(y)
        and 7
        ld e,a
        ld d,0
        add hl,de
        ld a,(x)
        and 7
        ld de,buffer
        jr z,.12
        ld c,a
.14:
        ld a,(hl)
        inc hl
        ld b,c
        rlca
        djnz $-1
        ld (de),a
        inc de
        ld a,e
        cp 255 and (buffer+8)
        jp nz,.14
        jr .11

.12:    ld de,buffer
        ld bc,8
        ldir
.11:
        ld hl,buffer
        ld de,$0000
        ld bc,8
        call nmi_off
        call LDIRVM3
        call nmi_on

        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 0,b         ; Up
        jr z,.4
        ld a,(speed)
        inc a
        ld (speed),a
.4:
        bit 2,b         ; Down
        jr z,.5
        ld a,(speed)
        dec a
        ld (speed),a
.5:
        bit 6,b         ; Button A
        jr z,.6
        ld a,(pause)
        xor 1
        ld (pause),a
.6:
        bit 7,b         ; Button B
        jr z,.7
        ld a,(direction)
        xor 1
        ld (direction),a
.7:
        bit 4,b         ; #
        jr z,.8
        ld a,(acc)
        neg
        ld (acc),a
.8:
        bit 1,b
        jr nz,.9
        bit 3,b
        jr z,.10
.9:
        ld a,(back)
        xor 1
        ld (back),a
.10:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp video_menu

.square:
        db $ff
        db $81
        db $81
        db $81
        db $81
        db $81
        db $81
        db $ff
        db $ff
        db $81
        db $81
        db $81
        db $81
        db $81
        db $81
        db $ff

.diagonal:
        db $0f
        db $1e
        db $3c
        db $78
        db $f0
        db $e1
        db $c3
        db $87
        db $0f
        db $1e
        db $3c
        db $78
        db $f0
        db $e1
        db $c3
        db $87

checkerboard:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR

        xor a
        ld (alternate),a
        ld (invert),a
        ld (field),a
        ld (dframe),a
        ld (cframe),a
        ld a,$ff
        ld (oldbuttons),a
        halt
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3

.1:
        halt
        ld a,(alternate)
        ld b,a
        ld a,(invert)
        or b
        jr z,.2
        ld a,(field)
        or a
        jr z,.3
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        xor a
        ld (field),a
        jr .4

.3:
        ld hl,.stripesneg
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        ld a,1
        ld (field),a
.4:
        xor a
        ld (invert),a
.2:
        ld a,(dframe)
        or a
        jr z,.9
        ld hl,buffer
        ld (hl),'F'
        inc hl
        ld (hl),'r'
        inc hl
        ld (hl),'a'
        inc hl
        ld (hl),'m'
        inc hl
        ld (hl),'e'
        inc hl
        ld (hl),':'
        inc hl
        ld (hl),' '
        inc hl
        ld a,(cframe)
        rrca
        rrca
        rrca
        rrca
        and $0f
        add a,$30
        ld (hl),a
        inc hl
        ld a,(cframe)
        and $0f
        add a,$30
        ld (hl),a
        ld hl,buffer
        ld de,$3816
        ld bc,$0009
        call LDIRVM
        ld a,(cframe)
        add a,1         ; cannot be inc a
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (cframe),a
        jr .5

.9:
        ld hl,$3816
        ld bc,$0009
        xor a
        call FILVRM
.5:
        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 6,b
        jr z,.6
        ld a,(alternate)
        xor 1
        ld (alternate),a

.6:
        bit 7,b
        jr z,.7
        ld a,(alternate)
        or a
        jr nz,.7
        ld a,1
        ld (invert),a
.7:
        bit 4,b
        jr z,.8
        ld a,(dframe)
        xor 1
        ld (dframe),a
        xor a
        ld (frame),a
        ld a,(dframe)
        or a
        jr nz,.8
        ld a,(field)
        xor 1
        ld (field),a
        ld a,1
        ld (invert),a
.8:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp video_menu

.stripespos:
        db $55,$aa,$55,$aa,$55,$aa,$55,$aa
.stripesneg:
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55

LAG_BK_COLOR:   EQU $0f

        ;
        ; Lag Test.
        ;
lag_test:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        ld bc,LAG_BK_COLOR*256+$07
        call nmi_off
        call WRTVDP
        call nmi_on
        ld hl,$0000
        ld bc,$1800
        xor a
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,$2000
        ld bc,$1800
        ld a,$10+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on

        ld hl,$3800
        ld b,$20
        call nmi_off
.1:     ld a,l
        call WRTVRM
        inc hl
        djnz .1
        call nmi_on
        ld hl,$3820
        ld bc,$02e0
        xor a
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,$3c00
        ld b,$20
        call nmi_off
.2:     ld a,l
        call WRTVRM
        inc hl
        djnz .2
        call nmi_on
        ld hl,$3c20
        ld bc,$02e0
        xor a
        call nmi_off
        call FILVRM
        call nmi_on


        ld hl,.lag_message
        ld de,$0000
        ld a,$10+LAG_BK_COLOR
        call show_message_vdp2
        ld hl,digits
        ld de,$005b*8
        ld bc,165*8
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$2000+$005b*8
        ld bc,165*8
        ld a,$10+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on

        ld hl,circle
        ld de,$0800+$10*8
        ld bc,49*8
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$2800+$10*8
        ld bc,49*8
        ld a,$40+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,circle
        ld de,$0800+$48*8
        ld bc,49*8
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$2800+$48*8
        ld bc,49*8
        ld a,$60+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,digits+15*8*1     ; Point to digit 1.
        ld de,$0800+$0080*8
        ld bc,15*8*4
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$2800+$0080*8
        ld bc,15*8*4
        ld a,$f4
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,digits+15*8*1     ; Point to digit 1.
        ld de,$0800+$00c0*8
        ld bc,15*8*4
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$2800+$00c0*8
        ld bc,15*8*4
        ld a,$f6
        call nmi_off
        call FILVRM
        call nmi_on

        ld hl,circle
        ld de,$1000+$10*8
        ld bc,49*8
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$3000+$10*8
        ld bc,49*8
        ld a,$40+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,circle
        ld de,$1000+$48*8
        ld bc,49*8
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$3000+$48*8
        ld bc,49*8
        ld a,$60+LAG_BK_COLOR
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,digits+15*8*5     ; Point to digit 5.
        ld de,$1000+$0080*8
        ld bc,15*8*4
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$3000+$0080*8
        ld bc,15*8*4
        ld a,$f4
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,digits+15*8*5     ; Point to digit 5.
        ld de,$1000+$00c0*8
        ld bc,15*8*4
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,$3000+$00c0*8
        ld bc,15*8*4
        ld a,$f6
        call nmi_off
        call FILVRM
        call nmi_on

        call nmi_off
        ld a,10
        ld hl,$3827
        call .display_digit

        ld a,10
        ld hl,$382f
        call .display_digit

        ld a,10
        ld hl,$3837
        call .display_digit

        ld a,10
        ld hl,$3c27
        call .display_digit

        ld a,10
        ld hl,$3c2f
        call .display_digit

        ld a,10
        ld hl,$3c37
        call .display_digit
        call nmi_on

        call ENASCR

        xor a
        ld (hours),a
        ld (minutes),a
        ld (seconds),a
        ld (frames),a

        ld a,1
        ld (cframe),a
.loop:
        ;
        ; The Z80/VDP combination isn't fast enough
        ; too update in real time, so build screen data
        ; in a hidden buffer and switch screen buffers.
        ;
        ld a,(cframe)
        or a
        ld hl,$3820
        jr z,$+5
        ld hl,$3c20
        ld de,$0001
        add hl,de
        ld a,(hours)
        call .display_digits
        inc hl
        inc hl
        ld a,(minutes)
        call .display_digits
        inc hl
        inc hl
        ld a,(seconds)
        call .display_digits
        inc hl
        inc hl
        ld a,(frames)
        call .display_digits

        ld de,$00e3
        add hl,de
        ld a,(frames)
        and $0f
        cp $01
        ld bc,$1080
        jr nz,$+5
        ld bc,$48c0
        call .build_circle

        ld a,(frames)
        and $0f
        cp $02
        ld bc,$108f
        jr nz,$+5
        ld bc,$48cf
        call .build_circle

        ld a,(frames)
        and $0f
        cp $03
        ld bc,$109e
        jr nz,$+5
        ld bc,$48de
        call .build_circle

        ld a,(frames)
        and $0f
        cp $04
        ld bc,$10ad
        jr nz,$+5
        ld bc,$48ed
        call .build_circle

        ld de,$00e4
        add hl,de
        ld a,(frames)
        and $0f
        cp $05
        ld bc,$1080
        jr nz,$+5
        ld bc,$48c0
        call .build_circle

        ld a,(frames)
        and $0f
        cp $06
        ld bc,$108f
        jr nz,$+5
        ld bc,$48cf
        call .build_circle

        ld a,(frames)
        and $0f
        cp $07
        ld bc,$109e
        jr nz,$+5
        ld bc,$48de
        call .build_circle

        ld a,(frames)
        and $0f
        cp $08
        ld bc,$10ad
        jr nz,$+5
        ld bc,$48ed
        call .build_circle

        halt

        ;
        ; Switch screen buffers.
        ;
        ld a,(cframe)
        or a
        ld bc,$0e02
        jr z,$+5
        ld bc,$0f02
        call WRTVDP

        ;
        ; Handle counters.
        ;
        ld a,(frames_per_sec)
        cp 60
        ld b,$60
        jr z,$+4
        ld b,$50

        ld a,(frames)
        add a,1
        daa
        cp b
        jr nz,$+3
        xor a
        ld (frames),a
        jp nz,.3
        ld a,(seconds)
        add a,1
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (seconds),a
        jp nz,.3
        ld a,(minutes)
        add a,1
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (minutes),a
        jp nz,.3
        ld a,(hours)
        add a,1
        daa
        ld (hours),a
.3:

        call read_joystick_button_debounce
        cpl
        and $e0
        jp z,.loop

        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp video_menu

.lag_message:
        db "   hours    minutes    seconds    frames",0

        ;
        ; The following routines are so fast as possible.
        ;
.display_digits:
        push af
        rrca
        rrca
        rrca
        rrca
        call .display_digit
        pop af
.display_digit:
        and $0f
        ld b,a
        add a,a         ; x2
        add a,a         ; x4
        add a,a         ; x8
        add a,a         ; x16
        sub b           ; x15
        add a,$5b

        call WRTVRM
        inc a
        jp $+3
        out (VDP),a
        jp $+3
        jp $+3
        inc a
        out (VDP),a
        jp $+3
        ld de,32
        add hl,de

        inc a
        call WRTVRM
        inc a
        jp $+3
        out (VDP),a
        jp $+3
        jp $+3
        inc a
        out (VDP),a
        jp $+3
        ld de,32
        add hl,de
        
        inc a
        call WRTVRM
        inc a
        jp $+3
        out (VDP),a
        jp $+3
        jp $+3
        inc a
        out (VDP),a
        jp $+3
        ld de,32
        add hl,de

        inc a
        call WRTVRM
        inc a
        jp $+3
        out (VDP),a
        jp $+3
        jp $+3
        inc a
        out (VDP),a
        jp $+3
        ld de,32
        add hl,de

        inc a
        call WRTVRM
        inc a
        jp $+3
        out (VDP),a
        jp $+3
        jp $+3
        inc a
        out (VDP),a
        jp $+3
        ld de,-4*32+3
        add hl,de
        ret

.build_circle:
        push hl
    if (buffer/256*256)-(buffer+55)/256*256
        error "generate error"
    endif
        ld hl,buffer
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),c
        inc c
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b

        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        inc l
        inc b
        ld (hl),b
        pop de
        push de
        ld b,7
        ld hl,buffer
.bc1:   push bc
        push hl
        push de
        ld bc,$0007
        call LDIRVM
        pop hl
        ld bc,32
        add hl,bc
        ex de,hl
        pop hl
        ld c,7
        add hl,bc
        pop bc
        djnz .bc1
        pop hl
        ld de,7
        add hl,de
        ret

T_CENTER_X:     EQU 112
T_CENTER_Y:     EQU 80

        ;
        ; Timing and Reflex Test.
        ;
timing_reflex_test:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif

        call clear_sprites
        call highres
        ld hl,$0000
        ld bc,$1800
        xor a
        call nmi_off
        call FILVRM
        ld hl,lag_per
        ld de,$0a70
        call .sprtoscr
        ld hl,lag_per+32
        ld de,$0a80
        call .sprtoscr
        ld hl,lag_per+64
        ld de,$0c70
        call .sprtoscr
        ld hl,lag_per+96
        ld de,$0c80
        call .sprtoscr
        call nmi_on
        ld hl,$2000
        ld bc,$1800
        ld a,$f1
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,lag_per
        ld de,$1800
        ld bc,$0080
        call nmi_off
        call LDIRVM
        call nmi_on

        ld hl,.message_1
        ld de,$1400
        ld a,$21
        call show_message_vdp2
        ld hl,.message_2
        ld de,$1500
        ld a,$21
        call show_message_vdp2
        ld hl,.message_3
        ld de,$1600
        ld a,$21
        call show_message_vdp2
        ld hl,.message_4
        ld de,$1700
        ld a,$21
        call show_message_vdp2

        call ENASCR

        ld hl,.fixed
        ld de,buffer
        ld bc,16
        ldir
        ld hl,.fixed
        ld bc,16
        ldir

        xor a
        ld (view),a
        ld (pos),a
        ld a,1
        ld (speed),a
        ld (change),a
        ld a,0
        ld (vary),a
        ld a,1
        ld (variation),a
        ld a,T_CENTER_X
        ld (x),a
        ld a,T_CENTER_Y-36
        ld (y),a
        ld a,T_CENTER_X-36
        ld (x2),a
        ld a,T_CENTER_Y
        ld (y2),a
.loop:

        ld a,(view)
        cp 1
        jr z,.1
        ld a,(x)
        ld (buffer+1),a
        ld (buffer+9),a
        add a,16
        ld (buffer+5),a
        ld (buffer+13),a
        ld a,(y)
        dec a
        ld (buffer),a
        ld (buffer+4),a
        add a,16
        ld (buffer+8),a
        ld (buffer+12),a
        jr .2

.1:
        ld a,$d1
        ld (buffer),a
        ld (buffer+4),a
        ld (buffer+8),a
        ld (buffer+12),a
.2:
        ld a,(view)
        or a
        jr z,.3
        ld a,(x2)
        ld (buffer+17),a
        ld (buffer+25),a
        add a,16
        ld (buffer+21),a
        ld (buffer+29),a
        ld a,(y2)
        dec a
        ld (buffer+16),a
        ld (buffer+20),a
        add a,16
        ld (buffer+24),a
        ld (buffer+28),a
        jr .4

.3:
        ld a,$d1
        ld (buffer+16),a
        ld (buffer+20),a
        ld (buffer+24),a
        ld (buffer+28),a
.4:

        halt
        ld hl,buffer
        ld de,$3f80
        ld bc,$0020
        call LDIRVM

        ld a,(y)
        cp T_CENTER_Y+1
        jr nz,.30
        ld a,(speed)
        cp $ff
        jr nz,.30
.32:    ld a,1
        ld (beep),a
        jr .31

.30:    ld a,(y)
        cp T_CENTER_Y-1
        jr nz,.31
        ld a,(speed)
        cp $01
        jr z,.32
.31:
        call play_beep

        ld a,(y)
        cp T_CENTER_Y
        jr nz,.18
        ld a,$06
.21:
        ld (buffer+3),a
        ld (buffer+7),a
        ld (buffer+11),a
        ld (buffer+15),a
        ld (buffer+19),a
        ld (buffer+23),a
        ld (buffer+27),a
        ld (buffer+31),a
        jr .19

.18:    cp T_CENTER_Y+1
        jr nz,.20
        cp T_CENTER_Y-1
        jr nz,.20
        ld a,$02
        jr .21

.20:    cp T_CENTER_Y+2
        jr nz,.19
        cp T_CENTER_Y-2
        jr nz,.19
        ld a,$0f
        jr .21
.19:

        ld a,(debounce)
        or a
        jr z,$+6
        dec a
        ld (debounce),a
        call read_joystick_button

        bit 6,a         ; Left-side button.
        jp nz,.9
        ld a,(change)
        or a
        jp z,.24
        ld a,(pos)
        ld e,a
        ld d,0
        ld a,(speed)
        or a
        jp p,.11
        ld a,(y)
        sub T_CENTER_Y
        neg
        jr .12

.11:    ld a,(y)
        sub T_CENTER_Y
.12:    or a
        jp m,.loop
        push af
        ld hl,buffer+32
        add hl,de
        ld (hl),a
        ld a,(pos)
        ld d,a
        ld e,0
        ld hl,buffer+42
        ld (hl),'O'
        inc hl
        ld (hl),'f'
        inc hl
        ld (hl),'f'
        inc hl
        ld (hl),'s'
        inc hl
        ld (hl),'e'
        inc hl
        ld (hl),'t'
        inc hl
        ld (hl),' '
        inc hl
        ld a,(pos)
        cp 9
        jr nz,.16
        ld (hl),'1'
        inc hl
        ld (hl),'0'
        inc hl
        jr .17
.16:    add a,$31
        ld (hl),a
        inc hl
.17:    ld (hl),':'
        inc hl
        ld (hl),' '
        inc hl
        pop af
        cp 1
        push af
        ld b,$30-1
        inc b
        sub 10
        jr nc,$-3
        add a,10+$30
        push af
        ld a,b
        cp $30
        jr z,$+4
        ld (hl),b
        inc hl
        pop af
        ld (hl),a
        inc hl
        ld (hl),' '
        inc hl
        ld (hl),'f'
        inc hl
        ld (hl),'r'
        inc hl
        ld (hl),'a'
        inc hl
        ld (hl),'m'
        inc hl
        ld (hl),'e'
        inc hl
        pop af
        jr z,$+5
        ld (hl),'s'
        inc hl
        ld (hl),0

        ld hl,buffer+42
        ld a,$21
        call show_message_vdp2

        ld a,(pos)
        inc a
        ld (pos),a
        cp 10
        jp nc,.15
        xor a
        ld (change),a

.14:
        jp .24

.9:
        bit 7,a         ; Right-side button.
        jr nz,.10
        ld a,(debounce)
        or a
        jp nz,.24
        ld a,15
        ld (debounce),a
        ld a,(view)
        inc a
        cp 3
        jr nz,$+3
        xor a
        ld (view),a
        jp .24

.10:
        bit 4,a
        jr nz,.22
        ld a,(debounce)
        or a
        jp nz,.loop
        ld a,15
        ld (debounce),a
        ld a,(variation)
        xor 1
        ld (variation),a
        or a
        jp nz,.24
        xor a
        ld (vary),a
        jp .24

.22:
        cpl
        and $20
        jp nz,.15
.24:
        ld a,(vary)
        add a,T_CENTER_Y+36+1
        ld b,a
        ld a,(y)
        cp b
        jr c,.5
        ld a,-1
        ld (speed),a
        ld a,1
        ld (change),a
        ld a,(variation)
        or a
        jr z,.5
        ld a,r
        rrca
        jr c,.6
        and $07
        ld (vary),a
        jr .5
.6:
        and $07
        neg
        ld (vary),a
.5:
        ld a,(vary)
        add a,T_CENTER_Y-36
        ld b,a
        ld a,(y)
        cp b
        jr nc,.7
        ld a,1
        ld (speed),a
        ld a,1
        ld (change),a
        ld a,(variation)
        or a
        jr z,.7
        ld a,r
        rrca
        jr c,.8
        and $07
        ld (vary),a
        jr .7
.8:
        and $07
        neg
        ld (vary),a
.7:
        ld a,(speed)
        ld b,a
        ld a,(y)
        add a,b
        ld (y),a
        ld a,(x2)
        add a,b
        ld (x2),a
        jp .loop


        ; Done
.15:   
        ld a,0
        call set_volume

        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu

        ld a,(pos)
        cp 10
        jp nz,video_menu

        ld hl,0
        ld (total),hl
        ld b,0
.23:    push bc
        ld hl,buffer+32
        ld a,l
        add a,b
        ld l,a
        jr nc,$+3
        inc h
        ld a,(hl)
        or a
        ld a,$ce
        jr z,$+4
        ld a,$1e
        ld (acc),a
        ld e,(hl)
        ld d,0
        ld hl,(total)
        add hl,de
        ld (total),hl
        ld a,e
        ld b,$30-1
        inc b
        sub 10
        jr nc,$-3
        add a,10+$30
        ld hl,buffer
        push af
        ld a,b
        cp $30
        ld (hl),b
        jr nz,$+4
        ld (hl),$20
        inc hl
        pop af
        ld (hl),a
        inc hl
        ld (hl),0
        pop bc
        push bc
        ld a,b
        add a,$08
        ld d,a
        ld e,$28
        ld a,(acc)
        ld hl,buffer
        call show_message
        pop bc
        inc b
        ld a,b
        cp 10
        jp nz,.23

        ld hl,.message_5
        ld de,$0c20
        ld a,$6e
        call show_message
        ld hl,.message_6
        ld de,$1220
        ld a,$6e
        call show_message

        ld hl,(total)
        ld ix,buffer
        call decimal_number
        ld (ix+0),'/'
        ld (ix+1),'1'
        ld (ix+2),'0'
        ld (ix+3),'='
        ld de,4
        add ix,de
        ld hl,(total)
        ld bc,-1
        ld de,-10
.25:    inc bc
        add hl,de
        jr c,.25
        sbc hl,de
        push hl
        push bc
        pop hl
        call decimal_number
        ld (ix+0),'.'
        pop hl
        ld a,l
        add a,$30
        ld (ix+1),a
        ld (ix+2),' '
        ld (ix+3),'a'
        ld (ix+4),'v'
        ld (ix+5),'g'
        ld (ix+6),'.'
        ld (ix+7),'f'
        ld (ix+8),'r'
        ld (ix+9),'a'
        ld (ix+10),'m'
        ld (ix+11),'e'
        ld (ix+12),'s'
        ld (ix+13),0
        ld hl,buffer
        ld de,$1320
        ld a,$1e
        call show_message

        ld ix,buffer
        ld (ix+0),$7e
        ld (ix+1),'='
        ld bc,(total)
        ld a,(frames_per_sec)
        cp 60
        ld de,167
        jr z,$+5
        ld de,200
        ld hl,0
.26:    ld a,b
        or c
        jr z,.27
        add hl,de
        dec bc
        jr .26

.27:
        ld bc,-1
        ld de,-10
.33:    inc bc
        add hl,de
        jr c,.33
        sbc hl,de
        ld h,b
        ld l,c

        ld bc,-1
        ld de,-10
.28:    inc bc
        add hl,de
        jr c,.28
        sbc hl,de
        inc ix
        inc ix
        push hl
        push bc
        pop hl
        call decimal_number
        ld (ix+0),'.'
        pop hl
        ld a,l
        add a,$30
        ld (ix+1),a
        ld (ix+2),' '
        ld (ix+3),'m'
        ld (ix+4),'s'
        ld (ix+5),'.'
        ld (ix+6),0
        ld hl,buffer
        ld de,$1440
        ld a,$1e
        call show_message

        ld hl,.message_7
        ld de,$0940
        ld a,$1e
        call show_message

        ld hl,.message_8
        ld de,$0a40
        ld a,$1e
        call show_message

        ld hl,.message_9
        ld de,$0c40
        ld a,$4e
        call show_message

        ld a,(frames_per_sec)
        cp 60
        ld hl,.message_10
        jr z,$+5
        ld hl,.message_11
        ld de,$0d40
        ld a,$4e
        call show_message

        ld hl,(total)
        ld de,5
        or a
        sbc hl,de
        jr nc,.29
        ld hl,(total)
        ld a,h
        or l
        ld hl,.message_15
        jr z,$+5
        ld hl,.message_14
        ld de,$1520
        ld a,$ce
        call show_message
.29:
.loop2:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jp z,.loop2

        ld a,15
        ld (debounce),a

        jp video_menu

.sprtoscr:
        call .sprtoscr1
.sprtoscr1:
        call nmi_off
        push de
        push hl
        ld bc,8
        call LDIRVM
        pop hl
        ld bc,8
        add hl,bc
        pop de
        inc d
        push de
        push hl
        ld bc,8
        call LDIRVM
        pop hl
        ld bc,8
        add hl,bc
        pop de
        dec d
        ld a,e
        add a,8
        ld e,a
        jp nmi_on

.fixed:
        db $4f,$70,$00,$0f
        db $4f,$80,$04,$0f
        db $5f,$70,$08,$0f
        db $5f,$80,$0c,$0f

.message_1:
        db "Press left-side button when the sprite is",0
.message_2:
        db "aligned with the background.",0
.message_3:
        db "Negative values means you pressed",0
.message_4:
        db "prematurely.",0
.message_5:
        db "+",0
.message_6:
        db "------",0
.message_7:
        db "Keep in mind this",0
.message_8:
        db "isn't a lag test.",0
.message_9:
        db "A frame is around",0
.message_10:
        db "16.7 ms.",0
.message_11:
        db "20.0 ms.",0

.message_14:
        db "EXCELLENT REFLEXES!",0
.message_15:
        db "INCREDIBLE REFLEXES!",0

        ;
        ; Draw Stripes.
        ;
draw_stripes:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR

        xor a
        ld (alternate),a
        ld (invert),a
        ld (field),a
        ld (dframe),a
        ld (cframe),a
        ld a,$ff
        ld (oldbuttons),a
        halt
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3

.1:
        halt
        ld a,(alternate)
        ld b,a
        ld a,(invert)
        or b
        jr z,.2
        ld a,(field)
        or a
        jr z,.3
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        xor a
        ld (field),a
        jr .4

.3:
        ld hl,.stripesneg
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        ld a,1
        ld (field),a
.4:
        xor a
        ld (invert),a
.2:
        ld a,(dframe)
        or a
        jr z,.9
        ld hl,buffer
        ld (hl),'F'
        inc hl
        ld (hl),'r'
        inc hl
        ld (hl),'a'
        inc hl
        ld (hl),'m'
        inc hl
        ld (hl),'e'
        inc hl
        ld (hl),':'
        inc hl
        ld (hl),' '
        inc hl
        ld a,(cframe)
        rrca
        rrca
        rrca
        rrca
        and $0f
        add a,$30
        ld (hl),a
        inc hl
        ld a,(cframe)
        and $0f
        add a,$30
        ld (hl),a
        ld hl,buffer
        ld de,$3816
        ld bc,$0009
        call LDIRVM
        ld a,(cframe)
        add a,1         ; cannot be inc a
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (cframe),a
        jr .5

.9:
        ld hl,$3816
        ld bc,$0009
        xor a
        call FILVRM
.5:
        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 6,b
        jr z,.6
        ld a,(alternate)
        xor 1
        ld (alternate),a

.6:
        bit 7,b
        jr z,.7
        ld a,(alternate)
        or a
        jr nz,.7
        ld a,1
        ld (invert),a
.7:
        bit 4,b
        jr z,.8
        ld a,(dframe)
        xor 1
        ld (dframe),a
        xor a
        ld (frame),a
        ld a,(dframe)
        or a
        jr nz,.8
        ld a,(field)
        xor 1
        ld (field),a
        ld a,1
        ld (invert),a
.8:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp video_menu

.stripespos:
        db $00,$ff,$00,$ff,$00,$ff,$00,$ff
.stripesneg:
        db $ff,$00,$ff,$00,$ff,$00,$ff,$00

        ;
        ; Backlit Zone Test
        ;
backlit_zone_test:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        ld hl,.void
        ld de,$0000
        ld bc,$0008
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,.void_color
        ld de,$2000
        ld bc,$0008
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,$3800
        ld bc,$0300
        xor a
        call nmi_off
        call FILVRM
        call nmi_on

        call ENASCR
        xor a
        ld (alternate),a
        ld a,1
        ld (invert),a
        call .define
        ld a,$70
        ld (x),a
        xor a
        ld (x2),a
        ld a,$50
        ld (y),a
        xor a
        ld (y2),a

.1:
        ld a,(invert)
        or a
        ld a,$d1
        jr z,.9
        ld a,(y)
        ld l,a
        ld a,(y2)
        ld h,a
        dec hl
        ld a,l
.9:
        ld (buffer),a
        ld a,(x)
        ld l,a
        ld a,(x2)
        ld h,a
        ld c,$0f
        bit 7,h
        jr z,.2
        ld de,$0020
        add hl,de
        ld c,$8f
.2:     ld a,l
        ld (buffer+1),a
        xor a
        ld (buffer+2),a
        ld a,c
        ld (buffer+3),a

        halt
        ld hl,buffer
        ld de,$3f80
        ld bc,$0004
        call LDIRVM

        call read_joystick_button_debounce
        bit 0,a
        jr nz,.4
        push af
        ld a,(y)
        ld l,a
        ld a,(y2)
        ld h,a
        dec hl
        ld de,$fff8
        or a
        sbc hl,de
        add hl,de
        jr nz,$+5
        ld hl,$00b7
        ld a,l
        ld (y),a
        ld a,h
        ld (y2),a
        pop af
.4:
        bit 1,a
        jr nz,.5
        push af
        ld a,(x)
        ld l,a
        ld a,(x2)
        ld h,a
        inc hl
        ld de,$00f8
        or a
        sbc hl,de
        add hl,de
        jr nz,$+5
        ld hl,$fff9
        ld a,l
        ld (x),a
        ld a,h
        ld (x2),a
        pop af
.5:
        bit 2,a
        jr nz,.6
        push af
        ld a,(y)
        ld l,a
        ld a,(y2)
        ld h,a
        inc hl
        ld de,$00b8
        or a
        sbc hl,de
        add hl,de
        jr nz,$+5
        ld hl,$fff9
        ld a,l
        ld (y),a
        ld a,h
        ld (y2),a
        pop af
.6:
        bit 3,a
        jr nz,.7
        push af
        ld a,(x)
        ld l,a
        ld a,(x2)
        ld h,a
        dec hl
        ld de,$fff8
        or a
        sbc hl,de
        add hl,de
        jr nz,$+5
        ld hl,$00f7
        ld a,l
        ld (x),a
        ld a,h
        ld (x2),a
        pop af
.7:     bit 6,a
        jr nz,.8
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        inc a
        and 3
        ld (alternate),a
        call .define
        jp .1
.8:
        bit 7,a
        jr nz,.10
        ld a,15
        ld (debounce),a
        ld a,(invert)
        xor 1
        ld (invert),a
        jp .1
.10:
        cpl
        and $20
        jp z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp video_menu

.define:
        ld hl,.block
        ld a,(alternate)
        rrca
        rrca
        rrca
        ld e,a
        ld d,0
        add hl,de
        ld de,$1800
        ld bc,$0020
        call nmi_off
        call LDIRVM
        jp nmi_on

.void:
        db $00,$00,$00,$00,$00,$00,$00,$00
.void_color:
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
.block:
        db $00,$00,$00,$00,$00,$00,$00,$01
        db $01,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$80
        db $80,$00,$00,$00,$00,$00,$00,$00

        db $00,$00,$00,$00,$00,$00,$03,$03
        db $03,$03,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$c0,$c0
        db $c0,$c0,$00,$00,$00,$00,$00,$00

        db $00,$00,$00,$00,$00,$07,$07,$07
        db $07,$07,$07,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$e0,$e0,$e0
        db $e0,$e0,$e0,$00,$00,$00,$00,$00

        db $00,$00,$00,$00,$0f,$0f,$0f,$0f
        db $0f,$0f,$0f,$0f,$00,$00,$00,$00
        db $00,$00,$00,$00,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$00,$00,$00,$00

