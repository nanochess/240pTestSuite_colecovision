        ;
        ; 240p test suite
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
        ; Revision date: Dec/22/2023. Moved patterns test to its own file.
        ; Revision date: Dec/25/2023. Now it works in MSX.
        ; Revision date: Dec/26/2023. Added minimal support for audio.
        ; Revision date: Dec/28/2023. It can exit menus with #. Now it works
        ;                             in SG1000, also added my font bitmaps
        ;                             because SG1000 doesn't have any.
        ; Revision date: Jan/03/2024. Added my logo at the start.
        ; Revision date: Jan/04/2024. Added Audio Sync Test.
        ;
            
COLECO: equ 0   ; Define this to 1 for Colecovision
MSX:    equ 0   ; Define this to 1 for MSX
SG1000: equ 1   ; Define this to 1 for SG1000

BASE_MENU:      equ $0820

        ;
        ; MSX2 definitions.
        ;
BASE_MENU2:     equ $2410
MSX2_SPRITE_SAT:equ $fe00
RG9SAV:         equ $ffe9
RG11SAV:        equ $ffeb

ram_base:       equ $E000-$7000*COLECO-$2000*SG1000
VDP:            equ $98+$26*COLECO+$26*SG1000
                         
PSG:    equ $ff-$80*SG1000
JOY1:   equ $fc-$20*SG1000
JOY2:   equ $ff-$22*SG1000

    if COLECO
                              
        fname "suitecv.rom"

TURN_OFF_SOUND: EQU $1FD6

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

    if SG1000

        fname "suitesg.rom"

        org $0000

        di
        im 1
        jp START

        db $ff,$ff

        jp $0000        ; rst $08
        db $ff,$ff,$ff,$ff,$ff

        jp $0000        ; rst $10
        db $ff,$ff,$ff,$ff,$ff

        jp $0000        ; rst $18
        db $ff,$ff,$ff,$ff,$ff

        jp $0000        ; rst $20
        db $ff,$ff,$ff,$ff,$ff

        jp $0000        ; rst $28
        db $ff,$ff,$ff,$ff,$ff

        jp $0000        ; rst $30
        db $ff,$ff,$ff,$ff,$ff

        jp nmi_handler  ; rst $38

        ds $66-$,$ff

        push af
        ld a,1
        ld (sg1000_pause),a
        pop af
        retn            ; NMI handler (pause)

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
WRTPSG: EQU $0093       ; Write PSG, A=Reg. E=Data
RSLREG: EQU $0138       ; Read slot status in A
SNSMAT: EQU $0141       ; Read keyboard matrix (row in A, output in A)

        ;
        ; Get slot mapping
        ; B = 16K bank (0 for $0000, 1 for $4000, 2 for $8000, 3 for $c000)
        ; A = Current slot selection status (CALL RSLREG)
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

        ;
        ; Detect a MSX2.
        ; Returns Carry flag set if it is MSX2.
        ;
is_it_msx2:
        ld a,($002d)
        cp 1
        ccf
        ret

        ;
        ; Set palette for MSX2/MSX2+/MSX-Turbo R.
        ; HL = Pointer to palette (16 colors, each 2 bytes)
        ;
set_palette:
        di
        xor a           ; Palette index.
        out ($99),a
        ld a,$90        ; Register 16: Palette index.
        out ($99),a
        ld bc,$209a     ; 32 bytes thru port $9A.
        otir
        ei
        ret

        ;
        ; Default MSX2 palette
        ;
        ; Color format:
        ;
        ; bit 7 6 5 4 3 2 1 0
        ;     0 r r r 0 b b b - byte 0
        ;     0 0 0 0 0 g g g - byte 1
msx2_default_palette:
        db $00,$00
        db $00,$00
        db $11,$06
        db $33,$07
        db $17,$01
        db $27,$03
        db $51,$01
        db $27,$06
        db $71,$01
        db $73,$03
        db $61,$06
        db $64,$06
        db $11,$04
        db $65,$02
        db $55,$05
        db $77,$07

msx2_logo_palette:
        db $00,$00      ; 0 - Transparent
        db $00,$00      ; 1 - Black
        db $30,$02      ; 2 - Hair.
        db $33,$06      ; 3 - Bright green
        db $06,$00      ; 4 - Deep blue.
        db $27,$03      ; 5 - Blue.
        db $54,$01      ; 6 - Dark red.
        db $27,$06      ; 7 - Cyan.
        db $75,$03      ; 8 - Red.
        db $62,$03      ; 9 - Dark yellow.
        db $60,$05      ; 10 - Yellow.
        db $64,$06      ; 11 - Bright yellow.
        db $00,$04      ; 12 - Dark green.
        db $55,$00      ; 13 - Purple.
        db $63,$05      ; 14 - Gray.
        db $77,$07      ; 15 - White.

msx2_title_palette:
        db $00,$00      ; 0 - Transparent
        db $00,$00      ; 1 - Black
        db $22,$02      ; 2 - Darker gray.
        db $31,$02      ; 3 - Coat.
        db $05,$00      ; 4 - Deep blue.
        db $27,$03      ; 5 - Blue.
        db $51,$01      ; 6 - Dark red.
        db $41,$03      ; 7 - Light-Bright coat.
        db $30,$02      ; 8 - Coat.
        db $52,$04      ; 9 - Bright coat.
        db $63,$04      ; 10 - Skin.
        db $75,$06      ; 11 - Bright skin.
        db $11,$01      ; 12 - Almost black.
        db $44,$00      ; 13 - Purple.
        db $33,$03      ; 14 - Dark gray.
        db $77,$07      ; 15 - White.

msx2_donna_palette:
        db $00,$00      ; 0 - Transparent
        db $00,$00      ; 1 - Black
        db $52,$02      ; 2 - Hair.
        db $64,$04      ; 3 - Light hair.
        db $24,$02      ; 4 - Deep blue pants.
        db $46,$04      ; 5 - Blue pants.
        db $52,$03      ; 6 - Dark skin.
        db $70,$05      ; 7 - Pupil.
        db $75,$06      ; 8 - Skin.
        db $76,$07      ; 9 - Light skin.
        db $71,$05      ; 10 - Dark shirt.
        db $74,$07      ; 11 - Shirt.
        db $20,$00      ; 12 - Dark hair.
        db $57,$05      ; 13 - Background.
        db $33,$03      ; 14 - Dark gray.
        db $77,$07      ; 15 - White.

msx2_smpte_palette:
        db $00,$00      ; 0 - Transparent
        db $11,$11      ; 1 - Black
        db $55,$15      ; 2 - 
        db $51,$05      ; 3 - 
        db $15,$05      ; 4 - 
        db $11,$05      ; 5 - 
        db $55,$01      ; 6 - 
        db $51,$01      ; 7 - 
        db $15,$01      ; 8 - 
        db $11,$00      ; 9 - Ultra black.
        db $77,$07      ; 10 - 100% white.
        db $02,$01      ; 11 - 4% above black.
        db $00,$00      ; 12 - 3.5
        db $11,$01      ; 13 - 7.5
        db $22,$02      ; 14 - 11.5
        db $77,$07      ; 15 - White.

