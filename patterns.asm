        ;
        ; 240p test suite (test patterns)
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
        ; Creation date: Dec/22/2023.
        ; Revision date: Dec/23/2023. Added grid, white, and sharpness
        ;                             patterns.
        ; Revision date: Dec/26/2023. Added monoscope. Optional row
        ;                             arrangement for VDP Color Bars.
        ; Revision date: Dec/27/2023. Adjusted monoscope for perfect square.
        ; Revision date: Dec/28/2023. Added third pattern for VDP Color Bars.
        ;

menu_patterns:
        dw $0820
        db "*Color Bleed Check",0
;        dw $0920
;        db "*Pretty Non-useful Circles",0
        dw $0920
        db "*Monoscope",0
        dw $0a20
        db "*Grid",0
        dw $0b20
        db "*White & Black Screens",0
        dw $0c20
        db "*Sharpness",0
        dw $0d20
        db "*VDP Color Bars",0
        dw $0f20
        db "*Back to Main Menu",0
        dw $0000

    if MSX
menu_patterns2:
        dw $0820
        db "*SMPTE Color Bars (WIP)",0
        dw $0920
        db "*Color Bleed Check",0
        dw $0a20
        db "*Monoscope",0
        dw $0b20
        db "*Grid",0
        dw $0c20
        db "*White & Black Screens",0
        dw $0d20
        db "*Sharpness",0
        dw $0e20
        db "*VDP Color Bars",0
        dw $1020
        db "*Back to Main Menu",0
        dw $0000
    endif

patterns_menu:
        call clean_menu
    if MSX
        call is_it_msx2
        jr nc,.0
        ld hl,menu_patterns2
        call build_menu
        or a
        jp z,patterns_smpte
        dec a
        jr .1
.0:
    endif

        ld hl,menu_patterns
        call build_menu

        or a
.1:
        jp z,patterns_color_bleed
;        dec a
;        jp z,patterns_circles
        dec a
        jp z,patterns_monoscope
        dec a
        jp z,patterns_grid
        dec a
        jp z,patterns_white
        dec a
        jp z,patterns_sharpness
        dec a
        jp z,patterns_vdp_color_bars
        
        jp main_menu

    if MSX
patterns_smpte:
        call DISSCR
        call clear_sprites2
        ld a,4
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,msx2_smpte_palette
        call set_palette
        ld hl,smptem2
        ld de,$0000
        call unpack2
        ld a,2
        ld ($9000),a
        inc a
        ld ($b000),a
        call ENASCR
.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

        call fast_vdp_mode_4
        call reload_menu
        jp patterns_menu
    endif

patterns_color_bleed:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        ld hl,.vertical
        ld de,$0400
        ld bc,$0028
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,.colors
        ld de,$2400
        ld bc,$0028
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,$3800
        ld bc,$0300
        ld a,$80
        call nmi_off
        call FILVRM
        call nmi_on

        ld hl,$3882
        ld a,$81
        call .three

        ld hl,$3902
        ld a,$82
        call .three

        ld hl,$3982
        ld a,$83
        call .three

        ld hl,$3a02
        ld a,$84
        call .three

        call ENASCR
        xor a
        ld (alternate),a

.1:
        halt
        call read_joystick_button_debounce
        cpl
        bit 6,a
        jr z,.2
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        xor 1
        ld (alternate),a
        ld hl,.vertical
        jr z,$+5
        ld hl,.checkerboard
        ld de,$0400
        ld bc,$0028
        call nmi_off
        call LDIRVM3
        call nmi_on
        jp .1

.2:
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

.three:
        ld b,3
.0:     push bc
        push hl
        ld bc,$001c
        call nmi_off
        call FILVRM
        call nmi_on
        pop hl
        ld bc,32
        add hl,bc
        pop bc
        djnz .0
        ret

.colors:
        db $11,$11,$11,$11,$11,$11,$11,$11
        db $61,$61,$61,$61,$61,$61,$61,$61
        db $21,$21,$21,$21,$21,$21,$21,$21
        db $41,$41,$41,$41,$41,$41,$41,$41
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1

.vertical:
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
        db $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
        db $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
        db $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa

.checkerboard:
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55

    if 0
patterns_circles:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        call nmi_off
        ld hl,$2000
        ld bc,$1800
        ld a,$f1
        call FILVRM
        call nmi_on
        ld hl,circles_bin
        ld de,$0000
        call unpack
        call ENASCR

.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu
    endif

patterns_monoscope:
    if MSX
        call is_it_msx2
        jp nc,.0
        call DISSCR
        call clear_sprites2
        ld a,4
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,msx2_default_palette
        call set_palette
        ld hl,monoscopem2
        ld de,$0000
        call unpack2
        ld a,2
        ld ($9000),a
        inc a
        ld ($b000),a
        call ENASCR
        ld a,7
        ld (alternate),a
