	;
	; SHA-1 function.
	;
	; by Oscar Toledo G.
	; https://nanochess.org/
	;
	; I'm thereby making this code public domain for your Z80 projects.
	;
	; Creation date: Jan/03/2024.
	;

	;
	; Based on pseudocode from:
	; https://cryptography.fandom.com/wiki/SHA-1
	;

        ; The memory work area needed.
;sha1_h0:        rb 4
;sha1_h1:        rb 4
;sha1_h2:        rb 4
;sha1_h3:        rb 4
;sha1_h4:        rb 4
;sha1_len:       rb 2
;sha1_pos:       rb 1
;sha1_hcopy:     rb 20
;sha1_buffer:    rb 320

sha1_init:
	ld hl,.values
	ld de,sha1_h0
	ld bc,23
	ldir
	ret

.values:
	dw $2301,$6745
	dw $ab89,$efcd
	dw $dcfe,$98ba
	dw $5476,$1032
	dw $e1f0,$c3d2
        dw $0000        ; sha1_len
        db 0            ; sha1_pos      

	;
	; HL = Input data.
	; BC = Length of data (>= 0)
	;
sha1_calculate:
	push hl
	ld hl,(sha1_len)
        add hl,bc       ; Add bytes to total length.
	ld (sha1_len),hl
	pop hl
.1:
	push bc
        ld a,(sha1_pos) ; Current pointer in buffer.
	ld e,a
	ld d,0
        push hl         ; Save pointer to source data.
	ld hl,sha1_buffer
	add hl,de
        ex de,hl        ; DE = Pointer to buffer.

	ld a,b
        or a            ; More than 255 bytes to copy?
        jr z,$+5        ; No, jump.
        ld bc,64        ; Limit to 64 bytes.

        ld a,64         ; Buffer size.
        sub l           ; Minus current position.
        cp c            ; Available bytes >= Bytes to write?
        jr nc,.2        ; Yes, jump.
        ld c,a          ; Limit bytes to write.
.2:
        pop hl          ; Restore pointer to source data.
	ld a,(sha1_pos)
        add a,c         ; Advance pointer to buffer.
	ld (sha1_pos),a
        push bc
        ldir            ; Copy data into buffer.
        push hl         ; Save new pointer to source data.
        cp 64           ; Is the buffer filled?
        call z,sha1_chunk       ; Yes, process the chunk.
        pop de          ; DE = New pointer to source data.
        pop bc          ; BC = How many bytes copied.
        pop hl          ; HL = How many bytes to copy.

        or a
        sbc hl,bc       ; Subtract copied bytes from master counter.
	ld b,h
	ld c,l
	ex de,hl

                        ; All bytes processed?
        jr nz,.1        ; No, jump.
	ret

sha1_chunk:
	; Chunk is taken as 32-bit big-endian words.
	; Extend the sixteen 32-bit words into eighty 32-bit words.
	ld ix,sha1_buffer+64
	ld b,64
.1:
	ld a,(ix-9)
	xor (ix-29)
	xor (ix-53)
	xor (ix-61)
	ld l,a
	ld a,(ix-10)
	xor (ix-30)
	xor (ix-54)
	xor (ix-62)
	ld h,a
	ld a,(ix-11)
	xor (ix-31)
	xor (ix-55)
	xor (ix-63)
	ld e,a
        ld a,(ix-12)
	xor (ix-32)
	xor (ix-56)
	xor (ix-64)
	ld d,a
                        ; Rotate left by one bit.
	rla
        adc hl,hl
	rl e
	rl d
	ld (ix+0),d
	ld (ix+1),e
	ld (ix+2),h
	ld (ix+3),l
	ld de,4
	add ix,de
	djnz .1

        ld hl,sha1_h0
	ld de,sha1_hcopy
	ld bc,20
	ldir

	ld ix,sha1_buffer
        ;
        ; SHA1 rounds.
        ;
        ; We don't need to process 32-bit at a time,
        ; instead we can work with 16-bits and combine
        ; both at the end. This shortens the code.
        ;
        ld a,256-80