SETWRT3:
        ld a,d
        and $c0
        rlca
        rlca
        out (VDP+1),a
        ld a,$8e
        out (VDP+1),a
        ld a,e
	out (VDP+1),a
        ld a,d
        and $3f
	or $40
	out (VDP+1),a
	ret

SETWRT2:
        ld a,h
        and $c0
        rlca
        rlca
        out (VDP+1),a
        ld a,$8e
        out (VDP+1),a
	ld a,l
	out (VDP+1),a
	ld a,h
        and $3f
	or $40
	out (VDP+1),a
	ret

SETRD2:
        ld a,h
        and $c0
        rlca
        rlca
        out (VDP+1),a
        ld a,$8e
        out (VDP+1),a
        ld a,l
        out (VDP+1),a
        ld a,h
        and $3f
        out (VDP+1),a
        nop
        ret

WRTVRM2:
	push af
        call SETWRT2
	pop af
	out (VDP),a
	ret

RDVRM2:
        call SETRD2
        push af
        pop af
        in a,(VDP)
        ret

FILVRM2:
	push af
        call SETWRT2
        dec bc
        inc c
        ld a,b
        ld b,c
        inc a
        ld c,a
        pop af
.1:     out (VDP),a
        djnz $-2
        dec c
        jp nz,.1
	ret

LDIRVM2:
        ex de,hl
        call SETWRT2
        ex de,hl
        dec bc
        inc c
        ld a,b
        ld b,c
        inc a
        ld c,VDP
.1:     otir
        dec a
        jp nz,.1
        RET

LDIRVM2S:
        ex de,hl
        call SETWRT2
        ex de,hl
        ld c,VDP
.1:     otir
        RET

LDIRMV2:
        call SETRD2
        ex de,hl
        dec bc
        inc c
        ld a,b
        ld b,c
        inc a
        ld c,VDP
.1:     inir
        dec a
        jp nz,.1
        ret

convert_menu2:
        inc d
        sla d
        sla d
        srl e
        ret

draw_letter2:
        push hl
        push de
        sub $20
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld bc,font_bitmaps
        add hl,bc
        ex af,af'
        ld c,a
        ex af,af'
        ld a,c
        exx
        and $f0
        ld h,a
        rrca
        rrca
        rrca
        rrca
        ld l,a
        exx
        pop de
        push de
        ld b,8
.1:
        di
        call SETWRT3
        ld a,(hl)
        inc hl
        exx
        ld d,a
        rl d
        ld b,$e0
        jr nc,$+3
        ld b,h
        rl d
        ld a,$0e
        jr nc,$+3
        ld a,l
        or b
        out (VDP),a
        rl d
        ld b,$e0
        jr nc,$+3
        ld b,h
        rl d
        ld a,$0e
        jr nc,$+3
        ld a,l
        or b
        out (VDP),a
        rl d
        ld b,$e0
        jr nc,$+3
        ld b,h
        rl d
        ld a,$0e
        jr nc,$+3
        ld a,l
        or b
        out (VDP),a
        exx
        ei
        ld a,e
        add a,$80
        ld e,a
        jr nc,$+3
        inc d
        djnz .1
        pop hl
        inc hl
        inc hl
        inc hl
        ex de,hl
        pop hl
        ret

clear_sprites2:
        call nmi_off
        ld hl,MSX2_SPRITE_SAT
        ld a,$d8
	ld bc,$0080
        call FILVRM2
        jp nmi_on

        ;
        ; Pletter-0.5c decompressor (XL2S Entertainment & Team Bomba)
        ;
unpack2:
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
        ld hl,.modes
        add hl,de
        ld c,(hl)
        inc hl
        ld b,(hl)
        push bc
        pop ix
        ld e,1
	exx
        ld iy,.loop

; Main depack loop
.literal:
        call nmi_off
.literal2:
        ex af,af'
        call SETWRT3
        ld a,(hl)
	out (VDP),a
        inc hl
        inc de
        ex af,af'
.loop:   add a,a
        call z,.getbit
        jr nc,.literal2
        call nmi_on

; Compressed data
	exx
        ld h,d
        ld l,e
.getlen: add a,a
        call z,.getbitexx
        jr nc,.lenok
.lus:    add a,a
        call z,.getbitexx
        adc hl,hl
        ret c   
        add a,a
        call z,.getbitexx
        jr nc,.lenok
        add a,a
        call z,.getbitexx
        adc hl,hl
        ret c  
        add a,a
        call z,.getbitexx
        jr c,.lus
.lenok:  inc hl
	exx
        ld c,(hl)
        inc hl
        ld b,0
        bit 7,c
        jr z,.offsok
        jp (ix)

.mode6:  add a,a
        call z,.getbit
        rl b
.mode5:  add a,a
        call z,.getbit
        rl b
.mode4:  add a,a
        call z,.getbit
        rl b
.mode3:  add a,a
        call z,.getbit
        rl b
.mode2:  add a,a
        call z,.getbit
        rl b
        add a,a
        call z,.getbit
        jr nc,.offsok
        or a
        inc b
        res 7,c
.offsok: inc bc
        push hl
	exx
        push hl
	exx
        ld l,e
        ld h,d
        sbc hl,bc
        pop bc
        ex af,af'
        call nmi_off
.loop2:
        call SETRD2
        push af
        pop af
        in a,(VDP)
	push af
        call SETWRT3
	pop af
	out (VDP),a
        inc hl         
        inc de         
        dec bc         
        ld a,b         
        or c           
        jp nz,.loop2    
        call nmi_on

        ex af,af'
        pop hl
        jp (iy)

.getbit: ld a,(hl)
        inc hl
	rla
	ret

.getbitexx:
	exx
        ld a,(hl)
        inc hl
	exx
	rla
	ret