.4:
        halt
        call read_joystick_button_debounce
        bit 1,a
        jr nz,.5
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        cp 7
        jr z,$+3
        inc a
        ld (alternate),a
        call .change_color2
        jr .4

.5:     bit 3,a
        jr nz,.6
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        or a
        jr z,$+3
        dec a
        ld (alternate),a
        call .change_color2
        jr .4

.change_color2:
        di
        ld a,$0f        ; Palette index.
        out ($99),a
        ld a,$90        ; Register 16: Palette index.
        out ($99),a
        ld a,(alternate)
        ld b,a
        ld a,(alternate)
        rlca
        rlca
        rlca
        rlca
        or b
        out ($9a),a
        and $0f
        out ($9a),a
        ei
        ret

.6:
        cpl
        and $e0
        jr z,.4
        ld a,15
        ld (debounce),a

        call fast_vdp_mode_4
        call reload_menu
        jp patterns_menu

.0:
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        ld hl,monoscope0
        ld de,$0000
        call unpack
        ld hl,monoscope1
        ld de,$2000
        call unpack
        ld hl,.vertical_line
        ld de,$1800
        ld bc,$0040
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,.vertical_sprites
        ld de,$3f80
        ld bc,16*4
        call nmi_off
        call LDIRVM
        call nmi_on
        call ENASCR
        ld a,2
        ld (alternate),a
.1:
        halt
        call read_joystick_button_debounce
        bit 1,a
        jr nz,.2
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        cp 2
        jr z,$+3
        inc a
        ld (alternate),a
        call .change_color
        jr .1

.2:     bit 3,a
        jr nz,.3
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        or a
        jr z,$+3
        dec a
        ld (alternate),a
        call .change_color
        jr .1

.3:
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

.change_color:
        ld a,(alternate)
        cp 1
        ld c,$11
        jr c,.7
        ld c,$e1
        jr z,.7
        ld c,$f1
.7:
        ld hl,$2000
        ld b,24
.8:
        call nmi_off
        call .do256
        call nmi_on
        djnz .8
        ret

.do256:
        push hl
        push bc
        ld de,bitmap_letters
        ld bc,$0100
        call LDIRMV
        pop bc
        ld hl,bitmap_letters
.loop:
        ld a,(hl)
        cp $61
        jr z,$+3
        ld (hl),c
        inc l
        jp nz,.loop
        pop hl
        push bc
        push hl
        ex de,hl
        ld hl,bitmap_letters
        ld bc,$0100
        call LDIRVM
        pop hl
        pop bc
        inc h
        ret

.vertical_line:
        db $80,$80,$80,$80,$80,$80,$80,$80
        db $80,$80,$80,$80,$80,$80,$80,$80
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00

        db $80,$80,$80,$80,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00

.vertical_sprites:
        db 38-1,77,$00,$06
        db 54-1,77,$00,$06
        db 70-1,77,$00,$06
        db 86-1,77,$00,$06
        db 102-1,77,$00,$06
        db 118-1,77,$00,$06
        db 134-1,77,$00,$06
        db 150-1,77,$04,$06
        db 38-1,178,$00,$06
        db 54-1,178,$00,$06
        db 70-1,178,$00,$06
        db 86-1,178,$00,$06
        db 102-1,178,$00,$06
        db 118-1,178,$00,$06
        db 134-1,178,$00,$06
        db 150-1,178,$04,$06

patterns_grid:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        ld hl,.grid_bitmap
        ld de,$0400
        ld bc,$0040
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,.grid_color
        ld de,$2400
        ld bc,$0040
        call nmi_off
        call LDIRVM3
        call nmi_on

        ld de,$3800
        ld b,12
.2:     push bc
        push de
        ld hl,.grid_pattern1
        ld bc,$0040
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ld bc,$0040
        add hl,bc
        ex de,hl
        pop bc
        djnz .2

        ld de,$3842
        ld b,10
.3:     push bc
        push de
        ld hl,.grid_pattern2
        ld bc,$001c
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ld bc,$0020
        add hl,bc
        push hl
        ex de,hl
        ld hl,.grid_pattern2+$001c
        ld bc,$001c
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ld bc,$0020
        add hl,bc
        ex de,hl
        pop bc
        djnz .3

        call ENASCR

.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

.grid_bitmap:
        db $ff,$80,$80,$80,$80,$80,$80,$81
        db $ff,$01,$01,$01,$01,$01,$01,$81
        db $81,$80,$80,$80,$80,$80,$80,$ff
        db $81,$01,$01,$01,$01,$01,$01,$ff
        db $ff,$80,$80,$80,$80,$80,$80,$81
        db $ff,$01,$01,$01,$01,$01,$01,$81
        db $81,$80,$80,$80,$80,$80,$80,$ff
        db $81,$01,$01,$01,$01,$01,$01,$ff

