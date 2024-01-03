	;
	; SHA-1 function.
	;
	; by Oscar Toledo G.
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
;sha1_h0:    rb 4
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
        pop hl          ; HL = New pointer to source data.
        pop de          ; DE = How many bytes copied.
        pop bc          ; BC = How many bytes to copy.

	ex de,hl
        ld a,h          ; Negate bytes written.
	cpl
	ld h,a
	ld a,l
	cpl
	ld l,a
	inc hl
        add hl,bc       ; To subtract from master counter.
	ld b,h
	ld c,l
	ex de,hl

        ld a,b          ; All bytes processed?
	or c
        jr nz,.1        ; No, jump.
	ret

sha1_chunk:
	; Chunk is taken as 32-bit big-endian words.
	; Extend the sixteen 32-bit words into eighty 32-bit words.
	ld ix,sha1_buffer+64
	ld b,64
.1:	ld a,(ix-12)
	xor (ix-32)
	xor (ix-56)
	xor (ix-64)
	ld d,a
	ld a,(ix-11)
	xor (ix-31)
	xor (ix-55)
	xor (ix-63)
	ld e,a
	ld a,(ix-10)
	xor (ix-30)
	xor (ix-54)
	xor (ix-62)
	ld h,a
	ld a,(ix-9)
	xor (ix-29)
	xor (ix-53)
	xor (ix-61)
	ld l,a
	ld a,d		; Rotate left by one bit.
	rla
	rl l
	rl h
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
        xor a
.2:     push af
	cp 20
	jp nc,.3
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2)
	ld a,l
	and c
	ld l,a
	ld a,h
	and b
	ld h,a
	ld bc,(sha1_h2+2)
	ld a,e
	and c
	ld e,a
	ld a,d
	and b
	ld d,a
	push de
	push hl
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h3)
	ld a,l
        cpl
	and c
	ld l,a
	ld a,h
        cpl
	and b
	ld h,a
	ld bc,(sha1_h3+2)
	ld a,e
        cpl
	and c
	ld e,a
	ld a,d
        cpl
	and b
	ld d,a
	pop bc
	ld a,l
	or c
	ld l,a
	ld a,h
	or b
	ld h,a
	pop bc
	ld a,e
	or c
	ld e,a
	ld a,d
	or b
	ld d,a
	exx
	ld hl,$7999
	ld de,$5a82
	exx
	jp .6
.3:
	cp 40
	jp nc,.4
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2)
	ld a,l
	xor c
	ld l,a
	ld a,h
	xor b
	ld h,a
	ld bc,(sha1_h2+2)
	ld a,e
	xor c
	ld e,a
	ld a,d
	xor b
	ld d,a
	ld bc,(sha1_h3)
	ld a,l
	xor c
	ld l,a
	ld a,h
	xor b
	ld h,a
	ld bc,(sha1_h3+2)
	ld a,e
	xor c
	ld e,a
	ld a,d
	xor b
	ld d,a
	exx
	ld hl,$eba1
	ld de,$6ed9
	exx
	jp .6
.4:
	cp 60
	jp nc,.5
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2)
	ld a,l
	and c
	ld l,a
	ld a,h
	and b
	ld h,a
	ld bc,(sha1_h2+2)
	ld a,e
	and c
	ld e,a
	ld a,d
	and b
	ld d,a
	push de
	push hl
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h3)
	ld a,l
	and c
	ld l,a
	ld a,h
	and b
	ld h,a
	ld bc,(sha1_h3+2)
	ld a,e
	and c
	ld e,a
	ld a,d
	and b
	ld d,a
	pop bc
	ld a,l
	or c
	ld l,a
	ld a,h
	or b
	ld h,a
	pop bc
	ld a,e
	or c
	ld e,a
	ld a,d
	or b
	ld d,a
	push de
	push hl
	ld hl,(sha1_h2)
	ld de,(sha1_h2+2)
	ld bc,(sha1_h3)
	ld a,l
	and c
	ld l,a
	ld a,h
	and b
	ld h,a
	ld bc,(sha1_h3+2)
	ld a,e
	and c
	ld e,a
	ld a,d
	and b
	ld d,a
	pop bc
	ld a,l
	or c
	ld l,a
	ld a,h
	or b
	ld h,a
	pop bc
	ld a,e
	or c
	ld e,a
	ld a,d
	or b
	ld d,a
	exx
	ld hl,$bcdc
	ld de,$8f1b
	exx
	jp .6