.modes:
        dw      .offsok
        dw      .mode2
        dw      .mode3
        dw      .mode4
        dw      .mode5
        dw      .mode6

        include "scc.asm"

    endif

        db "Powered by @nanochess :) Coding started Dec/20/2023",0

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
        ; bit 4 = 0 = *
        ; bit 5 = 0 = #
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
        cp $09          ; Key *
        jr nz,$+4
        res 4,b
        cp $06          ; Key #
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
        or a            ; Space?
        jr z,$+4
        res 6,b

        ld a,4
        call SNSMAT
        bit 2,a         ; M?
        jr nz,$+4
        res 7,b

        ld a,5
        call SNSMAT
        bit 7,a         ; Z?
        jr nz,$+4
        res 4,b

        bit 5,a         ; X?
        jr nz,$+4
        res 5,b

        ld a,1
        push bc
        call GTTRIG
        pop bc
        or a            ; Button 1 of joystick 1?
        jr z,$+4
        res 6,b
        
        ld a,2
        push bc
        call GTTRIG
        pop bc
        or a            ; Button 1 of joystick 2?
        jr z,$+4
        res 6,b
        
        ld a,3
        push bc
        call GTTRIG
        pop bc
        or a            ; Button 2 of joystick 1?
        jr z,$+4
        res 7,b
        
        ld a,4
        push bc
        call GTTRIG
        pop bc
        or a            ; Button 2 of joystick 2?
        jr z,$+4
        res 7,b
        
        ld a,b
        pop hl
        pop de
        pop bc
    endif
    if SG1000
        push bc
        ld b,$ff
        in a,(JOY1)
        bit 0,a
        jr nz,$+4
        res 0,b
        bit 1,a
        jr nz,$+4
        res 2,b
        bit 2,a
        jr nz,$+4
        res 3,b
        bit 3,a
        jr nz,$+4
        res 1,b
        bit 4,a
        jr nz,$+4
        res 6,b
        bit 5,a
        jr nz,$+4
        res 7,b

        bit 6,a
        jr nz,$+4
        res 0,b
        bit 7,a
        jr nz,$+4
        res 2,b

        in a,(JOY2)
        bit 0,a
        jr nz,$+4
        res 3,b
        bit 1,a
        jr nz,$+4
        res 1,b
        bit 2,a
        jr nz,$+4
        res 4,b
        bit 3,a
        jr nz,$+4
        res 5,b

        ld a,(sg1000_pause)
        or a
        jr z,$+4
        res 5,b
        xor a
        ld (sg1000_pause),a

        ld a,b
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
    if SG1000
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
    if SG1000
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
        ld hl,(frame)
        inc hl
        ld (frame),hl

        in a,(VDP+1)
        ei
        ret
    endif
    if SG1000
        push af
        push hl
        ld hl,(frame)
        inc hl
        ld (frame),hl
        pop hl
        in a,(VDP+1)
        pop af
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

    endif
    if MSX
        di
        xor a
        ld ($5000),a
        inc a
        ld ($7000),a
        inc a
        ld ($9000),a
        inc a
        ld ($b000),a

	ld sp,stack
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
        ld b,0          ; $0000-$3fff
        call get_slot_mapping
        ld (bios_rom),a
        call RSLREG
        ld b,1          ; $4000-$7fff
        call get_slot_mapping
        ld (cartridge_rom),a
        ld h,$80
        call ENASLT     ; Map into $8000-$BFFF
        call detect_fm
        ld a,(fm_enabled)
        or a
        call nz,init_fm

        call detect_scc
        ld a,(scc_enabled)
        or a
        call nz,init_scc

	; Sound guaranteed to be off
        ld hl,nmi_handler
	ld ($fd9b),hl
	ld a,$c3
	ld ($fd9a),a
    endif
    if SG1000
        ld sp,STACK
        ld a,$9f
        out (PSG),a
        ld a,$bf
        out (PSG),a
        ld a,$df
        out (PSG),a
        ld a,$ff
        out (PSG),a
        call vdp_no_interrupt
        call vdp_no_interrupt

        ;
        ; Clear memory
        ;
        ld hl,STACK-1
        xor a
.2:     ld (hl),a
        dec hl
        bit 2,h
        jr z,.2

        ld a,60         ; SG1000 is Japanese, always 60 frames per second.
        ld (frames_per_sec),a

    endif

;       call init_sound

logo_screen:
        call vdp_mode_2
    if MSX
        call is_it_msx2
        ld hl,msx2_logo_palette
        call c,set_palette
    endif
        ld hl,nanochess_dat
        ld de,$0400
        ld bc,$37*8
        call nmi_off
        call LDIRVM3
        call nmi_on

        ld hl,nanochess_dat+$37*8
        ld de,$2400
        ld bc,$37*8
        call nmi_off
        call LDIRVM3
        call nmi_on

        ld hl,nanochess_dat+$37*8*2
        ld de,$38ea
        ld b,7
.1:     push bc
        push hl
        push de
        ld bc,$000d
        call nmi_off
        call LDIRVM
        call nmi_on
        pop hl
        ld bc,$0020
        add hl,bc
        ex de,hl
        pop hl
        ld bc,$000d
        add hl,bc
        pop bc
        djnz .1

        ld b,180
        halt
        djnz $-1

title_screen:
    if MSX
        call is_it_msx2
        jr nc,.1
        call fast_vdp_mode_4
        jr .2
.1:
    endif
        call fast_vdp_mode_2
.2:
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

        jp main_menu

audio_menu:
        call clean_menu
    if MSX
        ld a,(fm_enabled)
        or a
        jr z,.0
        ld de,$1220
        ld hl,audio_0
        ld a,$4e
        call show_message
.0:
        ld a,(scc_enabled)
        or a
        jr z,.4
        ld de,$1320
        ld hl,audio_4
        ld a,$4e
        call show_message
.4:

        ld hl,mdfourier_menu_flags
        set 0,(hl)

        ld a,(fm_enabled)
        or a
        jr z,$+4
        set 1,(hl)

        ld a,(scc_enabled)
        or a
        jr z,$+4
        set 2,(hl)

        ld a,(hl)
        cp 1
        ld hl,menu_audio_1
        ld de,menu_audio_1_jp
        ld b,4
        jr z,.1
        cp 3
        ld hl,menu_audio_3
        ld de,menu_audio_3_jp
        ld b,5
        jr z,.1
        cp 5
        ld hl,menu_audio_5
        ld de,menu_audio_5_jp
        ld b,5
        jr z,.1
        ld hl,menu_audio_7
        ld de,menu_audio_7_jp
        ld b,7
.1:
        push bc
        push de
        call build_menu
        pop de
        pop bc
        cp b
        jr c,$+4
        ld a,b
        dec a

        add a,a
        ld l,a
        ld h,0
        add hl,de
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        jp (hl)
    endif
    if COLECO+SG1000
        ld hl,menu_audio
        call build_menu
        or a
        jp z,audio_test
        dec a
        jp z,audio_sync_test
        dec a
        jp z,audio_mdfourier
   
        jp main_menu
    endif

        ;
        ; Audio MDFourier
        ;
    if MSX
audio_mdfourier_7:
        ld a,7
        ld (mdfourier_test_flags),a
        jp audio_mdfourier

audio_mdfourier_5:
        ld a,5
        ld (mdfourier_test_flags),a
        jp audio_mdfourier

audio_mdfourier_3:
        ld a,3
        ld (mdfourier_test_flags),a
        jp audio_mdfourier

audio_mdfourier_1:
        ld a,1
        ld (mdfourier_test_flags),a
    endif

audio_mdfourier:
        call clean_menu

    if MSX
        ld a,(mdfourier_test_flags)
        ld hl,mdfourier_test_1
        cp 1
        jr z,.0
        ld hl,mdfourier_test_3
        cp 3
        jr z,.0
        ld hl,mdfourier_test_5
        cp 5
        jr z,.0
        ld hl,mdfourier_test_7