.grid_color:
        db $61,$61,$61,$61,$61,$61,$61,$61
        db $61,$61,$61,$61,$61,$61,$61,$61
        db $61,$61,$61,$61,$61,$61,$61,$61
        db $61,$61,$61,$61,$61,$61,$61,$61
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1

.grid_pattern1:
        db $80,$81,$80,$81,$80,$81,$80,$81
        db $80,$81,$80,$81,$80,$81,$80,$81
        db $80,$81,$80,$81,$80,$81,$80,$81
        db $80,$81,$80,$81,$80,$81,$80,$81

        db $82,$83,$82,$83,$82,$83,$82,$83
        db $82,$83,$82,$83,$82,$83,$82,$83
        db $82,$83,$82,$83,$82,$83,$82,$83
        db $82,$83,$82,$83,$82,$83,$82,$83

.grid_pattern2:
        db $84,$85,$84,$85,$84,$85,$84,$85
        db $84,$85,$84,$85,$84,$85,$84,$85
        db $84,$85,$84,$85,$84,$85,$84,$85
        db $84,$85,$84,$85

        db $86,$87,$86,$87,$86,$87,$86,$87
        db $86,$87,$86,$87,$86,$87,$86,$87
        db $86,$87,$86,$87,$86,$87,$86,$87
        db $86,$87,$86,$87

patterns_white:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        ld hl,.block
        ld de,$0400
        ld bc,$0008
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,.white
        ld de,$2400
        ld bc,$0008
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld bc,$0f07
        call nmi_off
        call WRTVDP
        call nmi_on
        ld hl,$3800
        ld bc,$0300
        ld a,$80
        call nmi_off
        call FILVRM
        call nmi_on
        call ENASCR
        xor a
        ld (alternate),a
.1:
        halt
        call read_joystick_button_debounce
        cpl
        bit 6,a
        jr z,.2
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        inc a
        cp 3
        jr nz,$+3
        xor a
        ld (alternate),a
        cp 1
        ld hl,.white
        ld b,$0f                ; White border color.
        jr c,.3
        ld hl,.black
        ld b,$01                ; Black border color.
        jr z,.3
        ld hl,.ultrablack
        ld b,$00                ; Transparent border color.
.3:
        ld c,$07
        call nmi_off
        call WRTVDP
        call nmi_on
        ld de,$2400
        ld bc,$0008
        call nmi_off
        call LDIRVM3
        call nmi_on
        jp .1

.2:
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

.block:
        db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
.white:
        db $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
.black:
        db $11,$11,$11,$11,$11,$11,$11,$11
.ultrablack:
        db $01,$01,$01,$01,$01,$01,$01,$01

patterns_sharpness:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        ld hl,sharpness0
        ld de,$0000
        call unpack
        ld hl,sharpness1
        ld de,$2000
        call unpack
        call ENASCR

.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

patterns_vdp_color_bars:
    if MSX
        call fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        ld hl,bars1_dat
        ld de,$2400
        ld bc,$0080
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,bars0_dat
        ld de,$0400
        ld bc,$0080
        call nmi_off
        call LDIRVM3
        call nmi_on

        ld hl,bars4_dat
        ld de,$2600
        ld bc,$00c0
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,bars3_dat
        ld de,$0600
        ld bc,$00c0
        call nmi_off
        call LDIRVM3
        call nmi_on

        ld hl,bars2_dat
        ld de,$3800
        ld bc,$0300
        call nmi_off
        call LDIRVM
        call nmi_on
        ld bc,$0007     ; Transparent border color.
        call nmi_off
        call WRTVDP
        call nmi_on
        call ENASCR

        xor a
        ld (alternate),a
.1:
        halt
        call read_joystick_button_debounce
        bit 6,a
        jr nz,.2
        ld a,15
        ld (debounce),a
        ld a,(alternate)
        inc a
        cp 3
        jr nz,$+3
        xor a
        ld (alternate),a
        cp 2
        jr z,.3
        or a
        ld hl,bars2_dat
        jr z,$+5
        ld hl,bars5_dat
        ld de,$3800
        ld bc,$0300
        call nmi_off
        call LDIRVM
        call nmi_on
        jr .1

.3:
        ld hl,$3800
        ld b,24
.4:     push bc
        push hl
        ld bc,$0008
        ld a,$c0
        call nmi_off
        call FILVRM
        pop hl
        push hl
        ld de,$0010
        add hl,de
        ld bc,$0008
        ld a,$c0
        call FILVRM
        call nmi_on
        pop hl
        ld bc,32
        add hl,bc
        pop bc
        djnz .4
        jr .1
.2:
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp patterns_menu

