        ;
        ; 240p test suite (MDFourier unit)
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
        ; Creation date: Jan/18/2024.
        ;

PULSE_TRAIN_FREQ:       equ 13  ; Around 8khz.
DEFAULT_VOLUME:         equ 13
SCC_DEFAULT_VOLUME:     equ 15

        ; MDFourier timing usage.
        ;
        ; MSX
        ; Frames
        ; ------
        ;   20    Pulse train
        ;   20    Silence
        ;  800    SPSG
        ;  400    SPSG_Ramp
        ;  640    Noise
        ; 1200    FM Grand Piano (only if FM available)
        ;  100    FM Percussion (only if FM available)
        ;   20    Silence
        ;   20    Pulse train
        ; ----
        ; 2620
        ;
        ; Colecovision/SG1000
        ; ------
        ;   20    Pulse train
        ;   20    Silence
        ;  800    SPSG
        ;  400    SPSG_Ramp
        ;  700    Noise low tones.
        ;  700    White noise.
        ;   20    Silence
        ;   20    Pulse train
        ; ----
        ; 2080
        ;  

execute_pulse_train:
        ld hl,PULSE_TRAIN_FREQ
        call set_freq
        ld b,10
.1:     push bc
        halt
        ld a,15
        call set_volume
        halt
        ld a,0
        call set_volume
        pop bc
        djnz .1
        ret

execute_silence:
        ld b,20
.1:     halt
        djnz .1
        ret

execute_psg:
        ld hl,500
.1:     push hl
        call calculate_freq
        halt
        call set_freq
        ld a,DEFAULT_VOLUME
        call set_volume
        ld b,18
        halt
        djnz $-1
        halt
        ld a,0
        call set_volume
        pop hl
        ld de,500              
        add hl,de
        ld de,20500
        or a
        sbc hl,de
        add hl,de
        jr c,.1
        ret

execute_psg_ramp:
        ld hl,50
.1:     push hl
        call calculate_freq
        halt
        call set_freq
        ld a,DEFAULT_VOLUME
        call set_volume
        pop hl
        ld de,50              
        add hl,de
        ld de,20050
        or a
        sbc hl,de
        add hl,de
        jr c,.1
        halt
        ld a,0
        call set_volume
        ret

execute_noise:
    if COLECO+SG1000
        ld bc,$0800
.1:     push bc
        halt
        ld a,c
        or $e8
        out (PSG),a
        and $03
        cp $03
        jr nz,.2
        ld hl,$0001
.3:     push hl
        ld a,l
        and $0f
        or $c0
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
        ld a,$ff-DEFAULT_VOLUME
        out (PSG),a
        ld b,18
        halt
        djnz $-1
        halt
        ld a,$ff
        out (PSG),a
        pop hl
        inc hl
        ld a,l
        cp $21
        jr nz,.3
        jr .4
.2:
        ld a,$ff-DEFAULT_VOLUME
        out (PSG),a
        ld b,18
        halt
        djnz $-1
        halt
        ld a,$ff
        out (PSG),a
.4:
        pop bc
        inc c
        djnz .1
    endif
    if MSX
        ld e,$b1
        ld a,7
        call WRTPSG

        ld bc,$2000
.5:     push bc
        halt
        ld e,c
        ld a,6
        call WRTPSG
        ld e,DEFAULT_VOLUME
        ld a,8
        call WRTPSG
        ld b,18
        halt
        djnz $-1
        halt
        ld e,0
        ld a,8
        call WRTPSG
        pop bc
        inc c
        djnz .5
        ld e,$b8
        ld a,7
        call WRTPSG
    endif
        ret

        ;
        ; Divide 111860/value to get frequency value for PSG.
        ;
calculate_freq:
        push hl
        ld hl,$b4f4
        ld de,$0000
        exx
        ld hl,$0001
        pop de
        exx
        ld bc,0
        ld a,17
.1:     or a
        sbc hl,de
        exx
        sbc hl,de
        exx
        jr nc,.2
        add hl,de
        exx
        adc hl,de
        exx
.2:     ccf
        rl c
        rl b
        exx
        srl d
        rr e
        exx
        rr d
        rr e
        dec a
        jp nz,.1
        push bc
        pop hl
        ret

    if MSX
        ;
        ; SCC frequencies (one frequency each 20 frames)
        ;
execute_scc:
        ld hl,500
.1:     push hl
        call calculate_freq
        halt
        call scc_set_freq
        ld a,SCC_DEFAULT_VOLUME
        call scc_set_volume
        ld b,18
        halt
        djnz $-1
        halt
        ld a,0
        call scc_set_volume
        pop hl
        ld de,500              
        add hl,de
        ld de,20500
        or a
        sbc hl,de
        add hl,de
        jr c,.1
        ret

        ;
        ; SCC ramp of frequencies (one frequency each frame).
        ;
execute_scc_ramp:
        ld hl,50
.1:     push hl
        call calculate_freq
        halt
        call scc_set_freq
        ld a,SCC_DEFAULT_VOLUME
        call scc_set_volume
        pop hl
        ld de,50              
        add hl,de
        ld de,20050
        or a
        sbc hl,de
        add hl,de
        jr c,.1
        halt
        ld a,0
        call scc_set_volume
        ret
    endif

        ;
        ; MDFourier audio tests generation.
        ;
mdfourier:
        call execute_pulse_train
        call execute_silence

        call execute_psg
        call execute_psg_ramp
        call execute_noise
    if MSX
        ld a,(mdfourier_test_flags)
        bit 2,a
        jr z,.4
        ld a,(scc_enabled)
        or a
        jp z,.4
        call execute_scc
        call execute_scc_ramp
.4:
    endif

    if MSX

        ld a,(mdfourier_test_flags)
        bit 1,a
        jp z,.3
        ld a,(fm_enabled)
        or a
        jp z,.3
        call fm_rom_switch
        ld b,$01+$40
        ld c,$10
.2:
        push bc
        call fm_frame
        ld a,c
        call play_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$00        ; Turn key off.
        ld a,c
        add a,$10
        call write_fm
        pop bc
        inc c
        ld a,c
        cp $15          ; Cycles FM channels.
        jr nz,$+4
        ld c,$10
        inc b
        ld a,b
        cp $3d+$40
        jr nz,.2
.1:
        call fm_frame
        ld e,$21
        ld a,$0e
        call write_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$20
        ld a,$0e
        call write_fm
        
        call fm_frame
        ld e,$22
        ld a,$0e
        call write_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$20
        ld a,$0e
        call write_fm
        
        call fm_frame
        ld e,$24
        ld a,$0e
        call write_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$20
        ld a,$0e
        call write_fm
        
        call fm_frame
        ld e,$28
        ld a,$0e
        call write_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$20
        ld a,$0e
        call write_fm
        
        call fm_frame
        ld e,$30
        ld a,$0e
        call write_fm
        ld b,18
        call fm_frame
        djnz $-3
        call fm_frame
        ld e,$20
        ld a,$0e
        call write_fm
        
        call cartridge_rom_switch
    endif
.3:
        call execute_silence
        call execute_pulse_train
        ret

    if MSX
fm_frame:
        push bc
        push de
        push hl
        call cartridge_rom_switch
        halt
        call fm_rom_switch
        pop hl
        pop de
        pop bc
        ret
    endif
