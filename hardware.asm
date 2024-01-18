        ;
        ; 240p test suite (hardware tests unit)
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
        ; Revision date: Dec/27/2023. Coleco controller test now shows
        ;                             graphical display for controllers.
        ;

menu_hardware:
    if COLECO
        dw $0820
        db "*Controller Test",0
    endif
    if COLECO+MSX
        dw $0920
        db "*BIOS data",0
    endif
        dw $0a20
        db "*Memory Viewer",0
        dw $0c20
        db "*Back to Main Menu",0
        dw $0000

hardware_menu:
        call clean_menu
        ld hl,menu_hardware
        call build_menu

        or a
    if COLECO
        jp z,controller_test
        dec a
    endif
    if COLECO+MSX
        jp z,bios_test
        dec a
    endif
        jp z,memory_viewer

        jp main_menu

    if COLECO
CONTROLLER_BASE:        EQU $0928    
CONTROLLER_SEPARATION:  EQU $0020

controller_test:
        call clean_menu

        ld hl,CONTROLLER_BASE-$0100
        ld b,$0a
.1:     push bc
        push hl
        set 5,h
        ld bc,$0028+CONTROLLER_SEPARATION+$0028
        ld a,$ee
        call nmi_off
        call FILVRM
        call nmi_on
        pop hl
        pop bc
        inc h
        djnz .1

        ld hl,controller_dat
        ld de,CONTROLLER_BASE
        ld b,9
.2:     push bc
        push hl
        push de
        ld bc,$0028
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        pop de
        push de
        push hl
        ld bc,$0028+CONTROLLER_SEPARATION
        add hl,bc
        ex de,hl
        ld bc,$0028
        call nmi_off
        call LDIRVM
        call nmi_on
        pop de
        inc d
        pop hl
        ld bc,$0028
        add hl,bc
        pop bc
        djnz .2

        ld hl,controller_dat+18*40
        ld de,CONTROLLER_BASE+$2000
        ld b,9
.3:     push bc
        push hl
        push de
        ld bc,$0028
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        pop de
        push de
        push hl
        ld bc,$0028+CONTROLLER_SEPARATION
        add hl,bc
        ex de,hl
        ld bc,$0028
        call nmi_off
        call LDIRVM
        call nmi_on
        pop de
        inc d
        pop hl
        ld bc,$0028
        add hl,bc
        pop bc
        djnz .3

        ld hl,hardware_msg_5
        ld de,CONTROLLER_BASE-$0100
        ld a,$6e
        call show_message
        ld hl,hardware_msg_6
        ld de,$1320
        ld a,$1e
        call show_message
        ld hl,hardware_msg_7
        ld de,$1420
        ld a,$1e
        call show_message
        ld hl,buffer
        ld b,72
        ld (hl),0
        inc hl
        djnz $-3
