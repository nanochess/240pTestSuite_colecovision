        ;
        ; CRC32 function
        ;
        ; by Oscar Toledo G.
	; https://nanochess.org/
	;
	; I'm thereby making this code public domain for your Z80 projects.
        ;
        ; Creation date: Dec/20/2023.
        ; Revision date: Dec/23/2023. Optimized processing code.
        ;

        ;
        ; Based on public domain code by Craig Bruce.
        ; http://csbruce.com/software/crc32.c
        ;

crc32_table:
        db $00,$00,$00,$00      ; $00
	db $96,$30,$07,$77	; $01
	db $2c,$61,$0e,$ee	; $02
	db $ba,$51,$09,$99	; $03
	db $19,$c4,$6d,$07	; $04
	db $8f,$f4,$6a,$70	; $05
	db $35,$a5,$63,$e9	; $06
	db $a3,$95,$64,$9e	; $07
	db $32,$88,$db,$0e	; $08
	db $a4,$b8,$dc,$79	; $09
	db $1e,$e9,$d5,$e0	; $0a
	db $88,$d9,$d2,$97	; $0b
	db $2b,$4c,$b6,$09	; $0c
	db $bd,$7c,$b1,$7e	; $0d
	db $07,$2d,$b8,$e7	; $0e
	db $91,$1d,$bf,$90	; $0f
	db $64,$10,$b7,$1d	; $10
	db $f2,$20,$b0,$6a	; $11
	db $48,$71,$b9,$f3	; $12
	db $de,$41,$be,$84	; $13
	db $7d,$d4,$da,$1a	; $14
	db $eb,$e4,$dd,$6d	; $15
	db $51,$b5,$d4,$f4	; $16
	db $c7,$85,$d3,$83	; $17
	db $56,$98,$6c,$13	; $18
	db $c0,$a8,$6b,$64	; $19
	db $7a,$f9,$62,$fd	; $1a
	db $ec,$c9,$65,$8a	; $1b
	db $4f,$5c,$01,$14	; $1c
	db $d9,$6c,$06,$63	; $1d
	db $63,$3d,$0f,$fa	; $1e
	db $f5,$0d,$08,$8d	; $1f
	db $c8,$20,$6e,$3b	; $20
	db $5e,$10,$69,$4c	; $21
	db $e4,$41,$60,$d5	; $22
	db $72,$71,$67,$a2	; $23
	db $d1,$e4,$03,$3c	; $24
	db $47,$d4,$04,$4b	; $25
	db $fd,$85,$0d,$d2	; $26
	db $6b,$b5,$0a,$a5	; $27
	db $fa,$a8,$b5,$35	; $28
	db $6c,$98,$b2,$42	; $29
	db $d6,$c9,$bb,$db	; $2a
	db $40,$f9,$bc,$ac	; $2b
	db $e3,$6c,$d8,$32	; $2c
	db $75,$5c,$df,$45	; $2d
	db $cf,$0d,$d6,$dc	; $2e
	db $59,$3d,$d1,$ab	; $2f
	db $ac,$30,$d9,$26	; $30
	db $3a,$00,$de,$51	; $31
	db $80,$51,$d7,$c8	; $32
	db $16,$61,$d0,$bf	; $33
	db $b5,$f4,$b4,$21	; $34
	db $23,$c4,$b3,$56	; $35
	db $99,$95,$ba,$cf	; $36
	db $0f,$a5,$bd,$b8	; $37
	db $9e,$b8,$02,$28	; $38
	db $08,$88,$05,$5f	; $39
	db $b2,$d9,$0c,$c6	; $3a
	db $24,$e9,$0b,$b1	; $3b
	db $87,$7c,$6f,$2f	; $3c
	db $11,$4c,$68,$58	; $3d
	db $ab,$1d,$61,$c1	; $3e
	db $3d,$2d,$66,$b6	; $3f
	db $90,$41,$dc,$76	; $40
	db $06,$71,$db,$01	; $41
	db $bc,$20,$d2,$98	; $42
	db $2a,$10,$d5,$ef	; $43
	db $89,$85,$b1,$71	; $44
	db $1f,$b5,$b6,$06	; $45
	db $a5,$e4,$bf,$9f	; $46
	db $33,$d4,$b8,$e8	; $47
	db $a2,$c9,$07,$78	; $48
	db $34,$f9,$00,$0f	; $49
	db $8e,$a8,$09,$96	; $4a
	db $18,$98,$0e,$e1	; $4b
	db $bb,$0d,$6a,$7f	; $4c
	db $2d,$3d,$6d,$08	; $4d
	db $97,$6c,$64,$91	; $4e
	db $01,$5c,$63,$e6	; $4f
	db $f4,$51,$6b,$6b	; $50
	db $62,$61,$6c,$1c	; $51
	db $d8,$30,$65,$85	; $52
	db $4e,$00,$62,$f2	; $53
	db $ed,$95,$06,$6c	; $54
	db $7b,$a5,$01,$1b	; $55
	db $c1,$f4,$08,$82	; $56
	db $57,$c4,$0f,$f5	; $57
	db $c6,$d9,$b0,$65	; $58
	db $50,$e9,$b7,$12	; $59
	db $ea,$b8,$be,$8b	; $5a
	db $7c,$88,$b9,$fc	; $5b
	db $df,$1d,$dd,$62	; $5c
	db $49,$2d,$da,$15	; $5d
	db $f3,$7c,$d3,$8c	; $5e
	db $65,$4c,$d4,$fb	; $5f
	db $58,$61,$b2,$4d	; $60
	db $ce,$51,$b5,$3a	; $61
	db $74,$00,$bc,$a3	; $62
	db $e2,$30,$bb,$d4	; $63
	db $41,$a5,$df,$4a	; $64
	db $d7,$95,$d8,$3d	; $65
	db $6d,$c4,$d1,$a4	; $66
	db $fb,$f4,$d6,$d3	; $67
	db $6a,$e9,$69,$43	; $68
	db $fc,$d9,$6e,$34	; $69
	db $46,$88,$67,$ad	; $6a
	db $d0,$b8,$60,$da	; $6b
	db $73,$2d,$04,$44	; $6c
	db $e5,$1d,$03,$33	; $6d
	db $5f,$4c,$0a,$aa	; $6e
	db $c9,$7c,$0d,$dd	; $6f
	db $3c,$71,$05,$50	; $70
	db $aa,$41,$02,$27	; $71
	db $10,$10,$0b,$be	; $72
	db $86,$20,$0c,$c9	; $73
	db $25,$b5,$68,$57	; $74
	db $b3,$85,$6f,$20	; $75
	db $09,$d4,$66,$b9	; $76
	db $9f,$e4,$61,$ce	; $77
	db $0e,$f9,$de,$5e	; $78
	db $98,$c9,$d9,$29	; $79
	db $22,$98,$d0,$b0	; $7a
	db $b4,$a8,$d7,$c7	; $7b
	db $17,$3d,$b3,$59	; $7c
	db $81,$0d,$b4,$2e	; $7d
	db $3b,$5c,$bd,$b7	; $7e
	db $ad,$6c,$ba,$c0	; $7f
	db $20,$83,$b8,$ed	; $80
	db $b6,$b3,$bf,$9a	; $81
	db $0c,$e2,$b6,$03	; $82
	db $9a,$d2,$b1,$74	; $83
	db $39,$47,$d5,$ea	; $84
	db $af,$77,$d2,$9d	; $85
	db $15,$26,$db,$04	; $86
	db $83,$16,$dc,$73	; $87
	db $12,$0b,$63,$e3	; $88
	db $84,$3b,$64,$94	; $89
	db $3e,$6a,$6d,$0d	; $8a
	db $a8,$5a,$6a,$7a	; $8b
	db $0b,$cf,$0e,$e4	; $8c
	db $9d,$ff,$09,$93	; $8d
	db $27,$ae,$00,$0a	; $8e
	db $b1,$9e,$07,$7d	; $8f
	db $44,$93,$0f,$f0	; $90
	db $d2,$a3,$08,$87	; $91
	db $68,$f2,$01,$1e	; $92
	db $fe,$c2,$06,$69	; $93
	db $5d,$57,$62,$f7	; $94
	db $cb,$67,$65,$80	; $95
	db $71,$36,$6c,$19	; $96
	db $e7,$06,$6b,$6e	; $97
	db $76,$1b,$d4,$fe	; $98
	db $e0,$2b,$d3,$89	; $99
	db $5a,$7a,$da,$10	; $9a
	db $cc,$4a,$dd,$67	; $9b
	db $6f,$df,$b9,$f9	; $9c
	db $f9,$ef,$be,$8e	; $9d
	db $43,$be,$b7,$17	; $9e
	db $d5,$8e,$b0,$60	; $9f
	db $e8,$a3,$d6,$d6	; $a0
	db $7e,$93,$d1,$a1	; $a1
	db $c4,$c2,$d8,$38	; $a2
	db $52,$f2,$df,$4f	; $a3
	db $f1,$67,$bb,$d1	; $a4
	db $67,$57,$bc,$a6	; $a5
	db $dd,$06,$b5,$3f	; $a6
	db $4b,$36,$b2,$48	; $a7
	db $da,$2b,$0d,$d8	; $a8
	db $4c,$1b,$0a,$af	; $a9
	db $f6,$4a,$03,$36	; $aa
	db $60,$7a,$04,$41	; $ab
	db $c3,$ef,$60,$df	; $ac
	db $55,$df,$67,$a8	; $ad
	db $ef,$8e,$6e,$31	; $ae
	db $79,$be,$69,$46	; $af
	db $8c,$b3,$61,$cb	; $b0
	db $1a,$83,$66,$bc	; $b1
	db $a0,$d2,$6f,$25	; $b2
	db $36,$e2,$68,$52	; $b3
	db $95,$77,$0c,$cc	; $b4
	db $03,$47,$0b,$bb	; $b5
	db $b9,$16,$02,$22	; $b6
	db $2f,$26,$05,$55	; $b7
	db $be,$3b,$ba,$c5	; $b8
	db $28,$0b,$bd,$b2	; $b9
	db $92,$5a,$b4,$2b	; $ba
	db $04,$6a,$b3,$5c	; $bb
	db $a7,$ff,$d7,$c2	; $bc
	db $31,$cf,$d0,$b5	; $bd
	db $8b,$9e,$d9,$2c	; $be
	db $1d,$ae,$de,$5b	; $bf
	db $b0,$c2,$64,$9b	; $c0
	db $26,$f2,$63,$ec	; $c1
	db $9c,$a3,$6a,$75	; $c2
	db $0a,$93,$6d,$02	; $c3
	db $a9,$06,$09,$9c	; $c4
	db $3f,$36,$0e,$eb	; $c5
	db $85,$67,$07,$72	; $c6
	db $13,$57,$00,$05	; $c7
	db $82,$4a,$bf,$95	; $c8
	db $14,$7a,$b8,$e2	; $c9
	db $ae,$2b,$b1,$7b	; $ca
	db $38,$1b,$b6,$0c	; $cb
	db $9b,$8e,$d2,$92	; $cc
	db $0d,$be,$d5,$e5	; $cd
	db $b7,$ef,$dc,$7c	; $ce
	db $21,$df,$db,$0b	; $cf
	db $d4,$d2,$d3,$86	; $d0
	db $42,$e2,$d4,$f1	; $d1
	db $f8,$b3,$dd,$68	; $d2
	db $6e,$83,$da,$1f	; $d3
	db $cd,$16,$be,$81	; $d4
	db $5b,$26,$b9,$f6	; $d5
	db $e1,$77,$b0,$6f	; $d6
	db $77,$47,$b7,$18	; $d7
	db $e6,$5a,$08,$88	; $d8
	db $70,$6a,$0f,$ff	; $d9
	db $ca,$3b,$06,$66	; $da
	db $5c,$0b,$01,$11	; $db
	db $ff,$9e,$65,$8f	; $dc
	db $69,$ae,$62,$f8	; $dd
	db $d3,$ff,$6b,$61	; $de
	db $45,$cf,$6c,$16	; $df
	db $78,$e2,$0a,$a0	; $e0
	db $ee,$d2,$0d,$d7	; $e1
	db $54,$83,$04,$4e	; $e2
	db $c2,$b3,$03,$39	; $e3
	db $61,$26,$67,$a7	; $e4
	db $f7,$16,$60,$d0	; $e5
	db $4d,$47,$69,$49	; $e6
	db $db,$77,$6e,$3e	; $e7
	db $4a,$6a,$d1,$ae	; $e8
	db $dc,$5a,$d6,$d9	; $e9
	db $66,$0b,$df,$40	; $ea
	db $f0,$3b,$d8,$37	; $eb
	db $53,$ae,$bc,$a9	; $ec
	db $c5,$9e,$bb,$de	; $ed
	db $7f,$cf,$b2,$47	; $ee
	db $e9,$ff,$b5,$30	; $ef
	db $1c,$f2,$bd,$bd	; $f0
	db $8a,$c2,$ba,$ca	; $f1
	db $30,$93,$b3,$53	; $f2
	db $a6,$a3,$b4,$24	; $f3
	db $05,$36,$d0,$ba	; $f4
	db $93,$06,$d7,$cd	; $f5
	db $29,$57,$de,$54	; $f6
	db $bf,$67,$d9,$23	; $f7
	db $2e,$7a,$66,$b3	; $f8
	db $b8,$4a,$61,$c4	; $f9
	db $02,$1b,$68,$5d	; $fa
	db $94,$2b,$6f,$2a	; $fb
	db $37,$be,$0b,$b4	; $fc
	db $a1,$8e,$0c,$c3	; $fd
	db $1b,$df,$05,$5a	; $fe
	db $8d,$ef,$02,$2d	; $ff

        ;
        ; Init CRC32 calculation.
        ; 
crc32_init:
        exx
        ld de,$ffff     ; Low-word of CRC-32 value.
        ld bc,$ffff     ; High-word of CRC-32 value.
        exx
        ret

        ;
        ; Calculate CRC32.
        ; hl = pointer to buffer.
        ; bc = number of bytes.
        ;
crc32_calculate:
.1:
        ld a,(hl)
        exx
        xor e
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        ld a,crc32_table&255
        add a,l
        ld l,a
        ld a,h
        adc a,crc32_table>>8
        ld h,a
        ld a,(hl)
        xor d
        ld e,a
        inc hl
        ld a,(hl)
        xor c
        ld d,a
        inc hl
        ld a,(hl)
        xor b
        ld c,a
        inc hl
        ld b,(hl)
        exx
        inc hl
        dec bc
        ld a,b
        or c
        jp nz,.1
        ret

        ;
        ; Get final CRC32 as a 32-bit value in DEHL.
        ;
crc32_final:
        exx
        ld a,e
        cpl
        ld l,a
        ld a,d
        cpl
        ld h,a
        ld a,c
        cpl
        ld e,a
        ld a,b
        cpl
        ld d,a
        ret