.5:
	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_h2)
	ld a,l
	xor c
	ld l,a
	ld a,h
	xor b
	ld h,a
	ld bc,(sha1_h2+2)
	ld a,e
	xor c
	ld e,a
	ld a,d
	xor b
	ld d,a
	ld bc,(sha1_h3)
	ld a,l
	xor c
	ld l,a
	ld a,h
	xor b
	ld h,a
	ld bc,(sha1_h3+2)
	ld a,e
	xor c
	ld e,a
	ld a,d
	xor b
	ld d,a
	exx
	ld hl,$c1d6
	ld de,$ca62
	exx
.6:
	ld bc,(sha1_h4)
	add hl,bc
	ld bc,(sha1_h4+2)
	ex de,hl
	adc hl,bc
	ex de,hl
	exx
	push hl
	exx
	pop bc
	add hl,bc
	exx
	push de
	exx
	pop bc
	ex de,hl
	adc hl,bc
	ex de,hl
	ld c,(ix+3)
	ld b,(ix+2)
	add hl,bc
	ld c,(ix+1)
	ld b,(ix+0)
	ex de,hl
	adc hl,bc
	ex de,hl
	exx
	ld hl,(sha1_h0)
        ld de,(sha1_h0+2)
	ld a,d
	rla
	rl l
	rl h
	rl e
	rl d
	ld a,d
	rla
	rl l
	rl h
	rl e
	rl d
	ld a,d
	rla
	rl l
	rl h
	rl e
	rl d
	ld a,d
	rla
	rl l
	rl h
	rl e
	rl d
	ld a,d
	rla
	rl l
	rl h
	rl e
	rl d
	push hl
	exx
	pop bc
	add hl,bc
	exx
	push de
	exx
	pop bc
	ex de,hl
	adc hl,bc
	ex de,hl
	push de
	push hl
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
	ld a,l
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
	pop hl
	pop de
	ld (sha1_h0),hl
	ld (sha1_h0+2),de
        pop af
        ld de,4
        add ix,de
        inc a
	cp 80
	jp nz,.2

	ld hl,(sha1_h0)
	ld de,(sha1_h0+2)
	ld bc,(sha1_hcopy)
	add hl,bc
	ld bc,(sha1_hcopy+2)
	ex de,hl
	adc hl,bc
	ex de,hl
	ld (sha1_h0),hl
	ld (sha1_h0+2),de

	ld hl,(sha1_h1)
	ld de,(sha1_h1+2)
	ld bc,(sha1_hcopy+4)
	add hl,bc
	ld bc,(sha1_hcopy+6)
	ex de,hl
	adc hl,bc
	ex de,hl
	ld (sha1_h1),hl
	ld (sha1_h1+2),de

	ld hl,(sha1_h2)
	ld de,(sha1_h2+2)
	ld bc,(sha1_hcopy+8)
	add hl,bc
	ld bc,(sha1_hcopy+10)
	ex de,hl
	adc hl,bc
	ex de,hl
	ld (sha1_h2),hl
	ld (sha1_h2+2),de

	ld hl,(sha1_h3)
	ld de,(sha1_h3+2)
	ld bc,(sha1_hcopy+12)
	add hl,bc
	ld bc,(sha1_hcopy+14)
	ex de,hl
	adc hl,bc
	ex de,hl
	ld (sha1_h3),hl
	ld (sha1_h3+2),de

	ld hl,(sha1_h4)
	ld de,(sha1_h4+2)
	ld bc,(sha1_hcopy+16)
	add hl,bc
	ld bc,(sha1_hcopy+18)
	ex de,hl
	adc hl,bc
	ex de,hl
	ld (sha1_h4),hl
	ld (sha1_h4+2),de

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
