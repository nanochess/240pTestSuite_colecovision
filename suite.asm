        ;
        ; 240p test suite
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision/MSX version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/20/2023.
        ; Revision date: Dec/22/2023. Moved patterns test to its own file.
        ; Revision date: Dec/25/2023. Now it works in MSX.
        ;

COLECO: equ 1   ; Define this to 1 for Colecovision
MSX:    equ 0   ; Define this to 1 for MSX

ram_base:       equ $E000-$7000*COLECO
VDP:            equ $98+$26*COLECO
                         
TURN_OFF_SOUND: EQU $1FD6

PSG:    equ $ff
JOY1:   equ $fc
JOY2:   equ $ff

    if COLECO

        fname "suitecv.rom"

KEYSEL: equ $80
JOYSEL: equ $c0

        org $8000

        db $55,$aa

        dw $0000
        dw $0000
        dw $0000
        dw $0000
        dw START

        jp $0000        ; rst $08

        jp $0000        ; rst $10

        jp $0000        ; rst $18

        jp $0000        ; rst $20

        jp $0000        ; rst $28

        jp $0000        ; rst $30

        jp $0000        ; rst $38

        jp nmi_handler  ; NMI
    endif

    if MSX
        fname "suitemsx.rom"

        forg $0000
        org $4000
	dw $4241
	dw START	
	dw 0
	dw 0
	dw 0
        dw 0
	dw 0
	dw 0

GTSTCK: EQU $00D5       ; A= Stick to test. Output: A= Stick direction.
GTTRIG: EQU $00D8       ; A= Button to test. Output: A= Pressed state.

ENASLT: EQU $0024       ; Select slot (H=Addr, A=Slot)
WRTPSG: EQU $0093       ; Escribe PSG, A=Reg. E=Dato
RSLREG: EQU $0138       ; Read slot status in A
SNSMAT: EQU $0141       ; Read keyboard matrix (row in A, output in A)

        ;
        ; Get slot mapping
        ;
get_slot_mapping:
        call rotate_slot
        ld c,a
        add a,$C1       ; EXPTBL
        ld l,a
        ld h,$FC
        ld a,(hl)
        and $80         ; Get expanded flag
        or c
        ld c,a
        inc hl
        inc hl
        inc hl
        inc hl
        ld a,(hl)       ; SLTTBL
        call rotate_slot
        rlca
        rlca
        or c            ; A contains bit 7 = Marks expanded
                        ;            bit 6 - 4 = Doesn't care
                        ;            bit 3 - 2 = Secondary mapper
                        ;            bit 1 - 0 = Primary mapper
        ret

rotate_slot:
        push bc
        dec b
        inc b
        jr z,.1
.0:     rrca
        rrca
        djnz .0
.1:     and 3
        pop bc
        ret

    endif

SETWRT:
	ld a,l
	out (VDP+1),a
	ld a,h
	or $40
	out (VDP+1),a
	ret

SETRD:
        ld a,l
        out (VDP+1),a
        ld a,h
        out (VDP+1),a
        nop
        ret

WRTVDP:
	ld a,b
	out (VDP+1),a
	ld a,c
	or $80
	out (VDP+1),a
	ret

WRTVRM:
	push af
	call SETWRT
	pop af
	out (VDP),a
	ret

RDVRM:
        call SETRD
        ex (sp),hl
        ex (sp),hl
        in a,(VDP)
        ret

FILVRM:
	push af
	call SETWRT
.1:	pop af
	out (VDP),a
	push af
	dec bc
	ld a,b
	or c
	jp nz,.1
	pop af
	ret

LDIRVM3:
        call .1
        ld a,d
        add a,8
        ld d,a
        call .1
        ld a,d
        add a,8
        ld d,a
.1:     push bc
        push de
        push hl
        call LDIRVM
        pop hl
        pop de
        pop bc
        ret

LDIRVM:
        EX DE,HL
        CALL SETWRT
        EX DE,HL
        DEC BC
        INC C
        LD A,B
        LD B,C
        INC A
        LD C,VDP
.1:     OUTI
        JP NZ,.1
        DEC A
        JP NZ,.1
        RET

LDIRMV:
        call SETRD
        ex (sp),hl
        ex (sp),hl