.2:
        ld hl,(sha1_h4)
        ld c,(ix+3)
        ld b,(ix+2)
        add hl,bc
        ex de,hl
        ld hl,(sha1_h4+2)
        ld c,(ix+1)
        ld b,(ix+0)
        adc hl,bc
        ex de,hl
        cp 256-60
	jp nc,.3
        ex af,af'
        ld bc,$7999
        add hl,bc
        ld bc,$5a82
        ex de,hl
        adc hl,bc
        push hl
        push de
        ; (b and c) or ((not b) and d)
	ld hl,(sha1_h1)
        ld de,(sha1_h2)
        ld bc,(sha1_h3)
        ld a,l
        cpl
        and c
        ld c,a
	ld a,l
        and e
        or c
	ld l,a
        ld a,h
        cpl
        and b
        ld b,a
	ld a,h
        and d
        or b
	ld h,a
	ld de,(sha1_h1+2)
        ld bc,(sha1_h3+2)
        ld a,e
        cpl
        and c
        ld c,a
        ld a,(sha1_h2+2)
        and e
        or c
        ld e,a
        ld a,d
        cpl
        and b
        ld b,a
        ld a,(sha1_h2+3)
        and d
        or b
        ld d,a
	jp .6
.3:
        cp 256-40
	jp nc,.4
        ex af,af'
        ld bc,$eba1
        add hl,bc
        ld bc,$6ed9
        ex de,hl
        adc hl,bc
        push hl
        push de
        jp .7
.4:
        cp 256-20
	jp nc,.5
        ex af,af'
        ld bc,$bcdc
        add hl,bc
        ld bc,$8f1b
        ex de,hl
        adc hl,bc
        push hl
        push de
        ; (b and c) or (b and d) or (c and d)
	ld hl,(sha1_h1)
        ld de,(sha1_h2)
        ld bc,(sha1_h3)
        ld a,e  ; Boolean optimization: (c or d) and b
        or c
        and l
	ld l,a
        ld a,e  ; or (c and d)
        and c
        or l
        ld l,a
        ld a,d
        or b
        and h
        ld h,a
        ld a,d
        and b
        or h
        ld h,a
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2+2)
        ld a,(sha1_h3+2)
        or c
        and e
        ld e,a
        ld a,(sha1_h3+2)
        and c
        or e
        ld e,a
        ld a,(sha1_h3+3)
        or b
        and d
        ld d,a
        ld a,(sha1_h3+3)
        and b
        or d
        ld d,a
	jp .6
.5:
        ex af,af'
        ld bc,$c1d6
        add hl,bc
        ld bc,$ca62
        ex de,hl
        adc hl,bc
        push hl
        push de
.7:
        ; b xor c xor d
        ld hl,(sha1_h1)
        ld de,(sha1_h2)
        ld bc,(sha1_h3)
	ld a,l
        xor e
        xor c
	ld l,a
	ld a,h
        xor d
        xor b
	ld h,a
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2+2)
        ld a,(sha1_h3+2)
        xor e
	xor c
	ld e,a
        ld a,(sha1_h3+3)
        xor d
        xor b
	ld d,a
