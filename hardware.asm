        ;
        ; 240p test suite (hardware tests unit)
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/20/2023.
        ;

menu_hardware:
        dw $0820
        db "*Controller Test",0
        dw $0920
        db "*BIOS data",0
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
        jp z,controller_test
        cp 1
        jp z,bios_test
        cp 2
        jp z,memory_viewer

        jp main_menu

controller_test:
        call clean_menu

        ld hl,hardware_msg_2
        ld de,$0820
        ld a,$4e
        call show_message
        ld hl,hardware_msg_3
        ld de,$0920
        ld a,$4e
        call show_message
        ld hl,hardware_msg_4
        ld de,$0a20
        ld a,$4e
        call show_message
        ld hl,hardware_msg_5
        ld de,$0b20
        ld a,$4e
        call show_message
        ld hl,hardware_msg_6
        ld de,$0d20
        ld a,$1e
        call show_message
        ld hl,hardware_msg_7
        ld de,$0e20
        ld a,$1e
        call show_message
.0:
        halt

        out (KEYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        ld ix,buffer
        call generate_hex
        ld (ix+0),0

        ld hl,buffer
        ld de,$0860
        ld a,$1e
        call show_message

        out (KEYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY2)
        ld ix,buffer
        call generate_hex
        ld (ix+0),0

        ld hl,buffer
        ld de,$0960
        ld a,$1e
        call show_message

        out (JOYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        ld ix,buffer
        call generate_hex
        ld (ix+0),0

        ld hl,buffer
        ld de,$0a60
        ld a,$1e
        call show_message

        out (JOYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY2)
        ld ix,buffer
        call generate_hex
        ld (ix+0),0

        ld hl,buffer
        ld de,$0b60
        ld a,$1e
        call show_message

        call read_joystick_button_debounce
        and $c0
        jr nz,.0

        ld a,15
        ld (debounce),a
        jp hardware_menu

bios_test:
        call clean_menu

        ld hl,hardware_msg_1
        ld de,$0820
        ld a,$4e
        call show_message

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

hardware_msg_2:
        db "Keypad 1:",0
hardware_msg_3:
        db "Keypad 2:",0
hardware_msg_4:
        db "Stick 1:",0
hardware_msg_5:
        db "Stick 2:",0

hardware_msg_6:
        db "Press both side-buttons",0
hardware_msg_7:
        db "to exit",0

