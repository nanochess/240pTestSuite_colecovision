        ;
        ; 240p test suite (test patterns)
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/22/2023.
        ; Revision date: Dec/23/2023. Added grid, white, and sharpness
        ;                             patterns.
        ;

menu_patterns:
        dw $0820
        db "*Color Bleed Check",0
        dw $0920
        db "*Circles",0
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

patterns_menu:
        call clean_menu
        ld hl,menu_patterns
        call build_menu

        or a
        jp z,patterns_color_bleed
        dec a
        jp z,patterns_circles
        dec a
        jp z,patterns_grid
        dec a
        jp z,patterns_white
        dec a
        jp z,patterns_sharpness
        dec a
        jp z,patterns_vdp_color_bars
        
        jp main_menu

patterns_color_bleed:
        call DISSCR
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

patterns_circles:
        call DISSCR
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

        call reload_menu
        jp patterns_menu

patterns_grid:
        call DISSCR
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
        call DISSCR
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
        call DISSCR
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

        call reload_menu
        jp patterns_menu

sharpness0:
        incbin "sharpness0.bin"
sharpness1:
        incbin "sharpness1.bin"

patterns_vdp_color_bars:
        call DISSCR
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

.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.1
        ld a,15
        ld (debounce),a

        call reload_menu
        jp patterns_menu

circles_bin:
        incbin "circles0.bin"

bars0_dat:
        incbin "bars1.dat",$0400,$0080
bars1_dat:
        incbin "bars1.dat",$0c00,$0080
bars2_dat:
        incbin "bars1.dat",$1000,$0300

