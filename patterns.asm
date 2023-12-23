        ;
        ; 240p test suite (test patterns)
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/22/2023.
        ;

menu_patterns:
        dw $0820
        db "*Color Bleed Check",0
        dw $0920
        db "*Circles",0
        dw $0a20
        db "*VDP Color Bars",0
    if 0
        dw $0820
        db "*Color & Black Levels",0
        dw $0920
        db "*Geometry",0
        dw $0a20
        db "*HCFR Patterns",0
    endif
        dw $0c20
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

