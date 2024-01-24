        ;
        ; Routines for FM support in MSX
        ;
        ; Copyright (C) 2023-2024 Oscar Toledo G. @nanochess
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
        ; Creation date: Sep/28/2012.
        ;

        ; Subroutines from BIOS MSX
CALSLT:         equ $001c       ; Inter-slot call (disables interruptions)
;ENASLT:         equ $0024       ; Enable slot (H=High-byte address, C=Slot)

        ; Subroutines from OPLL ROM
WRTOPL:         equ $4110
INIOPL:         equ $4113

        ;
        ; Play note in FM
        ; A = Voice ($10 - $11 - $12)
        ; B = Instrument + Note.
        ;
play_fm:
        push bc
        push de
        ld c,a          ; Saves base register.
        ld a,b          ; Read instrument (bits 7-6)
        and $c0
        rrca
        rrca
        add a,$20
        ld e,a          ; Select instrument ($20,$30,$40,$50)
        ld a,c
        add a,$20
        push bc
        call write_fm
        pop bc
        ld a,b          ; Read note.
        and $3f
        ld hl,fm_notes
        add a,a         ; Index into note table.
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        ld a,c
        ld e,(hl)       ; Get low byte.
        push bc
        push hl
        call write_fm
        pop hl
        pop bc
        inc hl
        ld e,(hl)       ; Get high byte (octave).
        ld a,c
        add a,$10
        call write_fm
        pop de
        pop bc
        ret

        ;
        ; Detects FM (OPLL)
        ; Carry = Set = FM detected.
        ;         Clear = No FM detected.
        ;
detect_fm:
        ld a,$ff        ; FM hasn't been discovered.
        ld (fm_rom),a
        ld bc,$0000
.1:     push bc
        ld hl,$fcc1     ; EXPTBL
        ld a,l
        add a,c
        ld l,a
        ld a,(hl)
        and $80
        or c
        call find_fm    ; Search in subslots.
        pop bc
        ret nc          ; Jump if something has been found.
        inc c
        bit 2,c         ; Four slots analyzed?
        jr z,.1         ; No, jump.
        ret

fm_signature_1:     db "APRLOPLL"   ; Internal MSX-Music.
fm_signature_2:     db "PAC2OPLL"   ; FM-Pac cartridge.

find_fm:
        bit 7,a         ; Expanded slot?
        ld b,1          ; No subslots.
        jr z,.1         ; No, jump.
        and $f3
        ld b,4          ; Ok, four subslots.
.1:     ld c,a
.2:     push bc
        ld h,$40
        ld a,c
        call ENASLT
        ld hl,$4018
        push hl
        ld de,fm_signature_1
        ld b,8
.4:     ld a,(de)
        cp (hl)
        jr nz,.5
        inc de
        inc hl
        djnz .4
.5:     pop hl
        jr z,.8         ; Detected? Jump to take note.
        ld de,fm_signature_2
        ld b,8
.6:     ld a,(de)
        cp (hl)
        jr nz,.7
        inc de
        inc hl
        djnz .6
.7:     jr nz,.3        ; Not detected? Jump to next subslot.
.8:     pop bc
        ld a,c          ; Take note of slot.
        ld (fm_rom),a
        push bc
        ld a,1          ; Enable FM.
        ld (fm_enabled),a
.3:
        ; Important! The H register should be $40 here.
        ld a,(cartridge_rom)
        call ENASLT
        pop bc
        ld a,(fm_enabled)
        or a
        ret nz
        ld a,c
        add a,4
        ld c,a
        djnz .2
        scf
        ret

        ;
        ; Init FM
        ;
init_fm:
        push ix
        push iy
        call fm_rom_switch
        ld hl,$ef00
        call INIOPL
        ld hl,.0
        ld b,24
.1:     ld e,(hl)
        inc hl
        ld a,(hl)
        inc hl
        call write_fm
        djnz .1
        call cartridge_rom_switch
        pop iy
        pop ix
        ret

.0:     dw $0011        ; Unique programmable instrument (not used)
        dw $0111
        dw $0220
        dw $0320
        dw $04ff
        dw $05b2
        dw $06f4
        dw $07f4
        dw $0e20        ; Enables percussion mode.
        dw $2000        ; Turn off main voices.
        dw $2100
        dw $2200
        dw $2300
        dw $2400
        dw $2500
        dw $1620        ; Set up percussion.
        dw $1750
        dw $18c0
        dw $2605
        dw $2705
        dw $2801
        dw $3600        ;       / Bass Drum (volume for percussion)
        dw $3700        ; Hihat / Snare Drum
        dw $3800        ; Tom   / Top Cymbal

        ; Write a FM register
        ; A = register
        ; E = data
write_fm:
        jp WRTOPL

        ;
        ; Map FM BIOS 16K in $4000-$7FFF 
        ;
fm_rom_switch:
        di
        ld a,(fm_rom)
        ld h,$40
        jp ENASLT

        ;
        ; Map cartridge in $4000-$7FFF 
        ;
cartridge_rom_switch:
        ld a,(cartridge_rom)
        ld h,$40
        call ENASLT
        ei
        ret

fm_notes:
        ; Silencio - 0
        dw 0
        ; Octave 2 - 1
        dw $14ad,$14b7,$14c2,$14cd,$14d9,$14e6
        dw $14f4,$1503,$1512,$1522,$1534,$1546
        ; Octave 3 - 13
        dw $16ad,$16b7,$16c2,$16cd,$16d9,$16e6
        dw $16f4,$1703,$1712,$1722,$1734,$1746
        ; Octave 4 - 25
        dw $18ad,$18b7,$18c2,$18cd,$18d9,$18e6
        dw $18f4,$1903,$1912,$1922,$1934,$1946
        ; Octave 5 - 37
        dw $1aad,$1ab7,$1ac2,$1acd,$1ad9,$1ae6
        dw $1af4,$1b03,$1b12,$1b22,$1b34,$1b46
        ; Octave 6 - 49
        dw $1cad,$1cb7,$1cc2,$1ccd,$1cd9,$1ce6
        dw $1cf4,$1d03,$1d12,$1d22,$1d34,$1d46
        ; Octave 7 - 61
        ; Solo caben dos notas m s.