.0:
    endif
    if COLECO+SG1000
        ld hl,mdfourier_test_0
    endif
        ld de,$0a20
        ld a,$de
        call show_message
        ld de,$0c20
        ld hl,audio_1
        ld a,$1e
        call show_message_multiline

.1:
        halt
        call read_joystick_button_debounce
        cpl
        bit 5,a
        jp nz,.4
        and $c0
        jr z,.1
        ld a,15
        ld (debounce),a

        ld de,$0f20
        ld hl,audio_5
        ld a,$1e
        call show_message

        call mdfourier

        call clean_menu
        ld de,$0c20
        ld hl,audio_3
        ld a,$1e
        call show_message

.2:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jr z,.2
        bit 5,a
        jp nz,.4

.3:     ld a,15
        ld (debounce),a
        jp audio_mdfourier

.4:     ld a,15
        ld (debounce),a
        jp audio_menu

    if MSX
audio_0:
        db "FM detected.",0
audio_4:
        db "SCC detected.",0
    endif

audio_1:
        db "Start recording then,"
    if COLECO
        db "press side-button.",0
    endif
    if MSX
        db "press button.",0
    endif
    if SG1000
        db "press button.",0
    endif
audio_5:
        db "Running tests...",0
audio_3:
        db "MDFourier complete.",0

        ;
        ;
        ; Audio test, approximately 1000 hz.
        ;
audio_test:
        ld hl,112
        call set_freq
        ld a,12
        call set_volume

.1:
        halt
        call read_joystick_button_debounce
        cpl
        and $e0
        jp z,.1

        ld a,0
        call set_volume

        ld a,15
        ld (debounce),a
        jp audio_menu

        ;
        ; Audio Sync Test.
        ;
audio_sync_test:
    if MSX
        call is_it_msx2
        call c,fast_vdp_mode_2
    else
        call DISSCR
    endif
        call clear_sprites
        call highres
        ld hl,.void
        ld de,$0000
        ld bc,$0088
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,.void_color
        ld de,$2000
        ld bc,$0088
        call nmi_off
        call LDIRVM3
        call nmi_on
        ld hl,$3800
        ld bc,$0300
        xor a
        call nmi_off
        call FILVRM
        call nmi_on
        ld hl,.block
        ld de,$1800
        ld bc,$0020
        call nmi_off
        call LDIRVM
        call nmi_on

        ld hl,$3a80
        ld bc,$0020
        ld a,$01
        call nmi_off
        call FILVRM
        call nmi_on
        call ENASCR

        xor a
        ld (pause),a

        ld a,$78
        ld (x),a
        ld a,$58
        ld (y),a
        ld a,1
        ld (direction),a
.1:
        ld a,(y)
        dec a
        ld (buffer),a
        ld a,(x)
        ld (buffer+1),a
        xor a
        ld (buffer+2),a
        ld a,$0f
        ld (buffer+3),a

        halt
        call play_beep
        ld a,(y)
        cp $94
        ld bc,$0f07
        jr z,$+5
        ld bc,$0107
        call WRTVDP
        ld hl,buffer
        ld de,$3f80
        ld bc,$0004
        call LDIRVM
        call .build_bars
        ld hl,buffer
        ld de,$3900
        ld bc,32
        call LDIRVM
        ld hl,buffer
        ld de,$3920
        ld bc,32
        call LDIRVM

        ld a,(pause)
        or a
        jr nz,.3
        ld a,(direction)
        ld b,a
        ld a,(y)
        add a,b
        ld (y),a
        cp $58
        jr z,.4
        cp $94
        jr nz,.5
        ld a,1
        ld (beep),a
.4:     ld a,(direction)
        neg
        ld (direction),a
.5:

.3:

        call read_joystick_button_debounce
        bit 6,a
        jr nz,.2
        ld a,15
        ld (debounce),a
        ld a,(pause)
        xor 1
        ld (pause),a
        jp .1
.2:
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
        jp audio_menu

.build_bars:
        ld hl,buffer
        ld b,32
        xor a
        ld (hl),a
        inc hl
        djnz $-2
        ld hl,buffer
        ld de,buffer+31
        ld a,(y)
        sub $18
        push af
        srl a
        srl a
        srl a
        ld b,a
        ld a,$01
.b1:    ld (hl),a
        inc hl
        ld (de),a
        dec de
        djnz .b1
        pop af
        and 7
        xor 7
        inc a
        ld (hl),a
        add a,8
        ld (de),a
        ret

.void:
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        db $fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe
        db $fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
        db $f8,$f8,$f8,$f8,$f8,$f8,$f8,$f8
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0
        db $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
        db $80,$80,$80,$80,$80,$80,$80,$80
        db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        db $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
        db $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
        db $1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
        db $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        db $07,$07,$07,$07,$07,$07,$07,$07
        db $03,$03,$03,$03,$03,$03,$03,$03
        db $01,$01,$01,$01,$01,$01,$01,$01
.void_color:
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
.block:
        db $00,$00,$00,$00,$0f,$0f,$0f,$0f
        db $0f,$0f,$0f,$0f,$00,$00,$00,$00
        db $00,$00,$00,$00,$f0,$f0,$f0,$f0
        db $f0,$f0,$f0,$f0,$00,$00,$00,$00

        include "hardware.asm"

        include "patterns.asm"

        include "video.asm"

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
        dw $0928
        db $de,"Artemio Urbina",0
        dw $0a30
        db $1e,"@artemio",0
        dw $0c20
        db $4e
    if COLECO
        db "Colecovision Developer:",0
    endif
    if MSX
        db "MSX1/2 Developer:",0
    endif
    if SG1000
        db "SG1000 Developer:",0
    endif
        dw $0d28
        db $de,"Oscar Toledo G.",0
        dw $0e30
        db $1e,"@nanochess",0
        dw $1020
        db $4e,"Donna Art:",0
        dw $1060
        db $de,"@pepe_salot",0
        dw $1120
        db $4e,"Menu Art:",0
        dw $1160
        db $de,"@Aftasher",0
        dw $1220
        db $4e,"SDK:",0
        dw $1240
        db $de,"tniASM v0.44+Edit",0
        dw $1320
        db $4e,"Using this suite:",0
        dw $1420
        db $de,"http://junkerhq.net/xrgb",0
        dw $1520
        db $ce,"Build date: Jan/27/2024",0
        dw $0000

reload_menu:
        call DISSCR

        ld bc,$0107
        call nmi_off
        call WRTVDP
        call nmi_on

    if MSX
        call is_it_msx2
        jp nc,.1
        call clear_sprites2
        ld a,4
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,title_msx2
        ld de,$0000
        call unpack2
        ld a,2
        ld ($9000),a
        inc a
        ld ($b000),a
        ld hl,msx2_title_palette
        call set_palette
        jp ENASCR
.1:
    endif
        ld bc,$0e02
        call nmi_off
        call WRTVDP
        call nmi_on

        call clear_sprites
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
        ld bc,$0010
        call nmi_off
        call LDIRVM
        call nmi_on

        call clean_menu

        jp ENASCR