.6:
        ; f is DEHL
        ; k is saved on stack and added before with sha1_h4 (e) and w[i].
        ; w[i] is pointed by IX.
        ; temp = f + e + k + w[i] + (a leftrotate 5)
	pop bc
	add hl,bc
	pop bc
	ex de,hl
	adc hl,bc
        push hl
	ld hl,(sha1_h0)
        ld bc,(sha1_h0+2)
        ; Rotate left 5 replaced by
        ; fast 8-bit rotation to left + 3 bits right
        ld a,b
        ld b,c
        ld c,h
        ld h,l
        ld l,a
        rra
        rr b
        rr c
        rr h
        rr l
        rra
        rr b
        rr c
        rr h
        rr l
        rra
        rr b
        rr c
        rr h
        rr l
        add hl,de
        pop de
	ex de,hl
	adc hl,bc
	ex de,hl
        exx
        ld hl,(sha1_h3)
        ld (sha1_h4),hl
        ld hl,(sha1_h3+2)
        ld (sha1_h4+2),hl
        ld hl,(sha1_h2)
        ld (sha1_h3),hl
        ld hl,(sha1_h2+2)
        ld (sha1_h3+2),hl
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld a,l
	rra
	rr d
	rr e
	rr h
	rr l
	rra
	rr d
	rr e
	rr h
	rr l
	ld (sha1_h2),hl
	ld (sha1_h2+2),de
        ld hl,(sha1_h0)
        ld (sha1_h1),hl
        ld hl,(sha1_h0+2)
        ld (sha1_h1+2),hl
        exx
	ld (sha1_h0),hl
	ld (sha1_h0+2),de
        ex af,af'
        ld de,4
        add ix,de
        inc a
	jp nz,.2

	ld hl,(sha1_h0)
	ld bc,(sha1_hcopy)
	add hl,bc
        ld (sha1_h0),hl
        ld hl,(sha1_h0+2)
	ld bc,(sha1_hcopy+2)
	adc hl,bc
        ld (sha1_h0+2),hl

	ld hl,(sha1_h1)
	ld bc,(sha1_hcopy+4)
	add hl,bc
	ld (sha1_h1),hl
        ld hl,(sha1_h1+2)
	ld bc,(sha1_hcopy+6)
	adc hl,bc
        ld (sha1_h1+2),hl

	ld hl,(sha1_h2)
	ld bc,(sha1_hcopy+8)
	add hl,bc
	ld (sha1_h2),hl
        ld hl,(sha1_h2+2)
	ld bc,(sha1_hcopy+10)
	adc hl,bc
        ld (sha1_h2+2),hl

	ld hl,(sha1_h3)
	ld bc,(sha1_hcopy+12)
	add hl,bc
	ld (sha1_h3),hl
        ld hl,(sha1_h3+2)
	ld bc,(sha1_hcopy+14)
	adc hl,bc
        ld (sha1_h3+2),hl

	ld hl,(sha1_h4)
	ld bc,(sha1_hcopy+16)
	add hl,bc
	ld (sha1_h4),hl
        ld hl,(sha1_h4+2)
	ld bc,(sha1_hcopy+18)
	adc hl,bc
        ld (sha1_h4+2),hl

        xor a
        ld (sha1_pos),a
	ret

sha1_final:
	ld a,(sha1_pos)
	ld e,a
	ld d,0
	ld hl,sha1_buffer
	add hl,de
        ld (hl),$80
	inc hl
        inc e
        ld a,e
        ld (sha1_pos),a
	cp 57
	jr c,.1
        ld a,64
	sub e
	ld b,a
	jr z,.3
.2:	ld (hl),$00
	inc hl
	djnz .2
.3:	call sha1_chunk
.1:
	ld a,(sha1_pos)
	ld e,a
	ld d,0
	ld hl,sha1_buffer
	add hl,de
.4:	ld (hl),$00
	inc hl
	inc e
	ld a,e
        cp 61   ; 56 if going to use a 64-bit number.
        jr c,.4
        ; The length in bits is a 64-bit number.
        ; But filled already 40-bits with zeroes.
        ld de,(sha1_len)
        xor a
        sla e
        rl d
        rla
        sla e
        rl d
        rla
        sla e
        rl d
        rla
        ld (hl),a
        inc hl
        ld (hl),d
        inc hl
        ld (hl),e
	call sha1_chunk

        ;
        ; Make sha1_h0 big-endian 32-bit words.
        ; This way the SHA1 is a continuous 20 byte string.
        ;
        ld hl,sha1_h0
        ld de,sha1_hcopy
        ld bc,20
        ldir
        ld ix,sha1_hcopy
        ld iy,sha1_h0
        ld b,5
.5:     ld a,(ix+3)
        ld (iy+0),a
        ld a,(ix+2)
        ld (iy+1),a
        ld a,(ix+1)
        ld (iy+2),a
        ld a,(ix+0)
        ld (iy+3),a
        ld de,4
        add ix,de
        add iy,de
        djnz .5
	; Digest is now in sha1_h0 -> sha1_h4
	ret