.0:
        halt

        out (KEYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        ld b,a
        out (JOYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        ld c,a
        ld hl,buffer
        call .decode

        out (KEYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY2)
        ld b,a
        out (JOYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY2)
        ld c,a
        ld hl,buffer+18
        call .decode

        ld de,buffer
        ld hl,buffer+36
        ld b,18
.4:     ld a,(de)
        cp (hl)
        jr z,.5
        ld (hl),a
        push hl
        ld hl,CONTROLLER_BASE
        call .update
        pop hl
.5:     inc de
        inc hl
        djnz .4

        ld de,buffer+18
        ld hl,buffer+54
        ld b,18
.6:     ld a,(de)
        cp (hl)
        jr z,.7
        ld (hl),a
        push hl
        ld hl,CONTROLLER_BASE+$0028+CONTROLLER_SEPARATION
        call .update
        pop hl
.7:     inc de
        inc hl
        djnz .6

        call read_joystick_button_debounce
        and $c0
        jr nz,.0

        ld a,15
        ld (debounce),a
        jp hardware_menu

.decode:
        push hl
        ld a,18
        ld (hl),0
        inc hl
        dec a
        jr nz,$-4
        ld a,b
        and $0f
        ld e,a
        ld d,0
        ld hl,.table
        add hl,de
        ld a,(hl)
        or a
        pop hl
        jp m,.d1
        push hl
        ld e,a
        ld d,0
        add hl,de
        ld (hl),$01
        pop hl
.d1:    ld de,12
        add hl,de
        bit 6,b
        jr nz,$+4
        ld (hl),1
        inc hl
        bit 6,c
        jr nz,$+4
        ld (hl),1
        inc hl
        bit 0,c
        jr nz,$+4
        ld (hl),1
        inc hl
        bit 1,c
        jr nz,$+4
        ld (hl),1
        inc hl
        bit 2,c
        jr nz,$+4
        ld (hl),1
        inc hl
        bit 3,c
        jr nz,$+4
        ld (hl),1
        inc hl
        ret

.table:
        ;                  SA1
        db $ff,$08,$04,$05,$ff,$07,$0b,$02
        ;  SA2
        db $ff,$0a,$00,$09,$03,$01,$06,$ff

.update:
        push bc
        push de
        or a
        ld de,controller_dat-40
        jr z,$+5
        ld de,controller_dat+9*40-40
        push de
        push hl
        ld a,18
        sub b
        ld hl,.reference
        ld e,a
        ld d,0
        add hl,de
        ld a,(hl)
        pop hl
        pop de
        dec h
.u1:
        inc h
        ex de,hl
        ld bc,40
        add hl,bc
        ex de,hl
        sub 5
        jr nc,.u1
        add a,5
        add a,a ; x2
        add a,a ; x4
        add a,a ; x8
        ld c,a
        ld b,0
        add hl,bc
        ex de,hl
        add hl,bc
        push de
        push hl
        ld bc,$0008
        call nmi_off
        call LDIRVM
        pop hl
        pop de
        set 5,d
        ld bc,18*40
        add hl,bc
        ld bc,$0008
        call LDIRVM
        call nmi_on
        pop de
        pop bc
        ret

.reference:
        db $25,$15,$16,$17,$1a,$1b,$1c,$1f
        db $20,$21,$24,$26,$13,$0f,$02,$08
        db $0c,$06
    endif

sha1_test:
        db "The quick brown fox jumps over the lazy dog"
        ; https://www.di-mgt.com.au/sha_testvectors.html
sha1_test2:
	db "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"

bios_test:
        call clean_menu

        ld hl,hardware_msg_1
        ld de,$0820
        ld a,$4e
        call show_message
        ld hl,hardware_msg_2
        ld de,$0920
        ld a,$6e
        call show_message

    if COLECO
        call crc32_init
        ld hl,$0000
        ld bc,$2000
        call crc32_calculate
        call crc32_final
        ld ix,buffer
        ld a,d
        call generate_hex
        ld a,e
        call generate_hex
        ld a,h
        call generate_hex
        ld a,l
        call generate_hex
        ld (ix+0),0

        push de
        push hl
        ld hl,buffer
        ld de,$0920
        ld a,$1e
        call show_message
        pop hl
        pop de

    endif
        ; Not enabled, as databases are based on a SHA1 hash.
    if MSX
        call msx_sha1
        ld iy,sha1_h0
        ld ix,buffer
        ld a,(iy+0)
        call generate_hex
        ld a,(iy+1)
        call generate_hex
        ld a,(iy+2)
        call generate_hex
        ld a,(iy+3)
        call generate_hex
        ld a,(iy+4)
        call generate_hex
        ld (ix+0),' '
        inc ix
        ld a,(iy+5)
        call generate_hex
        ld a,(iy+6)
        call generate_hex
        ld a,(iy+7)
        call generate_hex
        ld a,(iy+8)
        call generate_hex
        ld a,(iy+9)
        call generate_hex
        ld (ix+0),0

        ld ix,buffer+22
        ld a,(iy+10)
        call generate_hex
        ld a,(iy+11)
        call generate_hex
        ld a,(iy+12)
        call generate_hex
        ld a,(iy+13)
        call generate_hex
        ld a,(iy+14)
        call generate_hex
        ld (ix+0),' '
        inc ix
        ld a,(iy+15)
        call generate_hex
        ld a,(iy+16)
        call generate_hex
        ld a,(iy+17)
        call generate_hex
        ld a,(iy+18)
        call generate_hex
        ld a,(iy+19)
        call generate_hex
        ld (ix+0),0

        ld hl,buffer
        ld de,$0920
        ld a,$1e
        call show_message
        ld hl,buffer+22
        ld de,$0a20
        ld a,$1e
        call show_message

    endif

    if COLECO
        ld ix,goodcol_data
        ld b,4          ; Number of signatures.
.0:
        ld a,l
        cp (ix+0)
        jr nz,.1
        ld a,h
        cp (ix+1)
        jr nz,.1
        ld a,e
        cp (ix+2)
        jr nz,.1
        ld a,d
        cp (ix+3)
        jr nz,.1
        jp .3
.1:        
        inc ix
        inc ix
        inc ix
        inc ix
        ld a,(ix+0)
        inc ix
        or a
        jr nz,$-6
        djnz .0
.3:
        inc ix
        inc ix
        inc ix
        inc ix
        push ix
        pop hl
        ld de,$0b20
        ld a,$1e
        call show_message_multiline

    endif

    if MSX
        ex af,af'
        ld a,6
        ld ($7000),a
        ex af,af'
        ld hl,$8000             ; MAME_START_DATABASE
        ld bc,MAME_ENTRIES
.8:     push bc
        ld de,sha1_h0
        ld b,20
.10:    ld a,(de)
        cp (hl)
        jp nz,.9
        inc de
        inc hl
        bit 6,h
        jr z,$+10
        res 6,h
        ex af,af'
        inc a
        ld ($7000),a
        ex af,af'
        djnz .10
        pop bc
        jr .14

.9:     ld c,b
        ld b,0
        add hl,bc
        bit 6,h
        jr z,$+10
        res 6,h
        ex af,af'
        inc a
        ld ($7000),a
        ex af,af'
.12:
        ld a,(hl)
        inc hl
        or a
        jr z,.11
        bit 6,h
        jr z,$+10
        res 6,h
        ex af,af'
        inc a
        ld ($7000),a
        ex af,af'
        jr .12
.11:
        pop bc
        dec bc
        ld a,b
        or c
        jp nz,.8
        ld bc,20
        add hl,bc
        bit 6,h
        jr z,$+10
        res 6,h
        ex af,af'
        inc a
        ld ($7000),a
        ex af,af'
.14:
        ld de,buffer
.16:
        ld a,(hl)
        or a
        jr z,.15
        ld (de),a
        inc de
        inc hl
        bit 6,h
        jr z,$+10
        res 6,h
        ex af,af'
        inc a
        ld ($7000),a
        ex af,af'
        jr .16
.15:
        xor a
        ld (de),a
        ld a,1
        ld ($7000),a

        ld hl,buffer
        ld b,24
        ld a,(hl)
        or a
        jr z,$+7
        inc hl
        djnz $-5
        ld (hl),0

        ld hl,buffer
        ld de,$1520
        ld a,$1e
        call show_message

        ld a,$05
        ld ($7000),a
        ld ix,blue_start_database
        ld c,BLUE_ENTRIES         ; Number of signatures.
.4:
        ld hl,sha1_h0
        push ix
        pop de
        ld b,20
.5:
        ld a,(de)
        cp (hl)
        jr nz,.6
        inc de
        inc hl
        djnz .5
        jp .7
.6:
        ld de,20
        add ix,de
        ld a,(ix+0)
        inc ix
        or a
        jr nz,$-6
        dec c
        jp nz,.4
.7:
        ld de,20
        add ix,de
        push ix
        pop hl
        ld de,$0c20
        ld a,$1e
        call show_message_multiline
        ld a,$01
        ld ($7000),a
    endif
.2:     halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.2
        ld a,15
        ld (debounce),a

        jp hardware_menu

        ;
        ; Memory viewer
        ;
memory_viewer:
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_2
    else
        call DISSCR
    endif
        call load_letters
        ld hl,$3800
        ld bc,$0300
        ld a,$20
        call nmi_off
        call FILVRM
        call nmi_on
        call clear_sprites
        call ENASCR

        ld hl,$0000
.1:
        push hl
        ld de,$3800
.2:     ld ix,buffer
        ld a,h
        call generate_hex
        ld a,l
        call generate_hex
        ld (ix+0),':'
        inc ix
        ld (ix+0),' '
        inc ix
        ld b,4
.3:     ld a,(hl)
        call generate_hex
        inc hl
        ld (ix+0),' '
        inc ix
        djnz .3
        ld (ix+0),' '
        inc ix
        ld b,4
.4:     ld a,(hl)
        call generate_hex
        inc hl
        ld (ix+0),' '
        inc ix
        djnz .4
        push hl
        push de
        ld hl,buffer
        ld bc,30
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ld bc,32
        add hl,bc
        ex de,hl
        pop hl
        ld bc,8
        add hl,bc
        ld a,d
        cp $3b
        jp nz,.2
        pop hl
.5:
        halt
        call read_joystick_button_debounce
        bit 0,a
        jr nz,.6
        ld a,15
        ld (debounce),a
        ld de,-384
        add hl,de
        jp .1

.6:     bit 2,a
        jr nz,.7
        ld a,15
        ld (debounce),a
        ld de,384
        add hl,de
        jp .1

.7:     cpl
        and $e0
        jp z,.5
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_4
    endif
        call reload_menu
        jp hardware_menu

generate_hex:
        push af
        rrca
        rrca
        rrca
        rrca
        call .1
        pop af
.1:
        and $0f
        add a,$30
        cp $3a
        jr c,$+4
        add a,$07
        ld (ix+0),a
        inc ix
        ret

        ; Currently a maximum of 24 characters for each description.

    if COLECO
        ;
        ; Data from https://github.com/SnowflakePowered/opengood/
        ; CRC32 hashes.
        ;
goodcol_data:
        db $f3,$3e,$a9,$3a
        db "Colecovision BIOS (1982)",0
        db $fc,$16,$bb,$39
        db "BIOS Font Hack",0
        db $76,$a4,$cd,$66
        db "BIOS No title delay",0
        db $9c,$b0,$35,$5d
        db "BIOS + CoolCV fast boot",0
        db $00,$00,$00,$00
        db "Unrecognized BIOS",0
    endif

    if MSX
        ; SHA1 hashes.
        ; Descriptions:
        ;  Maximum width = 24 characters.
        ;  Maximum height = 10 rows.
msx_data:
        ; I've one of these.
        db $e2,$fb,$d5,$6e,$42
        db $da,$63,$76,$09,$d2
        db $3a,$e9,$df,$9e,$fd
        db $1b,$42,$41,$b1,$8a
        db "Sony HB-F1XDJ MSX2+",0
        ; My National CF2000
        ; but also some other MSX computers.
        db $30,$2a,$fb,$5d,$8b
        db $e2,$6c,$75,$83,$09
        db $ca,$3d,$f6,$11,$ae
        db $69,$cc,$ed,$28,$21
        db "Canon V-8/10/20,"
        db "Casio PV-7/16,"
        db "Fujitsu FM-X,"
        db "Mitsubishi ML-F110/120,"
        db "National CF-2000,"
        db "Pionner PX-7/V60,"
        db "Sony HB-10/101/201,"
        db "Sony HB-501/701FD,"
        db "Toshiba HX-22",0

        db $89,$63,$fc,$04,$19
        db $75,$f3,$1d,$c2,$ab
        db $10,$19,$cf,$dd,$49
        db $67,$99,$9d,$e5,$3e
        db "Canon V-20E,"
        db "JVC HC-7GB,"
        db "Mitsubishi ML-F48/80,"
        db "Pioneer PX-7UK,"
        db "Sanyo Wavy MPC-10/100,"
        db "Sony HB-55P/75P,"
        db "Yamaha CX5M,"
        db "YIS-503F,"
        db "Yashica YC-64",0

        db $00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00
        db 0
    endif

hardware_msg_1:
    if COLECO
        db "BIOS CRC32:",0
    endif
    if MSX
        db "BIOS SHA1:",0
    endif
hardware_msg_2:
        db "Wait...",0
hardware_msg_5:
        db "   1           2",0
hardware_msg_6:
        db "Press both side-buttons",0
hardware_msg_7:
        db "to exit",0