decimal_number:
        ld b,0
        ld de,10000
        call .1
        ld de,1000
        call .1
        ld de,100
        call .1
        ld de,10
        call .1
        ld de,1
        ld b,1
.1:     ld a,'0'-1
.2:     inc a
        or a
        sbc hl,de
        jr nc,.2
        add hl,de
        cp '0'
        jr nz,.3
        ld a,b
        or a
        ret z
        ld a,'0'
.3:
        ld (ix+0),a
        inc ix
        ld b,1
        ret

load_letters:
        ld hl,font_bitmaps
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
    if MSX
        call is_it_msx2
        jp nc,.0
        ld hl,BASE_MENU2
        ld b,$0e*8
.2:     push bc
        push hl
        ld bc,$0048
        ld a,$ee
        call nmi_off
        call FILVRM2
        call nmi_on
        pop hl
        ld bc,$0080
        add hl,bc
        pop bc
        djnz .2
        ret

.0:        
    endif
        ld hl,BASE_MENU
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
        and $e5
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

.5:     bit 5,d
        jr nz,.3
        ld a,15
        ld (debounce),a
        ld a,$ff                ; Menu abort.
        ret

.3:
        ld a,15
        ld (debounce),a
        ld a,c
        ret

illuminate_menu:
        push bc
        push de
        push hl
        push af
    if MSX
        call is_it_msx2
        jp nc,.0
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        inc hl          ; Avoid first character
        call convert_menu2
        ld bc,0
.3:
        ld a,(hl)
        or a
        jr z,.4
        inc c
        inc c
        inc c
        inc hl
        jr .3

.4:     pop af
        and $f0
        ld h,a
        rrca
        rrca
        rrca
        rrca
        ld l,a
        push hl
        exx
        pop hl
        exx
        ld a,8
.5:     push af
        push de
        ex de,hl
        ld de,bitmap_letters
        push bc
        di
        call LDIRMV2
        ei
        pop bc
        push bc
        exx
        push hl
        exx
        pop de
        ld hl,bitmap_letters
        ld b,c
.6:     ld a,(hl)
        cp $ee
        jp z,.7
        and $f0
        cp $e0
        jp z,.8
        ld a,(hl)
        and $0f
        or d
        ld (hl),a
        xor d
        cp $0e
        jp z,.7
.8:     ld a,(hl)
        and $f0
        or e
        ld (hl),a
.7:     inc hl
        djnz .6
        pop bc
        pop de
        ld hl,bitmap_letters
        push de
        push bc
        di
        call LDIRVM2
        ei
        pop bc
        pop de
        ld a,e
        add a,$80
        ld e,a
        jr nc,$+3
        inc d
        pop af
        dec a
        jr nz,.5
        pop hl
        pop de
        pop bc
        ret
.0:
    endif
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

    if COLECO+SG1000
menu_audio:
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*"
mdfourier_test_0:
        db "MDFourier",0
        dw $0c20
        db "*Back to Main Menu",0
        dw $0000
    endif

    if MSX
menu_audio_1:
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*MDFourier PSG",0
        dw $0c20
        db "*Back to Main Menu",0
        dw $0000

menu_audio_1_jp:
        dw audio_test
        dw audio_sync_test
        dw audio_mdfourier_1
        dw main_menu

menu_audio_3:
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*MDFourier PSG",0
        dw $0b20
        db "*MDFourier PSG+FM",0
        dw $0d20
        db "*Back to Main Menu",0
        dw $0000

menu_audio_3_jp:
        dw audio_test
        dw audio_sync_test
        dw audio_mdfourier_1
        dw audio_mdfourier_3
        dw main_menu

menu_audio_5:
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*MDFourier PSG",0
        dw $0b20
        db "*MDFourier PSG+SCC",0
        dw $0d20
        db "*Back to Main Menu",0
        dw $0000

menu_audio_5_jp:
        dw audio_test
        dw audio_sync_test
        dw audio_mdfourier_1
        dw audio_mdfourier_5
        dw main_menu

menu_audio_7:
        dw $0820
        db "*Sound Test",0
        dw $0920
        db "*Audio Sync Test",0
        dw $0a20
        db "*"
mdfourier_test_1:
        db "MDFourier PSG",0
        dw $0b20
        db "*"
mdfourier_test_3:
        db "MDFourier PSG+FM",0
        dw $0c20
        db "*"
mdfourier_test_5:
        db "MDFourier PSG+SCC",0
        dw $0d20
        db "*"
mdfourier_test_7:
        db "MDFourier PSG+SCC+FM",0
        dw $0f20
        db "*Back to Main Menu",0
        dw $0000

menu_audio_7_jp:
        dw audio_test
        dw audio_sync_test
        dw audio_mdfourier_1
        dw audio_mdfourier_3
        dw audio_mdfourier_5
        dw audio_mdfourier_7
        dw main_menu
    endif

        ;
        ; HL = Pointer to multiline string (separated with comma).
        ; DE = Pointer to VRAM.
        ; A = Color.
        ;
show_message_multiline:
        push af
.3:     push de
        ld de,buffer
.2:
        ld a,(hl)
        or a
        jr z,.1
        cp $2c
        jr z,.1
        ld (de),a
        inc hl
        inc de
        jr .2

.1:     xor a
        ld (de),a
        pop de
        pop af
        push af
        push hl
        push de
        ld hl,buffer
        call show_message
        pop de
        inc d
        pop hl
        ld a,(hl)
        inc hl
        or a
        jr nz,.3
        pop af
        ret

show_message_vdp2:
        ex af,af'
        ld a,(hl)
        or a
        ret z
        jr show_message.5

        ;
        ; HL = Pointer to string (terminated with zero byte).
        ; DE = Pointer to VRAM.
        ; A = Color.
        ;
show_message:
        ; Needed to avoid a zero byte update (turning into 65536 bytes).
        ex af,af'
        ld a,(hl)
        or a    ; Nothing to show?
        ret z   ; No, return.
    if MSX
        call is_it_msx2
        jr nc,.5
        call convert_menu2
.6:
        ld a,(hl)
        inc hl
        or a
        ret z
        call draw_letter2
        jr .6
        
    endif
.5:
        ex af,af'

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

draw_letter:
        push hl
        sub $20
        push bc
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld bc,font_bitmaps
        add hl,bc

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

        ; My personal font for TMS9928.
        ;
        ; Patterned after the TMS9928 programming manual 6x8 letters
        ; with better lowercase letters, also I made a proper
        ; AT sign.
        ;
