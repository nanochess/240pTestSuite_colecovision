        ;
        ; 240p test suite (hardware tests unit)
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/20/2023.
        ; Revision date: Dec/27/2023. Coleco controller test now shows
        ;                             graphical display for controllers.
        ;

menu_hardware:
    if COLECO
        dw $0820
        db "*Controller Test",0
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

bios_test:
        call clean_menu

        ld hl,hardware_msg_1
        ld de,$0820
        ld a,$4e
        call show_message

    if COLECO
        call crc32_init
        ld hl,$0000
        ld bc,$2000
        call crc32_calculate
        call crc32_final
    endif
        ; Not enabled, as databases are based on a SHA1 hash.
    if MSX
        ld a,$c9
	ld ($fd9a),a
        ld a,(bios_rom)
        ld h,$40
        call ENASLT     ; Map into $4000-$7FFF
        call crc32_init
        ld hl,$0000
        ld bc,$8000
        call crc32_calculate
        call crc32_final
        ld a,(cartridge_rom)
        ld h,$40
        call ENASLT     ; Map into $4000-$7FFF
        ld a,$c3
	ld ($fd9a),a
    endif

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

    if COLECO
        ld ix,goodcol_data
        ld b,4
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
        ld de,$0a20
        ld a,$1e
        call show_message

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
        call DISSCR
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
        and $c0
        jp z,.5
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

        ;
        ; Data from https://github.com/SnowflakePowered/opengood/
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

hardware_msg_1:
        db "BIOS CRC32:",0
hardware_msg_5:
        db "   1           2",0
hardware_msg_6:
        db "Press both side-buttons",0
hardware_msg_7:
        db "to exit",0