.1:     in a,(VDP)
        ld (de),a
        inc de
        dec bc
        ld a,b
        or c
        jp nz,.1
        ret

        ;
        ; Main input function:
        ;
        ; Output:
        ; bit 0 = 0 = Up
        ; bit 1 = 0 = Right
        ; bit 2 = 0 = Down
        ; bit 3 = 0 = Left
        ; bit 4 = 0 = #
        ; bit 5 = 0 = *
        ; bit 6 = 0 = Left button (button A)
        ; bit 7 = 0 = Right button (button B)
        ;
read_joystick_button:
    if COLECO
        push bc
        out (KEYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        ld c,a
        or $bf
        ld b,a
        in a,(JOY2)
        push af
        and c
        ld c,a
        pop af
        or $bf
        and b
        rlca
        ld b,a
        ld a,c
        and $0f
        cp $09          ; Key #
        jr nz,$+4
        res 4,b
        cp $06          ; Key *
        jr nz,$+4
        res 5,b
        out (JOYSEL),a
        ex (sp),hl
        ex (sp),hl
        in a,(JOY1)
        or $b0
        and b
        ld b,a
        in a,(JOY2)
        or $b0
        and b
        pop bc
    endif
    if MSX
        push bc
        push de
        push hl
        xor a
        call GTSTCK
        or a
        jp nz,.1
        ld a,1
        call GTSTCK
        or a
        jp nz,.1
        ld a,2
        call GTSTCK
.1:     ld hl,joystick_to_bits
        ld e,a
        ld d,0
        add hl,de
        ld b,(hl)

        ld a,0
        push bc
        call GTTRIG
        pop bc
        or a
        jr z,$+4
        res 6,b

        ld a,4
        call SNSMAT
        bit 2,a
        jr nz,$+4
        res 7,b

        ld a,5
        call SNSMAT
        bit 7,a
        jr nz,$+4
        res 4,b

        bit 5,a
        jr nz,$+4
        res 5,b

        ld a,1
        push bc
        call GTTRIG
        pop bc
        or a
        jr z,$+4
        res 6,b
        
        ld a,2
        push bc
        call GTTRIG
        pop bc
        or a
        jr z,$+4
        res 6,b
        
        ld a,3
        push bc
        call GTTRIG
        pop bc
        or a
        jr z,$+4
        res 7,b
        
        ld a,4
        push bc
        call GTTRIG
        pop bc
        or a
        jr z,$+4
        res 7,b
        
        ld a,b
        pop hl
        pop de
        pop bc
    endif
        ret

joystick_to_bits:
        db $ff,$fe,$fc,$fd,$f9,$fb,$f3,$f7,$f6

read_joystick_button_debounce:
        ld a,(debounce)
        or a
        jr z,.1
        dec a
        ld (debounce),a
        ld a,$ff
        ret

.1:
        call read_joystick_button
        ret

        ;
        ; Disallow NMI
        ;
nmi_off:
    if COLECO
        push hl
        ld hl,mode
        set 0,(hl)
        pop hl
    endif
    if MSX
        di
    endif
        ret

        ;
        ; Allow NMI
        ;
nmi_on:
    if COLECO
        push hl
        ld hl,mode
        res 0,(hl)
        nop
        bit 1,(hl)
        pop hl
        ret z
        push af
        push hl
        ld hl,mode
        res 1,(hl)
        jp nmi_handler.1
    endif
    if MSX
        ei
        ret
    endif

        ;
        ; Handle NMI
        ;
nmi_handler:
    if COLECO
        push af
        push hl
        ld hl,mode
        bit 0,(hl)
        jr z,.1
        set 1,(hl)
        pop hl
        pop af
        retn

.1:     push bc
        push de
        push ix

;        call emit_sound         

        ld hl,mode
        bit 3,(hl)
        jr z,.3
        ;
        ; Load sprite attribute table
        ;
        ld hl,$3f80
        call SETWRT
        ld hl,sprites
        ld bc,128*256+VDP
        outi
        jp nz,$-2
.3:

;        call generate_sound

        ld hl,(frame)
        inc hl
        ld (frame),hl

        pop ix
        pop de
        pop bc
        pop hl
        in a,(VDP+1)
        pop af
        retn
    endif
    if MSX
;        call emit_sound         

        ld hl,mode
        bit 3,(hl)
        jr z,.3m
        ;
        ; Load sprite attribute table
        ;
        ld hl,$3f80
        call SETWRT
        ld hl,sprites
        ld bc,128*256+VDP
        outi
        jp nz,$-2
.3m:

;        call generate_sound

        ld hl,(frame)
        inc hl
        ld (frame),hl

        in a,(VDP+1)
        ei
        ret
    endif

vdp_no_interrupt:
        ld a,$82
        out (VDP+1),a
        ld a,$81
        out (VDP+1),a
        nop
        nop
        in a,(VDP+1)
        ret

START:
    if COLECO
        di
        ld sp,STACK
        call TURN_OFF_SOUND
        call vdp_no_interrupt
        call vdp_no_interrupt

        ;
        ; Clear memory
        ;
        ld hl,STACK-1
        xor a
.1:     ld (hl),a
        dec hl
        bit 2,h
        jr z,.1
    
        ld a,($0069)    ; Colecovision region info.
        ld (frames_per_sec),a

        ld hl,($006c)   ; Colecovision letters BIOS.
        ld de,$ff80     ; Back to point to space character.
        add hl,de
        ld (letters_bitmaps),hl
    endif
    if MSX
	ld sp,stack
	; Sound guaranteed to be off
        ld hl,nmi_handler
	ld ($fd9b),hl
	ld a,$c3
	ld ($fd9a),a
        ;
        ; Clear memory
        ;
        ld hl,STACK-1
        xor a
.1m:    ld (hl),a
        dec hl
        bit 5,h
        jr nz,.1m
    
        ld a,($002b)
        bit 7,a
        ld a,60
        jr z,$+4
        ld a,50
        ld (frames_per_sec),a
        call RSLREG
        ld b,1          ; $4000-$7fff
        call get_slot_mapping
        ld h,$80
        call ENASLT     ; Map into $8000-$BFFF

        ld hl,($0004)   ; MSX letters BIOS.
        ld de,$0100     ; Point to space character.
        add hl,de
        ld (letters_bitmaps),hl
    endif

;       call init_sound

title_screen:
        call vdp_mode_2

        call reload_menu

main_menu:
        call clean_menu
        ld hl,menu_main
        call build_menu

        ld a,c
        or a
        jp z,patterns_menu
        dec a
        jp z,video_menu
        dec a
        jp z,audio_menu
        dec a
        jp z,hardware_menu
        dec a
        jp z,credits_menu

        jp bug_warning

audio_menu:
        call clean_menu
        ld hl,menu_audio
        call build_menu

        jp main_menu

        include "patterns.asm"

        include "video.asm"

        include "hardware.asm"

credits_menu:
        call clean_menu
        ld hl,credits_text
        call show_multiple_messages
.4:
        halt
        call read_joystick_button_debounce
        cpl
        and $c0
        jr z,.4
        ld a,15
        ld (debounce),a

        jp main_menu

credits_text:
        dw $0820
        db $4e,"Original Software:",0
        dw $0920
        db $1e,"Artemio Urbina",0
        dw $0a20
        db $4e
    if COLECO
        db "Colecovision Developer:",0
    endif
    if MSX
        db "MSX1 Developer:",0
    endif
        dw $0b20
        db $1e,"Oscar Toledo G.",0
        dw $0c20
        db $4e,"Menu Pixel Art:",0
        dw $0d20
        db $1e,"Asher",0
        dw $0e20
        db $4e,"SDK:",0
        dw $0f20
        db $1e,"tniASM v0.44+DOS Edit",0
        dw $1020
        db $4e,"Using this suite:",0
        dw $1120
        db $1e,"http://junkerhq.net/xrgb",0
        dw $1520
        db $fe,"Build date: Dec/25/2023",0
        dw $0000

reload_menu:
        call DISSCR

        ld bc,$0107
        call nmi_off
        call WRTVDP
        call nmi_on
        call highres
        ld hl,title0
        ld de,$0000
        call unpack
        ld hl,title1
        ld de,$2000
        call unpack
        ld hl,title2
        ld de,$1800
        call unpack
        ld hl,title3
        ld de,$3f80
        ld bc,$0018
        call nmi_off
        call LDIRVM
        call nmi_on

        call clean_menu

        jp ENASCR

bug_warning:
        ld hl,bug_1
        ld de,$0410
        ld a,$f6
        call show_message
        jr $

bug_1:
        db "You have found a bug :P",0

load_letters:
        ld hl,(letters_bitmaps)
        ld de,$0100
        ld bc,$0300
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,$2000
        ld bc,$1800
        ld a,$21
        call nmi_off
        call FILVRM
        jp nmi_on

clean_menu:
        ld hl,$0820
        ld b,$0e
.1:     push bc
        push hl
        ld bc,$0090
        xor a
        call nmi_off
        call FILVRM
        call nmi_on
        pop hl
        push hl
        set 5,h
        ld bc,$0090
        ld a,$1e
        call nmi_off
        call FILVRM
        call nmi_on
        pop hl
        inc h
        pop bc
        djnz .1
        ret

        ;
        ; Show multiple messages
        ;
show_multiple_messages:
.2:
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        ret z
        ld a,(hl)
        inc hl
        call show_message
        jr .2

        ;
        ; HL = Pointer to menu description.
        ;
build_menu:
        push hl
        ld b,0          ; Zero menu items so far.
.2:
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        jr z,.1
        ld a,$1e
        push bc
        inc hl          ; Avoid first character.
        call show_message
        pop bc
        inc b           ; Count menu items.
        jr .2

.1:     pop hl
        ld c,0          ; Current menu item.

.7:     ld a,$6e
        call illuminate_menu
.4:        
        halt
        call read_joystick_button_debounce
        ld d,a
        cpl
        and $c5
        jr z,.4

        ld a,$1e
        call illuminate_menu

        bit 0,d
        jr nz,.6
        ld a,15
        ld (debounce),a
        ld a,c
        or a
        jr z,.7
        dec c
        dec hl
        ld a,(hl)
        cp '*'
        jr nz,$-4
        dec hl
        dec hl
        jr .7

.6:     bit 2,d
        jr nz,.5
        ld a,15
        ld (debounce),a
        ld a,c
        inc a
        cp b
        jr z,.7
        inc c
        inc hl
        inc hl
        ld a,(hl)
        inc hl
        or a
        jr nz,$-3
        jr .7

.5:     ld a,15
        ld (debounce),a
        ld a,c
        ret

illuminate_menu:
        push bc
        push de
        push hl
        push af
        ld e,(hl)
        inc hl
        ld d,(hl)
        set 5,d
        inc hl
        inc hl          ; Avoid first character
        ld c,0
.1:
        ld a,(hl)
        or a
        jr z,.2
        ld a,c
        add a,6
        ld c,a
        inc hl
        jr .1

.2:     ld a,c
        add a,7
        and $f8
        ld c,a
        ld b,0
        ex de,hl
        pop af
        call nmi_off
        call FILVRM
        call nmi_on
        pop hl
        pop de
        pop bc
        ret

menu_main:
        dw $0820
        db "*Test Patterns",0
        dw $0920
        db "*Video Tests",0
        dw $0a20
        db "*Audio Tests",0
        dw $0b20
        db "*Hardware Tests",0
        dw $0d20
        db "*Credits",0
        dw $0000

menu_audio:
    if 0
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*MDFourier",0
    endif
        dw $0c20
        db "*Back to Main Menu",0
        dw $0000

        ;
        ; HL = Pointer to string (terminated with zero byte).
        ; DE = Pointer to VRAM.
        ; A = Color.
        ;
show_message:
        push af
        push de
        push hl
        ld hl,bitmap_letters
        xor a
.1:     ld (hl),a
        inc l
        ld (hl),a
        inc l
        jp nz,.1
        pop hl
        ld de,bitmap_letters
        ld b,0
.2:     ld a,(hl)
        inc hl
        or a
        jr z,.3
        call draw_letter
        jr .2

.3:    
        ld a,b
        or a
        jr z,.4
        ld a,e
        add a,8
        and $f8
        ld e,a
.4:     ld c,e
        ld b,0
        pop de
        pop af
        push hl
        push de
        push bc
        set 5,d
        ex de,hl
        call nmi_off
        call FILVRM
        call nmi_on
        pop bc
        pop de
        ld hl,bitmap_letters
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ret

patch_x:
        ld hl,.1
        ret

.1:     db $00,$00,$88,$50,$20,$50,$88,$00

draw_letter:
        push hl
        sub $20
        push bc
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld bc,(letters_bitmaps)
        add hl,bc

        cp $58          ; Patch the X
        call z,patch_x

        pop bc
        call draw_letter_generic
        ld a,6
        add a,b
        cp 8
        jr c,.1
        ld bc,8
        ex de,hl
        add hl,bc
        ex de,hl
        sub 8
.1:     ld b,a
        pop hl
        ret

        ;
        ; HL = Bitmap
        ; DE = Target
        ; B = Pixel offset
        ;
draw_letter_generic:
        push de
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        call draw_letter_line
        pop de
        ret

draw_letter_line:
        ld a,b
        push bc
        ld b,(hl)
        ld c,0
        or a
        jr z,$+10
        srl b
        rr c
        dec a
        jp nz,$-5
        ld a,(de)
        or b
        ld (de),a
        ld a,e
        add a,8
        ld e,a
        ld a,(de)
        or c
        ld (de),a
        ld a,e
        sub 7
        ld e,a
        inc hl
        pop bc
        ret

highres:
        ld hl,.0
        ld de,$3800
        ld bc,$0100
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,.0
        ld de,$3900
        ld bc,$0100
        call nmi_off
        call LDIRVM
        call nmi_on
        ld hl,.0
        ld de,$3a00
        ld bc,$0100
        call nmi_off
        call LDIRVM
        call nmi_on

        ret

.0:     db $00,$01,$02,$03,$04,$05,$06,$07
        db $08,$09,$0a,$0b,$0c,$0d,$0e,$0f
        db $10,$11,$12,$13,$14,$15,$16,$17
        db $18,$19,$1a,$1b,$1c,$1d,$1e,$1f
        db $20,$21,$22,$23,$24,$25,$26,$27
        db $28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        db $30,$31,$32,$33,$34,$35,$36,$37
        db $38,$39,$3a,$3b,$3c,$3d,$3e,$3f
        db $40,$41,$42,$43,$44,$45,$46,$47
        db $48,$49,$4a,$4b,$4c,$4d,$4e,$4f
        db $50,$51,$52,$53,$54,$55,$56,$57
        db $58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        db $60,$61,$62,$63,$64,$65,$66,$67
        db $68,$69,$6a,$6b,$6c,$6d,$6e,$6f
        db $70,$71,$72,$73,$74,$75,$76,$77
        db $78,$79,$7a,$7b,$7c,$7d,$7e,$7f
        db $80,$81,$82,$83,$84,$85,$86,$87
        db $88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        db $90,$91,$92,$93,$94,$95,$96,$97
        db $98,$99,$9a,$9b,$9c,$9d,$9e,$9f
        db $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        db $a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
        db $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7
        db $b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        db $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
        db $c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
        db $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        db $d8,$d9,$da,$db,$dc,$dd,$de,$df
        db $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7
        db $e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        db $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7
        db $f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff

        ;
        ; Mode 2 table (high-resolution)
        ;
mode_2_table:
        DB $02          ; Register 0 - Mode 2
        DB $A2          ; Register 1 - Mode 2, turn off video, sprites 16x16
        DB $0E          ; Register 2 - Screen patterns $3800
        DB $FF          ; Register 3 - Color table $2000
        DB $03          ; Register 4 - Bitmap table $0000
        DB $7F          ; Register 5 - Sprites attributes $3F80
        DB $03          ; Register 6 - Sprites bitmaps $1800
        DB $01          ; Register 7 - Black border

	;
	; Set video display mode 2
	;
vdp_mode_2:
	call nmi_off

	ld hl,mode
        ld a,(hl)
        and $80
        ld (hl),a
        inc hl          ; mode1
        ld (hl),0

	ld hl,mode_2_table
	ld bc,$0800
.1:	push bc
	ld b,(hl)
	call WRTVDP
	pop bc
	inc c
	inc hl
	djnz .1
        call nmi_on

        call clear_sprites

	ld hl,$3f00
.2:	call nmi_off
	ld bc,$0080
	xor a
	call FILVRM
	call nmi_on
	ld bc,$ff80
	add hl,bc
	bit 7,h
	jp z,.2

        ;
        ; Enable screen
        ; 
ENASCR:
	call nmi_off
	ld bc,$e201
	call WRTVDP
	jp nmi_on

        ;
        ; Disable screen
        ;
DISSCR:
	call nmi_off
	ld bc,$a201
	call WRTVDP
	jp nmi_on

clear_sprites:
        call nmi_off
	ld hl,$3f80
	ld a,$d1
	ld bc,$0080
	call FILVRM
        jp nmi_on

        ;
        ; Pletter-0.5c decompressor (XL2S Entertainment & Team Bomba)
        ;
unpack:
; Initialization
        ld a,(hl)
        inc hl
	exx
        ld de,0
        add a,a
        inc a
        rl e
        add a,a
        rl e
        add a,a
        rl e
        rl e
        ld hl,modes
        add hl,de
        ld c,(hl)
        inc hl
        ld b,(hl)
        push bc
        pop ix
        ld e,1
	exx
        ld iy,loop

; Main depack loop
literal:
        ex af,af'
        call nmi_off
        ld a,(hl)
        ex de,hl
        call WRTVRM
        ex de,hl
        inc hl
        inc de
        call nmi_on
        ex af,af'
loop:   add a,a
        call z,getbit
        jr nc,literal

; Compressed data
	exx
        ld h,d
        ld l,e
getlen: add a,a
        call z,getbitexx
        jr nc,lenok
lus:    add a,a
        call z,getbitexx
        adc hl,hl
        ret c   
        add a,a
        call z,getbitexx
        jr nc,lenok
        add a,a
        call z,getbitexx
        adc hl,hl
        ret c  
        add a,a
        call z,getbitexx
        jr c,lus
lenok:  inc hl
	exx
        ld c,(hl)
        inc hl
        ld b,0
        bit 7,c
        jr z,offsok
        jp (ix)

mode6:  add a,a
        call z,getbit
        rl b
mode5:  add a,a
        call z,getbit
        rl b
mode4:  add a,a
        call z,getbit
        rl b
mode3:  add a,a
        call z,getbit
        rl b
mode2:  add a,a
        call z,getbit
        rl b
        add a,a
        call z,getbit
        jr nc,offsok
        or a
        inc b
        res 7,c
offsok: inc bc
        push hl
	exx
        push hl
	exx
        ld l,e
        ld h,d
        sbc hl,bc
        pop bc
        ex af,af'
loop2:  call nmi_off
        call RDVRM              ; unpack
        ex de,hl
        call WRTVRM
        call nmi_on
        ex de,hl        ; 4
        inc hl          ; 6
        inc de          ; 6
        dec bc          ; 6
        ld a,b          ; 4
        or c            ; 4
        jr nz,loop2     ; 10
        ex af,af'
        pop hl
        jp (iy)

getbit: ld a,(hl)
        inc hl
	rla
	ret

getbitexx:
	exx
        ld a,(hl)
        inc hl
	exx
	rla
	ret

modes:
	dw	offsok
	dw	mode2
	dw	mode3
	dw	mode4
	dw	mode5
        dw      mode6

title0:
        incbin "title0.bin"
title1:
        incbin "title1.bin"
title2:
        incbin "title2.bin"
title3:
        incbin "title.dat",$3800,$0020

donna0:
        incbin "donna0.bin"
donna1:
        incbin "donna1.bin"
donna2:
        incbin "donna2.bin"
donna3:
        incbin "donna.dat",$3800,$0008

striped:
        incbin "striped.dat"
        
        include "crc32.asm"

rom_end:

        ds COLECO*$10000+MSX*$c000-$,$ff

        org ram_base
sprites:
        rb 128
frame:  rb 2            ; Frame counter.
mode:   rb 1            ; Current mode.
                        ; bit 0 = 1 = NMI processing disabled.
                        ; bit 1 = 1 = NMI received during NMI disabled.
frames_per_sec: rb 1    ; Frames per second.
debounce:       rb 1
letters_bitmaps:        rb 2

buffer:         rb 40
                          
alternate:      rb 1
invert:         rb 1
field:          rb 1
oldbuttons:     rb 1
dframe:         rb 1
cframe:         rb 1
speed:          rb 1    ; grid_scroll
acc:            rb 1    ; grid_scroll
x:              rb 1    ; grid_scroll
y:              rb 1    ; grid_scroll
back:           rb 1    ; grid_scroll
pause:          rb 1    ; grid_scroll
direction:      rb 1    ; grid_scroll

bitmap_letters: equ ram_base+$0100

ram_end:

stack:  equ ram_base+$0400