font_bitmaps:
        db $00,$00,$00,$00,$00,$00,$00,$00      ; $20 space
        db $20,$20,$20,$20,$20,$00,$20,$00      ; $21 !
        db $50,$50,$50,$00,$00,$00,$00,$00      ; $22 "
        db $50,$50,$f8,$50,$f8,$50,$50,$00      ; $23 #
        db $20,$78,$a0,$70,$28,$f0,$20,$00      ; $24 $
        db $c0,$c8,$10,$20,$40,$98,$18,$00      ; $25 %
        db $40,$a0,$40,$a0,$a8,$90,$68,$00      ; $26 &
        db $60,$20,$40,$00,$00,$00,$00,$00      ; $27 '
        db $10,$20,$40,$40,$40,$20,$10,$00      ; $28 (
        db $40,$20,$10,$10,$10,$20,$40,$00      ; $29 )
        db $00,$a8,$70,$20,$70,$a8,$00,$00      ; $2a *
        db $00,$20,$20,$f8,$20,$20,$00,$00      ; $2b +
        db $00,$00,$00,$00,$00,$60,$20,$40      ; $2c ,
        db $00,$00,$00,$fc,$00,$00,$00,$00      ; $2d -
        db $00,$00,$00,$00,$00,$00,$60,$00      ; $2e .
        db $00,$08,$10,$20,$40,$80,$00,$00      ; $2f /
        db $70,$88,$98,$a8,$c8,$88,$70,$00      ; $30 0
        db $20,$60,$20,$20,$20,$20,$f8,$00      ; $31 1
        db $70,$88,$08,$10,$60,$80,$f8,$00      ; $32 2
        db $70,$88,$08,$30,$08,$88,$70,$00      ; $33 3
        db $30,$50,$90,$90,$f8,$10,$10,$00      ; $34 4
        db $f8,$80,$f0,$08,$08,$08,$f0,$00      ; $35 5
        db $30,$40,$80,$f0,$88,$88,$70,$00      ; $36 6
        db $f8,$08,$10,$20,$20,$20,$20,$00      ; $37 7
        db $70,$88,$88,$70,$88,$88,$70,$00      ; $38 8
        db $70,$88,$88,$78,$08,$10,$60,$00      ; $39 9
        db $00,$00,$00,$60,$00,$60,$00,$00      ; $3a :
        db $00,$00,$00,$60,$00,$60,$20,$40      ; $3b ;
        db $10,$20,$40,$80,$40,$20,$10,$00      ; $3c <
        db $00,$00,$f8,$00,$f8,$00,$00,$00      ; $3d =
        db $08,$04,$02,$01,$02,$04,$08,$00      ; $3e >
        db $70,$88,$08,$10,$20,$00,$20,$00      ; $3f ?
        db $70,$88,$98,$a8,$98,$80,$70,$00      ; $40 @
        db $20,$50,$88,$88,$f8,$88,$88,$00      ; $41 A
        db $f0,$88,$88,$f0,$88,$88,$f0,$00      ; $42 B
        db $70,$88,$80,$80,$80,$88,$70,$00      ; $43 C
        db $f0,$88,$88,$88,$88,$88,$f0,$00      ; $44 D
        db $f8,$80,$80,$f0,$80,$80,$f8,$00      ; $45 E
        db $f8,$80,$80,$f0,$80,$80,$80,$00      ; $46 F
        db $70,$88,$80,$b8,$88,$88,$70,$00      ; $47 G
        db $88,$88,$88,$f8,$88,$88,$88,$00      ; $48 H
        db $70,$20,$20,$20,$20,$20,$70,$00      ; $49 I
        db $08,$08,$08,$08,$88,$88,$70,$00      ; $4A J
        db $88,$90,$a0,$c0,$a0,$90,$88,$00      ; $4B K
        db $80,$80,$80,$80,$80,$80,$f8,$00      ; $4C L
        db $88,$d8,$a8,$a8,$88,$88,$88,$00      ; $4D M
        db $88,$c8,$c8,$a8,$98,$98,$88,$00      ; $4E N
        db $70,$88,$88,$88,$88,$88,$70,$00      ; $4F O
        db $f0,$88,$88,$f0,$80,$80,$80,$00      ; $50 P
        db $70,$88,$88,$88,$88,$a8,$90,$68      ; $51 Q
        db $f0,$88,$88,$f0,$a0,$90,$88,$00      ; $52 R
        db $70,$88,$80,$70,$08,$88,$70,$00      ; $53 S
        db $f8,$20,$20,$20,$20,$20,$20,$00      ; $54 T
        db $88,$88,$88,$88,$88,$88,$70,$00      ; $55 U
        db $88,$88,$88,$88,$50,$50,$20,$00      ; $56 V
        db $88,$88,$88,$a8,$a8,$d8,$88,$00      ; $57 W
        db $88,$88,$50,$20,$50,$88,$88,$00      ; $58 X
        db $88,$88,$88,$70,$20,$20,$20,$00      ; $59 Y
        db $f8,$08,$10,$20,$40,$80,$f8,$00      ; $5A Z
        db $78,$60,$60,$60,$60,$60,$78,$00      ; $5B [
        db $00,$80,$40,$20,$10,$08,$00,$00      ; $5C \
        db $F0,$30,$30,$30,$30,$30,$F0,$00      ; $5D ]
        db $20,$50,$88,$00,$00,$00,$00,$00      ; $5E 
        db $00,$00,$00,$00,$00,$00,$f8,$00      ; $5F _
        db $40,$20,$10,$00,$00,$00,$00,$00      ; $60 
        db $00,$00,$68,$98,$88,$98,$68,$00      ; $61 a
        db $80,$80,$f0,$88,$88,$88,$f0,$00      ; $62 b
        db $00,$00,$78,$80,$80,$80,$78,$00      ; $63 c
        db $08,$08,$68,$98,$88,$98,$68,$00      ; $64 d
        db $00,$00,$70,$88,$f8,$80,$70,$00      ; $65 e
        db $30,$48,$40,$e0,$40,$40,$40,$00      ; $66 f
        db $00,$00,$78,$88,$88,$78,$08,$70      ; $67 g
        db $80,$80,$f0,$88,$88,$88,$88,$00      ; $68 h
        db $20,$00,$60,$20,$20,$20,$70,$00      ; $69 i
        db $08,$00,$18,$08,$88,$88,$70,$00      ; $6a j
        db $80,$80,$88,$90,$e0,$90,$88,$00      ; $6b k
        db $60,$20,$20,$20,$20,$20,$70,$00      ; $6c l
        db $00,$00,$d0,$a8,$a8,$a8,$a8,$00      ; $6d m
        db $00,$00,$b0,$c8,$88,$88,$88,$00      ; $6e n
        db $00,$00,$70,$88,$88,$88,$70,$00      ; $6f o
        db $00,$00,$f0,$88,$88,$88,$f0,$80      ; $70 p
        db $00,$00,$78,$88,$88,$88,$78,$08      ; $71 q
        db $00,$00,$b8,$c0,$80,$80,$80,$00      ; $72 r
        db $00,$00,$78,$80,$70,$08,$f0,$00      ; $73 s
        db $20,$20,$f8,$20,$20,$20,$20,$00      ; $74 t
        db $00,$00,$88,$88,$88,$98,$68,$00      ; $75 u
        db $00,$00,$88,$88,$88,$50,$20,$00      ; $76 v
        db $00,$00,$88,$a8,$a8,$a8,$50,$00      ; $77 w
        db $00,$00,$88,$50,$20,$50,$88,$00      ; $78 x
        db $00,$00,$88,$88,$98,$68,$08,$70      ; $79 y
        db $00,$00,$f8,$10,$20,$40,$f8,$00      ; $7a z
        db $18,$20,$20,$40,$20,$20,$18,$00      ; $7b {
        db $20,$20,$20,$20,$20,$20,$20,$00      ; $7c |
        db $c0,$20,$20,$10,$20,$20,$c0,$00      ; $7d } 
        db $00,$00,$40,$a8,$10,$00,$00,$00      ; $7e
        db $70,$70,$20,$f8,$20,$70,$50,$00      ; $7f

        ; End of point where all code should be in bank 0 (MSX)

        ;
        ; Following this point, this code can be in another bank.
        ;

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
        ; Play beep.
        ;
