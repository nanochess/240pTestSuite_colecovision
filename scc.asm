        ;
        ; Routines for SCC support in MSX
        ;
        ; Copyright (C) 2024 Oscar Toledo G. @nanochess
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
        ; Creation date: Jan/21/2024.
        ;

        ;
        ; Setup frequency in SCC
        ; A = Voice ($00 - $04)
        ; HL = Frequency.
        ;
scc_set_freq:
        xor a
        push af
        push hl
        call scc_rom_switch
        ld a,$3f
        ld ($9000),a
        pop hl
        pop af
        push af
        add a,a
        ld de,$9880
        add a,e
        ld e,a
        ld a,l
        ld (de),a
        inc de
        ld a,h
        ld (de),a
        pop af
        push af
        push hl
        call cartridge2_rom_switch
        ld a,2
        ld ($9000),a
        pop hl
        pop af
        ret

        ;
        ; Setup volume in SCC
        ; A = Voice ($00 - $04)
        ; L = Volume.
        ;
scc_set_volume:
        ld l,a
        xor a
        push af
        push hl
        call scc_rom_switch
        ld a,$3f
        ld ($9000),a
        pop hl
        pop af
        push af
        ld de,$988a
        add a,e
        ld e,a
        ld a,l
        ld (de),a
        pop af
        push af
        push hl
        call cartridge2_rom_switch
        ld a,2
        ld ($9000),a
        pop hl
        pop af
        ret

        ;
        ; Detects SCC 
        ;
detect_scc:
        ld a,$ff        ; SCC hasn't been discovered.
        ld (scc_rom),a
        ld bc,$0000
.1:     push bc
        ld hl,$fcc1
        ld a,l
        add a,c
        ld l,a
        ld a,(hl)
        and $80
        or c
        call find_scc   ; Search in subslots.
        pop bc
        jr nc,.2        ; Jump if something has been found.
        inc c
        bit 2,c         ; Four slots analyzed?
        jr z,.1         ; No, jump.
        ret

        ;
        ; SCC detected, call the initialization routine.
        ;
.2:

        ret

find_scc:
        bit 7,a         ; Expanded slot?
        ld b,1          ; No subslots.
        jr z,.1         ; No, jump.
        and $f3
        ld b,4          ; Ok, four subslots.
.1:     ld c,a
.2:     push bc
        ld h,$80
        ld a,c
        call ENASLT
        ld a,($9000)    ; Read byte to restore in C.
        ld c,a
        ld a,$02        ; Select ROM page.
        ld ($9000),a

        ld a,($9800)    ; Read byte to restore in B.
        ld b,a
        cpl
        ld ($9800),a
        ld a,($9800)
        cp b
        jr z,.8         ; If the byte didn't change it is ROM
        ld a,b          ; Restore byte B
        ld ($9800),a
        ld a,c          ; Restore byte C
        ld ($9000),a
        jr .3
.8:
        ld a,$3f        ; Select SCC page.
        ld ($9000),a

        ld a,($9800)
        ld b,a
        cpl
        ld ($9800),a
        ld a,($9800)
        cp b
        ld a,b          ; Restore byte
        ld ($9800),a
        jr z,.3         ; If the byte changed this is SCC.

        pop bc
        ld a,c          ; Take note of slot.
        ld (scc_rom),a
        push bc
        ld a,1          ; Enable SCC.
        ld (scc_enabled),a
.3:
        ; Important! The H register should be $40 here.
        ld a,(cartridge_rom)
        call ENASLT
        pop bc
        ld a,(scc_enabled)
        or a
        ret nz
        ld a,c
        add a,4
        ld c,a
        djnz .2
        scf
        ret

        ;
        ; Init SCC
        ;
init_scc:
        ld a,(scc_rom)
        inc a
        ret z
        call scc_rom_switch
        ld a,$3f
        ld ($9000),a
        ld de,$9800
        ld a,4
.1:
        push af
        ld hl,scc_sinewave
        ld bc,$0020
        ldir
        pop af
        dec a
        jr nz,.1

        ld hl,$988a
        ld b,5
        ld (hl),0
        inc hl
        djnz $-3
        ld (hl),$1f
        call cartridge2_rom_switch
        ld a,2
        ld ($9000),a
        ret

scc_sinewave:
	db $00,$18,$30,$46,$59,$69,$75,$7c
	db $7e,$7c,$75,$69,$59,$46,$30,$18
	db $00,$e8,$d0,$ba,$a7,$97,$8b,$84
	db $82,$84,$8b,$97,$a7,$ba,$d0,$e8

        ;
        ; Map SCC in $8000-$bFFF 
        ;
scc_rom_switch:
        di
        ld a,(scc_rom)
        ld h,$80
        jp ENASLT

        ;
        ; Map cartridge in $8000-$bFFF 
        ;
cartridge2_rom_switch:
        ld a,(cartridge_rom)
        ld h,$80
        call ENASLT
        ei
        ret