play_beep:
        ld a,(beep)
        cp 1
        jr nz,.2
        ld hl,112
        call set_freq
        ld a,12
        call set_volume

.2:     ld a,(beep)
        inc a
        ld (beep),a
        cp 3
        ret nz
        ld a,0
        call set_volume
        ret

set_volume:
    if COLECO
        xor $0f
        or $90
        out (PSG),a
    endif
    if MSX
        ld e,a
        ld a,8
        call WRTPSG
    endif
    if SG1000
        xor $0f
        or $90
        out (PSG),a
    endif
        ret

set_freq:
    if COLECO
        ld a,l
        and $0f
        or $80
        out (PSG),a
        srl h
        rr l
        srl h
        rr l
        srl h
        rr l
        srl h
        rr l
        ld a,l
        out (PSG),a
    endif
    if MSX
        push hl
        ld e,l
        ld a,0
        call WRTPSG
        pop hl
        push hl
        ld e,h
        ld a,1
        call WRTPSG
        pop hl
    endif
    if SG1000
        ld a,l
        and $0f
        or $80
        out (PSG),a
        srl h
        rr l
        srl h
        rr l
        srl h
        rr l
        srl h
        rr l
        ld a,l
        out (PSG),a
    endif
        ret

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

        xor a
        ld (mode),a

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

    if MSX
        call is_it_msx2
        ld hl,msx2_default_palette
        call c,set_palette
    endif

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

	;
	; Set video display mode 2
        ; (when all the screen will be set)
	;
fast_vdp_mode_2:
	call nmi_off

        xor a
        ld (mode),a

	ld hl,mode_2_table
	ld bc,$0800
.1:	push bc
	ld b,(hl)
	call WRTVDP
	pop bc
	inc c
	inc hl
	djnz .1
    if MSX
        call is_it_msx2
        jp nc,.0
        ld a,(RG9SAV)
        res 7,a
        ld (RG9SAV),a
        ld b,a
        ld c,9          ; 192-line mode.
        call WRTVDP
        ld a,(RG11SAV)
        and $fc
        ld (RG11SAV),a
        ld b,a
        ld c,11         ; High-byte of sprite attributes address.
        call WRTVDP
        ld bc,$000e     ; Go to low bank of VRAM.
        call WRTVDP
.0:
    endif
        call nmi_on

    if MSX
        call is_it_msx2
        ld hl,msx2_default_palette
        call c,set_palette
    endif

        call clear_sprites

	ld hl,$3f00
.2:	call nmi_off
	ld bc,$0080
	xor a
	call FILVRM
	call nmi_on
	ld bc,$ff80
        add hl,bc
        ld a,h
        cp $37
        jr nz,.2

        ld hl,$1f80
.3:     call nmi_off
	ld bc,$0080
	xor a
	call FILVRM
	call nmi_on
	ld bc,$ff80
        add hl,bc
        ld a,h
        cp $17
        jr nz,.3
        ret

    if MSX
        ;
        ; Mode 4 table (high-resolution)
        ;
mode_4_table:
        DB $06          ; Register 0 - Mode 4
        DB $A2          ; Register 1 - Mode 4, turn off video, sprites 16x16
        DB $1f          ; Register 2 - Screen patterns at $0000
        DB $ff          ; Register 3 - Unused
        DB $03          ; Register 4 - Unused
        DB $ff          ; Register 5 - Sprites attributes $fc00
        DB $1e          ; Register 6 - Sprites bitmaps $f000
        DB $01          ; Register 7 - Black border

	;
        ; Set video display mode 4
	;
vdp_mode_4:
	call nmi_off

        xor a
        ld (mode),a

        ld hl,mode_4_table
	ld bc,$0800
.1:	push bc
	ld b,(hl)
	call WRTVDP
	pop bc
	inc c
	inc hl
	djnz .1

        ld a,(RG9SAV)
        set 7,a
        ld (RG9SAV),a
        ld b,a
        ld c,9          ; 212-line mode.
        call WRTVDP
        ld a,(RG11SAV)
        and $fc
        or $01
        ld (RG11SAV),a
        ld b,a
        ld c,11         ; High-byte of sprite attributes address.
        call WRTVDP
        call nmi_on

        call clear_sprites2

        ld hl,$0000
.2:	call nmi_off
	ld bc,$0080
	xor a
        call FILVRM2
	call nmi_on
        ld bc,$0080
	add hl,bc
        ld a,h
        cp $6a
        jp nz,.2

        ld hl,$ff00
.3:     call nmi_off
        ld bc,$0080
	xor a
        call FILVRM2
	call nmi_on
        ld bc,$ff80
	add hl,bc
        ld a,h
        cp $ef
        jp nz,.3

        jp ENASCR

	;
        ; Set video display mode 4
        ; (when all the screen will be set)
	;
fast_vdp_mode_4:
	call nmi_off

        xor a
        ld (mode),a

        ld hl,mode_4_table
	ld bc,$0800
.1:	push bc
	ld b,(hl)
	call WRTVDP
	pop bc
	inc c
	inc hl
	djnz .1

        ld a,(RG9SAV)
        set 7,a
        ld (RG9SAV),a
        ld b,a
        ld c,9          ; 212-line mode.
        call WRTVDP
        ld a,(RG11SAV)
        and $fc
        or $01
        ld (RG11SAV),a
        ld b,a
        ld c,11         ; High-byte of sprite attributes address.
        call WRTVDP
        call nmi_on

        call clear_sprites2

        ld hl,$ff00
.3:     call nmi_off
        ld bc,$0080
	xor a
        call FILVRM2
	call nmi_on
        ld bc,$ff80
	add hl,bc
        ld a,h
        cp $ef
        jp nz,.3
        ret

    endif

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
        ld hl,.modes
        add hl,de
        ld c,(hl)
        inc hl
        ld b,(hl)
        push bc
        pop ix
        ld e,1
	exx
        ld iy,.loop

; Main depack loop
.literal:
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
.loop:   add a,a
        call z,.getbit
        jr nc,.literal

; Compressed data
	exx
        ld h,d
        ld l,e
.getlen: add a,a
        call z,.getbitexx
        jr nc,.lenok
.lus:    add a,a
        call z,.getbitexx
        adc hl,hl
        ret c   
        add a,a
        call z,.getbitexx
        jr nc,.lenok
        add a,a
        call z,.getbitexx
        adc hl,hl
        ret c  
        add a,a
        call z,.getbitexx
        jr c,.lus
.lenok:  inc hl
	exx
        ld c,(hl)
        inc hl
        ld b,0
        bit 7,c
        jr z,.offsok
        jp (ix)

.mode6:  add a,a
        call z,.getbit
        rl b
.mode5:  add a,a
        call z,.getbit
        rl b
.mode4:  add a,a
        call z,.getbit
        rl b
.mode3:  add a,a
        call z,.getbit
        rl b
.mode2:  add a,a
        call z,.getbit
        rl b
        add a,a
        call z,.getbit
        jr nc,.offsok
        or a
        inc b
        res 7,c
.offsok: inc bc
        push hl
	exx
        push hl
	exx
        ld l,e
        ld h,d
        sbc hl,bc
        pop bc
        ex af,af'
        call nmi_off
.loop2: 
        call RDVRM              ; unpack
        ex de,hl
        call WRTVRM
        ex de,hl        ; 4
        inc hl          ; 6
        inc de          ; 6
        dec bc          ; 6
        ld a,b          ; 4
        or c            ; 4
        jr nz,.loop2     ; 10
        call nmi_on
        ex af,af'
        pop hl
        jp (iy)

.getbit: ld a,(hl)
        inc hl
	rla
	ret

.getbitexx:
	exx
        ld a,(hl)
        inc hl
	exx
	rla
	ret

.modes:
        dw      .offsok
        dw      .mode2
        dw      .mode3
        dw      .mode4
        dw      .mode5
        dw      .mode6

        ; 0- Bitmaps.
        ; 1- Colors.
        ; 2- Sprites bitmaps.
        ; 3- Sprites attribute table.
title0:
        incbin "title0.bin"
title1:
        incbin "title1.bin"
title2:
        incbin "title2.bin"
title3:
        incbin "title.dat",$3800,$0010

donna0:
        incbin "donna0.bin"
donna1:
        incbin "donna1.bin"
donna2:
        incbin "donna2.bin"
donna3:
        incbin "donna.dat",$3800,$001c

striped:
        incbin "striped.dat"
circle:
        incbin "circle.dat"
digits:
        incbin "digits.dat"
lag_per:
        incbin "lag-per.dat"
monoscope0:
        incbin "monoscope0.bin"
monoscope1:
        incbin "monoscope1.bin"

    if COLECO
controller_dat:
        incbin "controller.dat"

        include "crc32.asm"
    endif

    if MSX
        ; This should be at $8000-$bfff
msx_sha1:
        ld a,$c9
	ld ($fd9a),a
        ld a,(bios_rom)
        ld h,$40
        call ENASLT     ; Map into $4000-$7FFF
        call sha1_init
        ld hl,$0000
        ld bc,$8000

;        ld hl,$4000    ; @@@ self-SHA1 of cartridge.
;        ld bc,$8000    ; @@@

;        ld hl,sha1_test ; @@@
;        ld bc,43        ; @@@

;        ld hl,sha1_test2 ; @@@
;        ld bc,896/8       ; @@@

        call sha1_calculate
        call sha1_final
        ld a,(cartridge_rom)
        ld h,$40
        call ENASLT     ; Map into $4000-$7FFF
        ld a,$c3
	ld ($fd9a),a
        ret

        include "sha1.asm"
    endif

nanochess_dat:
        incbin "nanochess.dat",$0400,$37*8
        incbin "nanochess.dat",$0c00,$37*8
        incbin "nanochess.dat",$1000,$000d*$0007

sharpness0:
        incbin "sharpness0.bin"
sharpness1:
        incbin "sharpness1.bin"
   if 0
circles_bin:
        incbin "circles0.bin"
   endif

bars0_dat:
        incbin "bars1.dat",$0400,$0080
bars1_dat:
        incbin "bars1.dat",$0c00,$0080
bars2_dat:
        incbin "bars1.dat",$1000,$0300
bars3_dat:
        incbin "bars2.dat",$0600,$00c0
bars4_dat:
        incbin "bars2.dat",$0e00,$00c0
bars5_dat:
        incbin "bars2.dat",$1000,$0300

        include "mdfourier.asm"

    if MSX
        include "fm.asm"
    endif

rom_end:

        ds COLECO*$10000+MSX*$c000+SG1000*$8000-$,$ff

    if MSX
        forg $8000      ; Bank 2
        org $8000

title_msx2:
        incbin "titlem2.bin"
donnam2:
        incbin "donnam2.bin"
monoscopem2:
        incbin "monoscopem2.bin"
smptem2:
        incbin "smptem2.bin"
bank2_end:
        ds $4000,$ff

        forg $c000      ; Bank 3
        org $8000

        ds $4000,$ff

        forg $10000     ; Bank 4
        org $8000

        ds $4000,$ff

        forg $14000     ; Bank 5
        org $8000

        include "blue.asm"

        ds $c000-$,$ff

        forg $18000     ; Bank 6 and 7
        org $4000

        include "mame.asm"

        ds $c000-$,$ff

    endif

        org ram_base
frame:  rb 2            ; Frame counter.
mode:   rb 1            ; Current mode.
                        ; bit 0 = 1 = NMI processing disabled.
                        ; bit 1 = 1 = NMI received during NMI disabled.
frames_per_sec: rb 1    ; Frames per second.
cartridge_rom:  rb 1    ; MSX.
bios_rom:       rb 1    ; BIOS MSX.
fm_rom:         rb 1    ; BIOS FM.
fm_enabled:     rb 1
scc_rom:        rb 1    ; SCC.
scc_enabled:    rb 1
debounce:       rb 1

    if MSX
mdfourier_menu_flags:   rb 1
mdfourier_test_flags:   rb 1
    endif

    if SG1000
sg1000_pause:   rb 1
    endif

buffer:         rb 72
                          
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
hours:          rb 1    ; lag_test
minutes:        rb 1    ; lag_test
seconds:        rb 1    ; lag_test
frames:         rb 1    ; lag_test
view:           rb 1    ; timing_reflex_test
x2:             rb 1    ; timing_reflex_test
y2:             rb 1    ; timing_reflex_test
change:         rb 1    ; timing_reflex_test
vary:           rb 1    ; timing_reflex_test
variation:      rb 1    ; timing_reflex_test
pos:            rb 1    ; timing_reflex_test
total:          rb 2    ; timing_reflex_test
beep:           rb 1    ; timing_reflex_test

    if MSX
sha1_h0:        rb 4
sha1_h1:        rb 4
sha1_h2:        rb 4
sha1_h3:        rb 4
sha1_h4:        rb 4
sha1_len:       rb 2
sha1_pos:       rb 1
sha1_hcopy:     rb 20
sha1_buffer:    rb 320
    endif

bitmap_letters: equ ram_base+$0200

ram_end:

stack:  equ ram_base+$0400

