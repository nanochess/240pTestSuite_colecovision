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

	; Processed from MAME MSX1/MSX2 data and contributed by Patrick van Arkel (vampier).

MAME_ENTRIES:	EQU 493

mame_start_database:
	db $7f,$8c,$94,$cb,$89,$13,$db,$32,$a6,$96
	db $de,$c8,$0f,$fc,$78,$e4,$66,$93,$f1,$b7
	db "55pbios.ic42",0

	db $05,$fe,$dd,$4b,$9b,$fc,$f4,$94,$90,$20
	db $c7,$9d,$32,$c4,$c3,$f0,$3a,$54,$fb,$62
	db "55pbios.ic43",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "700ddisk.ic6",0

	db $32,$88,$89,$4e,$1b,$e6,$af,$70,$58,$71
	db $49,$9b,$23,$c8,$57,$32,$db,$c4,$09,$93
	db "700dsub.ic6",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "700fdisk.ic6",0

	db $79,$2e,$6b,$28,$14,$ab,$78,$3d,$06,$c7
	db $57,$6c,$1e,$3c,$cd,$6a,$9b,$ba,$c3,$4a
	db "700fsub.ic6",0

	db $33,$76,$cf,$9d,$d2,$b1,$ac,$9b,$41,$bf
	db $6b,$f6,$59,$8b,$33,$13,$6e,$86,$f9,$d5
	db "700pdisk.ic6",0

	db $32,$88,$89,$4e,$1b,$e6,$af,$70,$58,$71
	db $49,$9b,$23,$c8,$57,$32,$db,$c4,$09,$93
	db "700psub.ic6",0

	db $33,$76,$cf,$9d,$d2,$b1,$ac,$9b,$41,$bf
	db $6b,$f6,$59,$8b,$33,$13,$6e,$86,$f9,$d5
	db "700sdisk.ic6",0

	db $1e,$9a,$95,$59,$43,$ae,$ea,$9b,$18,$07
	db $dd,$f1,$25,$0b,$a6,$43,$6d,$8d,$d2,$76
	db "700ssub.ic6",0

	db $22,$b3,$19,$1d,$86,$50,$10,$26,$40,$01
	db $b9,$d8,$96,$18,$6a,$98,$18,$47,$8a,$6b
	db "70fdbas.rom",0

	db $e9,$0f,$80,$a6,$1d,$94,$c6,$17,$85,$0c
	db $41,$5e,$12,$ad,$70,$ac,$41,$e6,$6b,$b7
	db "70fdbios.rom",0

	db $9e,$fa,$74,$4b,$e8,$35,$56,$75,$e7,$bf
	db $dd,$39,$76,$bb,$bf,$af,$85,$d6,$2e,$1d
	db "70fddisk.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "70fdext.rom",0

	db $1e,$f3,$95,$6f,$7f,$91,$88,$73,$fb,$9b
	db $03,$13,$39,$bb,$a4,$5d,$1e,$5e,$58,$78
	db "70fdkdr.rom",0

	db $aa,$d4,$2b,$a4,$28,$9b,$33,$d8,$ee,$d2
	db $25,$d4,$2c,$ea,$93,$0b,$7f,$c5,$c2,$28
	db "70fdmus.rom",0

	db $7f,$8c,$94,$cb,$89,$13,$db,$32,$a6,$96
	db $de,$c8,$0f,$fc,$78,$e4,$66,$93,$f1,$b7
	db "75pbios.ic42",0

	db $05,$fe,$dd,$4b,$9b,$fc,$f4,$94,$90,$20
	db $c7,$9d,$32,$c4,$c3,$f0,$3a,$54,$fb,$62
	db "75pbios.ic43",0

	db $36,$d7,$7d,$35,$7a,$5f,$d1,$5a,$f2,$ab
	db $26,$6e,$e6,$6e,$50,$91,$ba,$47,$70,$a3
	db "cx5fbios.rom",0

	db $36,$d7,$7d,$35,$7a,$5f,$d1,$5a,$f2,$ab
	db $26,$6e,$e6,$6e,$50,$91,$ba,$47,$70,$a3
	db "cx5fbios.rom",0

	db $8c,$c1,$f7,$ce,$ee,$f7,$45,$bb,$34,$e8
	db $02,$53,$97,$1e,$13,$72,$13,$67,$14,$86
	db "f9pfirm2.rom",0

	db $7b,$4a,$96,$40,$28,$47,$de,$cf,$c1,$10
	db $ff,$9e,$da,$71,$3b,$dc,$d2,$18,$bd,$83
	db "f9psub.rom",0

	db $b7,$b4,$e4,$cd,$40,$a8,$56,$bb,$07,$19
	db $76,$e6,$cf,$0f,$5e,$54,$6f,$c8,$6a,$78
	db "videoart.rom",0

	db $17,$1b,$58,$7b,$d5,$a9,$47,$a1,$3f,$31
	db $14,$12,$0b,$6e,$7b,$ac,$a3,$b5,$7d,$78
	db "100bios.rom",0

	db $44,$21,$fa,$25,$04,$cb,$ce,$18,$f7,$c8
	db $4b,$5e,$a9,$7f,$04,$e0,$17,$00,$7f,$07
	db "100han.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "101pbios.ic108",0

	db $5e,$7c,$8e,$ab,$23,$87,$12,$d1,$e1,$8b
	db $02,$19,$c0,$f4,$d4,$da,$e1,$80,$42,$0d
	db "101pbios.ic9",0

	db $64,$ad,$b7,$fc,$f9,$b8,$6f,$59,$d8,$65
	db $8b,$ad,$b0,$2f,$58,$e6,$1b,$b1,$57,$12
	db "101pnote.ic111",0

	db $8f,$fc,$24,$67,$7f,$d9,$d2,$60,$6a,$79
	db $71,$87,$64,$26,$1c,$df,$02,$43,$4f,$0a
	db "101pnote.ic8",0

	db $5e,$7c,$8e,$ab,$23,$87,$12,$d1,$e1,$8b
	db $02,$19,$c0,$f4,$d4,$da,$e1,$80,$42,$0d
	db "10pbios.ic12",0

	db $c7,$a2,$c5,$ba,$ee,$6a,$9f,$0e,$1c,$6e
	db $e7,$d7,$69,$44,$c0,$ab,$18,$86,$79,$6c
	db "1200bios.rom",0

	db $c7,$a2,$c5,$ba,$ee,$6a,$9f,$0e,$1c,$6e
	db $e7,$d7,$69,$44,$c0,$ab,$18,$86,$79,$6c
	db "1300bios.rom",0

	db $17,$1b,$58,$7b,$d5,$a9,$47,$a1,$3f,$31
	db $14,$12,$0b,$6e,$7b,$ac,$a3,$b5,$7d,$78
	db "180bios.rom",0

	db $44,$21,$fa,$25,$04,$cb,$ce,$18,$f7,$c8
	db $4b,$5e,$a9,$7f,$04,$e0,$17,$00,$7f,$07
	db "180han.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "2000bios.rom",0

	db $17,$1b,$58,$7b,$d5,$a9,$47,$a1,$3f,$31
	db $14,$12,$0b,$6e,$7b,$ac,$a3,$b5,$7d,$78
	db "200bios.rom",0

	db $44,$21,$fa,$25,$04,$cb,$ce,$18,$f7,$c8
	db $4b,$5e,$a9,$7f,$04,$e0,$17,$00,$7f,$07
	db "200han.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "201bios.ic9",0

	db $0f,$4f,$09,$f1,$a6,$ef,$75,$35,$b2,$43
	db $af,$ab,$fb,$44,$a3,$a0,$eb,$04,$98,$d9
	db "201note.ic8",0

	db $5e,$7c,$8e,$ab,$23,$87,$12,$d1,$e1,$8b
	db $02,$19,$c0,$f4,$d4,$da,$e1,$80,$42,$0d
	db "201pbios.rom.ic9",0

	db $e8,$4d,$3e,$c7,$a5,$95,$ee,$36,$b5,$0e
	db $97,$96,$83,$c8,$41,$05,$c1,$87,$18,$57
	db "201pnote.rom.ic8",0

	db $63,$05,$0d,$2d,$21,$21,$4a,$72,$1c,$c5
	db $5f,$15,$2c,$22,$b7,$be,$80,$61,$ac,$33
	db "20pbios.ic12",0

	db $4c,$e4,$1f,$cc,$1a,$60,$34,$11,$ec,$4e
	db $99,$55,$64,$09,$c4,$42,$07,$8f,$0e,$cf
	db "23bios.rom",0

	db $4c,$e4,$1f,$cc,$1a,$60,$34,$11,$ec,$4e
	db $99,$55,$64,$09,$c4,$42,$07,$8f,$0e,$cf
	db "23bios.rom",0

	db $fd,$9f,$a7,$8b,$ac,$25,$aa,$3c,$07,$92
	db $42,$5b,$21,$d1,$4e,$36,$4c,$f7,$ee,$a4
	db "23ext.rom",0

	db $fd,$9f,$a7,$8b,$ac,$25,$aa,$3c,$07,$92
	db $42,$5b,$21,$d1,$4e,$36,$4c,$f7,$ee,$a4
	db "23ext.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "25fdbios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "25fdbios.rom",0

	db $bd,$bc,$75,$aa,$cb,$a4,$ea,$0f,$35,$96
	db $94,$f3,$04,$ae,$43,$69,$14,$73,$34,$60
	db "25fddisk.rom",0

	db $50,$f4,$09,$8a,$77,$e7,$af,$70,$93,$e2
	db $9c,$c8,$68,$3d,$2b,$34,$b2,$d0,$7b,$13
	db "25fddisk.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "25fdext.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "25fdext.rom",0

	db $c7,$a2,$c5,$ba,$ee,$6a,$9f,$0e,$1c,$6e
	db $e7,$d7,$69,$44,$c0,$ab,$18,$86,$79,$6c
	db "2700bios.rom.ic32",0

	db $d3,$af,$96,$3e,$25,$29,$66,$2e,$ae,$63
	db $f0,$4a,$25,$30,$45,$46,$85,$a1,$98,$9f
	db "28lbios.ic20",0

	db $b1,$cc,$e6,$0e,$f6,$1c,$05,$8f,$5e,$42
	db $ef,$7a,$c6,$35,$01,$8d,$1a,$43,$11,$68
	db "28sbios.ic2",0

	db $c7,$a2,$c5,$ba,$ee,$6a,$9f,$0e,$1c,$6e
	db $e7,$d7,$69,$44,$c0,$ab,$18,$86,$79,$6c
	db "3000bios.rom",0

	db $af,$fa,$3c,$5c,$d8,$db,$79,$a1,$45,$0a
	db $d8,$a7,$f4,$05,$a4,$25,$b2,$51,$65,$3d
	db "300bios.rom",0

	db $af,$fa,$3c,$5c,$d8,$db,$79,$a1,$45,$0a
	db $d8,$a7,$f4,$05,$a4,$25,$b2,$51,$65,$3d
	db "300ebios.rom",0

	db $09,$f7,$d7,$88,$69,$8a,$23,$aa,$7e,$ec
	db $14,$02,$37,$e9,$07,$d4,$c3,$7c,$bf,$e0
	db "300eext.rom",0

	db $47,$a9,$d9,$a2,$4e,$4f,$c6,$f9,$46,$7c
	db $6e,$7d,$61,$a0,$2d,$45,$f5,$a7,$53,$ef
	db "300ehan.rom",0

	db $fb,$51,$c5,$05,$ad,$fb,$c1,$74,$df,$94
	db $28,$9f,$a8,$94,$ef,$96,$9f,$53,$57,$bc
	db "300ext.rom",0

	db $47,$a9,$d9,$a2,$4e,$4f,$c6,$f9,$46,$7c
	db $6e,$7d,$61,$a0,$2d,$45,$f5,$a7,$53,$ef
	db "300han.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "3256d19-5k3_z-1.g2",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "3256d19-5k3_z-1",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "3256m67-5a3_z-2_uk.u20",0

	db $c7,$a2,$c5,$ba,$ee,$6a,$9f,$0e,$1c,$6e
	db $e7,$d7,$69,$44,$c0,$ab,$18,$86,$79,$6c
	db "3300bios.rom",0

	db $f1,$52,$5d,$e4,$e0,$b6,$0a,$66,$87,$15
	db $6c,$2a,$96,$f8,$a8,$b2,$04,$4b,$6c,$56
	db "3300disk.rom",0

	db $f4,$43,$37,$52,$d3,$bf,$87,$6b,$fe,$fb
	db $36,$3c,$74,$9d,$4d,$2e,$08,$a2,$18,$b6
	db "35jbios.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "35jext.rom",0

	db $dc,$c3,$a6,$77,$32,$aa,$01,$c4,$f2,$ee
	db $8d,$1a,$d8,$86,$44,$4a,$4d,$ba,$fe,$06
	db "35jkdr.rom",0

	db $84,$a6,$45,$be,$ce,$c0,$a2,$5d,$3a,$b7
	db $a9,$09,$cd,$e1,$b2,$42,$69,$9a,$86,$62
	db "35jkfn.rom",0

	db $df,$48,$90,$2f,$5f,$12,$af,$88,$67,$ae
	db $1a,$87,$f2,$55,$14,$5f,$0e,$5e,$07,$74
	db "4000bios.rom",0

	db $77,$bd,$67,$d5,$d1,$0d,$45,$9d,$34,$3e
	db $79,$ea,$fc,$d8,$e1,$7e,$b0,$f2,$09,$dd
	db "4000kdr.rom",0

	db $9e,$d3,$ab,$6d,$89,$36,$32,$b9,$24,$6e
	db $91,$b4,$12,$cd,$5d,$b5,$19,$e7,$58,$6b
	db "4000kfn.rom",0

	db $93,$1d,$63,$18,$77,$4b,$d4,$95,$a3,$2e
	db $c3,$da,$bf,$8d,$0e,$df,$c9,$91,$33,$24
	db "4000word.rom",0

	db $75,$f5,$f0,$a5,$a2,$e8,$f0,$93,$5f,$33
	db $bb,$3c,$f0,$7b,$83,$dd,$3e,$5f,$33,$47
	db "400sbios.u38",0

	db $6b,$64,$0c,$1d,$8c,$be,$da,$6c,$a7,$d6
	db $fa,$cd,$16,$a2,$06,$b6,$2e,$05,$9e,$ee
	db "400shan.u44",0

	db $30,$ff,$f2,$2e,$3e,$3d,$46,$49,$93,$70
	db $74,$88,$44,$27,$21,$a5,$e5,$6a,$97,$07
	db "400skfn.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "4500bios.rom",0

	db $1e,$bb,$06,$06,$24,$28,$fc,$dc,$66,$80
	db $8a,$03,$76,$18,$18,$db,$2b,$ba,$3c,$73
	db "4500budi.rom",0

	db $e8,$9e,$a1,$e8,$e5,$83,$39,$2e,$2d,$d9
	db $de,$bb,$8a,$4b,$6a,$16,$2f,$58,$ba,$91
	db "4500buns.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "4500ext.rom",0

	db $3c,$e8,$e3,$57,$90,$eb,$46,$89,$b2,$1e
	db $14,$c7,$ec,$dd,$4b,$63,$94,$3e,$e1,$58
	db "4500font.rom",0

	db $64,$42,$c1,$c5,$ce,$ce,$64,$c6,$da,$e9
	db $0c,$c6,$ae,$36,$75,$f0,$70,$d9,$3e,$06
	db "4500jush.rom",0

	db $df,$07,$e8,$9f,$a0,$b1,$c7,$87,$4f,$9c
	db $df,$18,$4c,$13,$6f,$96,$4f,$ea,$4f,$f4
	db "4500kdr1.rom",0

	db $c6,$3d,$b2,$66,$60,$da,$96,$af,$56,$f8
	db $a7,$d3,$ea,$18,$54,$4b,$9a,$e5,$a3,$7c
	db "4500kdr2.rom",0

	db $9e,$d3,$ab,$6d,$89,$36,$32,$b9,$24,$6e
	db $91,$b4,$12,$cd,$5d,$b5,$19,$e7,$58,$6b
	db "4500kfn.rom",0

	db $3f,$04,$74,$69,$b6,$2d,$93,$90,$40,$05
	db $a0,$ea,$29,$09,$2e,$89,$27,$24,$ce,$0b
	db "4500wor1.rom",0

	db $4c,$8e,$a0,$5c,$09,$b4,$0c,$41,$88,$8f
	db $a1,$8d,$b0,$65,$57,$5a,$31,$7f,$da,$16
	db "4500wor2.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "4600bios.rom",0

	db $07,$3f,$eb,$8b,$b6,$45,$d9,$35,$e0,$99
	db $af,$af,$61,$e6,$f0,$4f,$52,$ad,$ee,$42
	db "4600disk.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "4600ext.rom",0

	db $00,$57,$94,$c1,$0a,$42,$37,$de,$39,$07
	db $ba,$4a,$44,$d4,$36,$07,$8d,$3c,$06,$c2
	db "4600firm.rom",0

	db $31,$29,$2b,$9c,$a9,$fe,$7d,$1d,$88,$33
	db $53,$0f,$44,$c0,$a5,$67,$1b,$fe,$fe,$4e
	db "4600fon1.rom",0

	db $02,$15,$5f,$c2,$5c,$9b,$d2,$3e,$16,$54
	db $fe,$81,$c7,$44,$86,$35,$1e,$1e,$cc,$28
	db "4600fon2.rom",0

	db $3a,$9a,$94,$2e,$d8,$88,$dd,$64,$1c,$dd
	db $f8,$de,$ad,$a1,$87,$9c,$45,$4d,$f3,$c6
	db "4600kdr.rom",0

	db $a7,$a2,$3d,$c0,$13,$14,$e8,$83,$81,$ee
	db $e8,$8b,$48,$78,$b3,$99,$31,$ab,$48,$18
	db "4600kf12.rom",0

	db $5e,$87,$2d,$58,$53,$69,$87,$31,$a0,$ed
	db $22,$fb,$72,$db,$cd,$fd,$59,$cd,$19,$c3
	db "4600kfn.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "4700bios.rom",0

	db $1e,$bb,$06,$06,$24,$28,$fc,$dc,$66,$80
	db $8a,$03,$76,$18,$18,$db,$2b,$ba,$3c,$73
	db "4700budi.rom",0

	db $e8,$9e,$a1,$e8,$e5,$83,$39,$2e,$2d,$d9
	db $de,$bb,$8a,$4b,$6a,$16,$2f,$58,$ba,$91
	db "4700buns.rom",0

	db $78,$cd,$7f,$84,$7e,$77,$fd,$8c,$d5,$1a
	db $64,$7e,$fb,$27,$25,$ba,$93,$f4,$c4,$71
	db "4700disk.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "4700ext.rom",0

	db $3c,$e8,$e3,$57,$90,$eb,$46,$89,$b2,$1e
	db $14,$c7,$ec,$dd,$4b,$63,$94,$3e,$e1,$58
	db "4700font.rom",0

	db $64,$42,$c1,$c5,$ce,$ce,$64,$c6,$da,$e9
	db $0c,$c6,$ae,$36,$75,$f0,$70,$d9,$3e,$06
	db "4700jush.rom",0

	db $df,$07,$e8,$9f,$a0,$b1,$c7,$87,$4f,$9c
	db $df,$18,$4c,$13,$6f,$96,$4f,$ea,$4f,$f4
	db "4700kdr1.rom",0

	db $c6,$3d,$b2,$66,$60,$da,$96,$af,$56,$f8
	db $a7,$d3,$ea,$18,$54,$4b,$9a,$e5,$a3,$7c
	db "4700kdr2.rom",0

	db $9e,$d3,$ab,$6d,$89,$36,$32,$b9,$24,$6e
	db $91,$b4,$12,$cd,$5d,$b5,$19,$e7,$58,$6b
	db "4700kfn.rom",0

	db $f5,$af,$1d,$2a,$8b,$cf,$24,$7f,$78,$84
	db $7e,$1a,$9d,$99,$5e,$58,$1d,$f8,$7e,$8e
	db "4700wor1.rom",0

	db $4c,$8e,$a0,$5c,$09,$b4,$0c,$41,$88,$8f
	db $a1,$8d,$b0,$65,$57,$5a,$31,$7f,$da,$16
	db "4700wor2.rom",0

	db $59,$96,$77,$65,$d6,$e9,$32,$89,$09,$de
	db $e4,$da,$c1,$cb,$e4,$cf,$9d,$47,$d3,$15
	db "5000bios.rom",0

	db $07,$3f,$eb,$8b,$b6,$45,$d9,$35,$e0,$99
	db $af,$af,$61,$e6,$f0,$4f,$52,$ad,$ee,$42
	db "5000disk.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "5000ext.rom",0

	db $3a,$9a,$94,$2e,$d8,$88,$dd,$64,$1c,$dd
	db $f8,$de,$ad,$a1,$87,$9c,$45,$4d,$f3,$c6
	db "5000kdr.rom",0

	db $5e,$87,$2d,$58,$53,$69,$87,$31,$a0,$ed
	db $22,$fb,$72,$db,$cd,$fd,$59,$cd,$19,$c3
	db "5000kfn.rom",0

	db $98,$bb,$fa,$3a,$b0,$7b,$7a,$5c,$ad,$55
	db $d7,$dd,$f7,$cb,$d9,$44,$0c,$aa,$2a,$86
	db "5000rtc.rom",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "500pbios.rom.ic41",0

	db $5e,$7c,$8e,$ab,$23,$87,$12,$d1,$e1,$8b
	db $02,$19,$c0,$f4,$d4,$da,$e1,$80,$42,$0d
	db "501pbios.rom",0

	db $44,$e0,$dd,$21,$5b,$2a,$9f,$07,$70,$dd
	db $76,$fb,$49,$18,$7c,$05,$b0,$83,$ee,$d9
	db "5500bios.rom",0

	db $44,$e0,$dd,$21,$5b,$2a,$9f,$07,$70,$dd
	db $76,$fb,$49,$18,$7c,$05,$b0,$83,$ee,$d9
	db "5500bios.rom",0

	db $78,$cd,$7f,$84,$7e,$77,$fd,$8c,$d5,$1a
	db $64,$7e,$fb,$27,$25,$ba,$93,$f4,$c4,$71
	db "5500disk.rom",0

	db $78,$cd,$7f,$84,$7e,$77,$fd,$8c,$d5,$1a
	db $64,$7e,$fb,$27,$25,$ba,$93,$f4,$c4,$71
	db "5500disk.rom",0

	db $4b,$e8,$37,$1f,$3b,$03,$e7,$0d,$da,$ca
	db $49,$59,$58,$34,$5f,$3c,$4f,$8e,$2d,$36
	db "5500ext.rom",0

	db $4b,$e8,$37,$1f,$3b,$03,$e7,$0d,$da,$ca
	db $49,$59,$58,$34,$5f,$3c,$4f,$8e,$2d,$36
	db "5500ext.rom",0

	db $b6,$77,$a8,$61,$b6,$7e,$87,$63,$a1,$1d
	db $5d,$cf,$52,$41,$6b,$42,$49,$3a,$de,$57
	db "5500imp.rom",0

	db $b6,$77,$a8,$61,$b6,$7e,$87,$63,$a1,$1d
	db $5d,$cf,$52,$41,$6b,$42,$49,$3a,$de,$57
	db "5500imp.rom",0

	db $3a,$9a,$94,$2e,$d8,$88,$dd,$64,$1c,$dd
	db $f8,$de,$ad,$a1,$87,$9c,$45,$4d,$f3,$c6
	db "5500kdr.rom",0

	db $3a,$9a,$94,$2e,$d8,$88,$dd,$64,$1c,$dd
	db $f8,$de,$ad,$a1,$87,$9c,$45,$4d,$f3,$c6
	db "5500kdr.rom",0

	db $9e,$d3,$ab,$6d,$89,$36,$32,$b9,$24,$6e
	db $91,$b4,$12,$cd,$5d,$b5,$19,$e7,$58,$6b
	db "5500kfn.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "55pbios.ic42",0

	db $b2,$62,$ae,$dc,$71,$b4,$45,$30,$3f,$84
	db $ef,$e5,$e8,$65,$cb,$b7,$1f,$d7,$d9,$52
	db "55pnote.ic44",0

	db $ce,$f1,$6e,$b9,$55,$02,$ba,$6a,$b2,$26
	db $5f,$ca,$fc,$ed,$de,$47,$0a,$10,$15,$41
	db "700dbios.rom.ic5",0

	db $fe,$dd,$9b,$68,$2d,$05,$6d,$dd,$1e,$9b
	db $3d,$28,$17,$23,$e1,$2f,$85,$9b,$2e,$69
	db "700fbios.ic5",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "700pbios.rom.ic5",0

	db $48,$11,$95,$6f,$87,$8c,$3e,$03,$da,$46
	db $31,$7f,$78,$7c,$dc,$4b,$eb,$c8,$6f,$47
	db "700sbios.rom.ic5",0

	db $22,$b3,$19,$1d,$86,$50,$10,$26,$40,$01
	db $b9,$d8,$96,$18,$6a,$98,$18,$47,$8a,$6b
	db "70f2bas.rom",0

	db $e9,$0f,$80,$a6,$1d,$94,$c6,$17,$85,$0c
	db $41,$5e,$12,$ad,$70,$ac,$41,$e6,$6b,$b7
	db "70f2bios.rom",0

	db $9e,$fa,$74,$4b,$e8,$35,$56,$75,$e7,$bf
	db $dd,$39,$76,$bb,$bf,$af,$85,$d6,$2e,$1d
	db "70f2disk.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "70f2ext.rom",0

	db $1e,$f3,$95,$6f,$7f,$91,$88,$73,$fb,$9b
	db $03,$13,$39,$bb,$a4,$5d,$1e,$5e,$58,$78
	db "70f2kdr.rom",0

	db $bc,$db,$4d,$ae,$30,$3d,$fe,$52,$34,$f3
	db $72,$d7,$0a,$5e,$02,$71,$d3,$20,$2c,$36
	db "70f2kfn.rom",0

	db $aa,$d4,$2b,$a4,$28,$9b,$33,$d8,$ee,$d2
	db $25,$d4,$2c,$ea,$93,$0b,$7f,$c5,$c2,$28
	db "70f2mus.rom",0

	db $84,$a6,$45,$be,$ce,$c0,$a2,$5d,$3a,$b7
	db $a9,$09,$cd,$e1,$b2,$42,$69,$9a,$86,$62
	db "70fdkfn.rom",0

	db $ea,$6a,$82,$cf,$8c,$6e,$65,$eb,$30,$b9
	db $87,$55,$c8,$57,$7c,$de,$8d,$91,$86,$c0
	db "728bios.rom",0

	db $82,$41,$5e,$e0,$31,$72,$1d,$19,$54,$bf
	db $a4,$2e,$1c,$6d,$d7,$9d,$71,$c6,$92,$d6
	db "728esbios.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "75bios.rom",0

	db $38,$a6,$45,$fe,$bd,$0e,$0f,$e8,$6d,$59
	db $4f,$27,$c2,$d1,$4b,$e9,$95,$ac,$c7,$30
	db "75dbios.rom",0

	db $97,$ce,$59,$89,$25,$73,$ca,$c3,$c4,$40
	db $ef,$ff,$6d,$74,$c8,$a1,$c2,$9a,$5a,$d3
	db "75dnote.rom",0

	db $5f,$26,$31,$9a,$ec,$33,$54,$a9,$4e,$2a
	db $98,$e0,$7b,$2c,$70,$04,$6b,$c4,$54,$17
	db "75note.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "75pbios.ic42",0

	db $b2,$62,$ae,$dc,$71,$b4,$45,$30,$3f,$84
	db $ef,$e5,$e8,$65,$cb,$b7,$1f,$d7,$d9,$52
	db "75pnote.ic44",0

	db $42,$25,$2c,$f8,$7d,$ee,$b5,$81,$81,$a7
	db $bf,$ec,$7c,$87,$41,$90,$a1,$35,$17,$79
	db "8000bios.rom",0

	db $89,$86,$30,$ad,$14,$97,$dc,$9a,$32,$95
	db $80,$c6,$82,$ee,$55,$c4,$bc,$b9,$c3,$0c
	db "8010fbios.663",0

	db $21,$32,$93,$98,$c0,$f3,$50,$e3,$30,$b3
	db $53,$f4,$5f,$21,$aa,$7b,$a3,$38,$fc,$8d
	db "801bios.rom",0

	db $82,$9c,$00,$c3,$11,$4f,$25,$b3,$da,$e5
	db $15,$7c,$0a,$23,$8b,$52,$a3,$ac,$37,$db
	db "8020-00bios.rom",0

	db $ae,$4a,$66,$32,$d4,$45,$6e,$f4,$46,$03
	db $e7,$2f,$5a,$cd,$5b,$bc,$d6,$c0,$d1,$24
	db "8020-19bios.u11",0

	db $e9,$98,$f0,$c4,$41,$f4,$f1,$80,$0e,$f4
	db $4e,$42,$cd,$16,$59,$15,$02,$06,$cf,$79
	db "8020-20bios.u11",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "8230bios.rom.u12",0

	db $0f,$57,$98,$85,$0d,$11,$b3,$16,$a4,$25
	db $4b,$22,$2c,$a0,$8c,$c4,$ad,$6d,$4d,$a2
	db "8230disk.rom.u13",0

	db $32,$88,$89,$4e,$1b,$e6,$af,$70,$58,$71
	db $49,$9b,$23,$c8,$57,$32,$db,$c4,$09,$93
	db "8230ext.rom.u11",0

	db $61,$03,$b3,$9f,$1e,$38,$d1,$aa,$2d,$84
	db $b1,$c3,$21,$9c,$44,$f1,$ab,$b5,$43,$6e
	db "8240bios.rom",0

	db $c3,$ef,$ed,$da,$7a,$b9,$47,$a0,$6d,$93
	db $45,$f7,$b8,$26,$10,$76,$fa,$7c,$ee,$ef
	db "8240disk.rom",0

	db $5c,$1f,$9c,$7f,$b6,$55,$e4,$3d,$38,$e5
	db $dd,$1f,$cc,$6b,$94,$2b,$2f,$f6,$8b,$02
	db "8240ext.rom",0

	db $61,$03,$b3,$9f,$1e,$38,$d1,$aa,$2d,$84
	db $b1,$c3,$21,$9c,$44,$f1,$ab,$b5,$43,$6e
	db "8255bios.rom.ic119",0

	db $c3,$ef,$ed,$da,$7a,$b9,$47,$a0,$6d,$93
	db $45,$f7,$b8,$26,$10,$76,$fa,$7c,$ee,$ef
	db "8255disk.rom.ic117",0

	db $5c,$1f,$9c,$7f,$b6,$55,$e4,$3d,$38,$e5
	db $dd,$1f,$cc,$6b,$94,$2b,$2f,$f6,$8b,$02
	db "8255ext.rom.ic118",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "a1bios.rom",0

	db $d9,$30,$7b,$fd,$aa,$b1,$31,$2d,$25,$e3
	db $8a,$f7,$c0,$d3,$a7,$67,$1a,$9f,$71,$6b
	db "a1desk1a.rom",0

	db $7f,$5b,$76,$60,$5e,$3d,$89,$8c,$c4,$b5
	db $aa,$cf,$1d,$76,$82,$b8,$2f,$e8,$43,$53
	db "a1desk2.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "a1ext.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "a1fmbios.rom",0

	db $d5,$52,$31,$9a,$19,$81,$44,$94,$e3,$01
	db $6d,$e4,$b8,$f0,$10,$e8,$f7,$b9,$7e,$02
	db "a1fmext.rom",0

	db $f8,$9e,$3d,$8f,$3b,$68,$55,$c2,$9d,$71
	db $d3,$14,$9c,$c7,$62,$e0,$f6,$91,$8a,$d5
	db "a1fmfirm.rom",0

	db $a7,$a2,$3d,$c0,$13,$14,$e8,$83,$81,$ee
	db $e8,$8b,$48,$78,$b3,$99,$31,$ab,$48,$18
	db "a1fmkf12.rom",0

	db $5e,$87,$2d,$58,$53,$69,$87,$31,$a0,$ed
	db $22,$fb,$72,$db,$cd,$fd,$59,$cd,$19,$c3
	db "a1fmkfn.rom",0

	db $62,$3c,$bc,$a1,$09,$b6,$41,$0d,$f0,$8e
	db $e7,$06,$21,$50,$a6,$bd,$a4,$b5,$d5,$d4
	db "a1fx.ic16",0

	db $62,$3c,$bc,$a1,$09,$b6,$41,$0d,$f0,$8e
	db $e7,$06,$21,$50,$a6,$bd,$a4,$b5,$d5,$d4
	db "a1fx.ic16",0

	db $24,$2e,$73,$d8,$28,$4a,$01,$2b,$27,$5c
	db $0a,$26,$68,$44,$eb,$bc,$42,$69,$d7,$87
	db "a1gtbios.rom",0

	db $48,$80,$bf,$34,$f1,$c8,$6f,$ff,$54,$56
	db $ec,$2b,$4c,$f7,$0d,$02,$33,$9e,$2c,$aa
	db "a1gtdos.rom",0

	db $01,$8d,$7a,$52,$22,$f2,$85,$14,$90,$8f
	db $b1,$b1,$51,$32,$86,$a6,$55,$8a,$6d,$05
	db "a1gtext.rom",0

	db $e7,$79,$c3,$38,$eb,$91,$a7,$de,$a3,$ff
	db $75,$f3,$fd,$e7,$6b,$8a,$f2,$2c,$4a,$3a
	db "a1gtfirm.rom",0

	db $5b,$39,$c1,$cc,$d3,$a2,$13,$b7,$8e,$02
	db $92,$7f,$56,$a9,$ab,$c7,$2c,$d8,$c2,$8d
	db "a1gtkdr.rom",0

	db $5a,$ff,$2d,$9b,$6e,$fc,$72,$3b,$c3,$95
	db $b0,$f9,$6f,$0a,$df,$a8,$3c,$c5,$4a,$49
	db "a1gtkfn.rom",0

	db $6a,$ea,$1a,$ef,$5e,$c3,$1c,$18,$26,$c2
	db $2e,$df,$58,$05,$25,$f9,$3b,$aa,$d4,$25
	db "a1gtmus.rom",0

	db $b4,$43,$3a,$39,$75,$c5,$7d,$d4,$40,$d6
	db $bf,$12,$db,$d2,$8b,$2a,$c1,$b9,$0e,$f4
	db "a1gtopt.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "a1mk2ext.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "a1mkbios.rom",0

	db $27,$52,$cd,$89,$75,$4c,$05,$ab,$df,$7c
	db $23,$cb,$a1,$32,$d3,$8e,$3e,$f0,$f2,$7d
	db "a1mkcoc1.rom",0

	db $e1,$94,$d2,$90,$eb,$fa,$45,$95,$ce,$03
	db $49,$ea,$2f,$c1,$54,$42,$50,$84,$85,$b0
	db "a1mkcoc2.rom",0

	db $a3,$f4,$e2,$e4,$93,$40,$74,$92,$5d,$77
	db $5a,$fe,$30,$ac,$72,$f1,$50,$ed,$e5,$43
	db "a1mkcoc3.rom",0

	db $f0,$78,$b5,$ec,$56,$88,$4b,$fb,$81,$48
	db $1d,$45,$c7,$15,$14,$18,$77,$0b,$ff,$5a
	db "a1stbios.rom",0

	db $5d,$21,$86,$65,$8a,$dc,$f4,$ce,$0c,$2d
	db $32,$32,$38,$4b,$57,$12,$34,$11,$08,$e5
	db "a1stdos.rom",0

	db $37,$34,$12,$f9,$c3,$27,$62,$de,$1c,$3a
	db $7e,$27,$fc,$3d,$80,$61,$4e,$0a,$0c,$8e
	db "a1stext.rom",0

	db $c2,$12,$b1,$1f,$da,$13,$f8,$3d,$af,$ed
	db $68,$8c,$54,$d0,$98,$e7,$e4,$7a,$b2,$25
	db "a1stfirm.rom",0

	db $5b,$39,$c1,$cc,$d3,$a2,$13,$b7,$8e,$02
	db $92,$7f,$56,$a9,$ab,$c7,$2c,$d8,$c2,$8d
	db "a1stkdr.rom",0

	db $5a,$ff,$2d,$9b,$6e,$fc,$72,$3b,$c3,$95
	db $b0,$f9,$6f,$0a,$df,$a8,$3c,$c5,$4a,$49
	db "a1stkfn.rom",0

	db $e0,$02,$a9,$b4,$26,$73,$2e,$6c,$2d,$31
	db $e5,$48,$c4,$0c,$f7,$c1,$22,$34,$8c,$e3
	db "a1stmus.rom",0

	db $cb,$06,$de,$a7,$b0,$25,$74,$5f,$9d,$2b
	db $87,$dc,$f0,$3d,$ed,$61,$52,$87,$ea,$d3
	db "a1stopt.rom",0

	db $f4,$43,$37,$52,$d3,$bf,$87,$6b,$fe,$fb
	db $36,$3c,$74,$9d,$4d,$2e,$08,$a2,$18,$b6
	db "a1wsbios.rom",0

	db $7e,$d7,$c5,$5e,$03,$59,$73,$7a,$c5,$e6
	db $8d,$38,$cb,$69,$03,$f9,$e5,$d7,$c2,$b6
	db "a1wsdisk.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "a1wsext.rom",0

	db $33,$30,$d9,$b6,$b7,$6e,$3c,$4c,$cb,$7c
	db $f2,$52,$49,$6e,$d1,$5d,$08,$b9,$5d,$3f
	db "a1wsfirm.rom",0

	db $dc,$c3,$a6,$77,$32,$aa,$01,$c4,$f2,$ee
	db $8d,$1a,$d8,$86,$44,$4a,$4d,$ba,$fe,$06
	db "a1wskdr.rom",0

	db $5a,$ff,$2d,$9b,$6e,$fc,$72,$3b,$c3,$95
	db $b0,$f9,$6f,$0a,$df,$a8,$3c,$c5,$4a,$49
	db "a1wskfn.rom",0

	db $aa,$d4,$2b,$a4,$28,$9b,$33,$d8,$ee,$d2
	db $25,$d4,$2c,$ea,$93,$0b,$7f,$c5,$c2,$28
	db "a1wsmusp.rom",0

	db $e9,$0f,$80,$a6,$1d,$94,$c6,$17,$85,$0c
	db $41,$5e,$12,$ad,$70,$ac,$41,$e6,$6b,$b7
	db "a1wxbios.rom",0

	db $e9,$0f,$80,$a6,$1d,$94,$c6,$17,$85,$0c
	db $41,$5e,$12,$ad,$70,$ac,$41,$e6,$6b,$b7
	db "a1wxbios.rom",0

	db $bb,$59,$c8,$49,$89,$8d,$46,$a2,$3f,$db
	db $d0,$cc,$04,$ab,$35,$08,$8e,$74,$a1,$8d
	db "a1wxdisk.rom",0

	db $2a,$0d,$22,$8a,$fd,$e3,$6a,$c7,$c5,$d3
	db $c2,$aa,$c9,$c7,$c6,$64,$dd,$07,$1a,$8c
	db "a1wxdisk.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "a1wxext.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "a1wxext.rom",0

	db $8e,$0d,$4a,$77,$e7,$d5,$73,$6e,$82,$25
	db $c2,$df,$47,$01,$50,$93,$63,$eb,$23,$0f
	db "a1wxfira.rom",0

	db $d3,$7a,$b4,$bd,$2b,$fd,$dd,$8c,$97,$47
	db $6c,$be,$73,$47,$ae,$58,$1a,$6f,$29,$72
	db "a1wxfirm.rom",0

	db $1e,$f3,$95,$6f,$7f,$91,$88,$73,$fb,$9b
	db $03,$13,$39,$bb,$a4,$5d,$1e,$5e,$58,$78
	db "a1wxkdr.rom",0

	db $1e,$f3,$95,$6f,$7f,$91,$88,$73,$fb,$9b
	db $03,$13,$39,$bb,$a4,$5d,$1e,$5e,$58,$78
	db "a1wxkdr.rom",0

	db $5a,$ff,$2d,$9b,$6e,$fc,$72,$3b,$c3,$95
	db $b0,$f9,$6f,$0a,$df,$a8,$3c,$c5,$4a,$49
	db "a1wxkfn.rom",0

	db $5a,$ff,$2d,$9b,$6e,$fc,$72,$3b,$c3,$95
	db $b0,$f9,$6f,$0a,$df,$a8,$3c,$c5,$4a,$49
	db "a1wxkfn.rom",0

	db $63,$54,$cc,$c5,$c1,$00,$b1,$c5,$58,$c9
	db $39,$5f,$a8,$c0,$07,$84,$d2,$e9,$b0,$a3
	db "a1wxmusp.rom",0

	db $63,$54,$cc,$c5,$c1,$00,$b1,$c5,$58,$c9
	db $39,$5f,$a8,$c0,$07,$84,$d2,$e9,$b0,$a3
	db "a1wxmusp.rom",0

	db $91,$e5,$22,$47,$3a,$84,$70,$51,$15,$84
	db $df,$3e,$e5,$b3,$25,$ea,$5e,$2b,$81,$ef
	db "ac88asm.rom",0

	db $1f,$c2,$30,$69,$11,$ab,$6e,$1e,$bd,$f7
	db $cb,$8c,$3c,$34,$a7,$f1,$16,$41,$4e,$88
	db "ac88bios.rom",0

	db $d5,$52,$88,$25,$c7,$ee,$a2,$cf,$ea,$dd
	db $64,$db,$1d,$bd,$be,$13,$44,$47,$8f,$c6
	db "ac88ext.rom",0

	db $02,$87,$b2,$ec,$89,$7b,$91,$96,$78,$8c
	db $d9,$f1,$0c,$99,$e1,$48,$7d,$7a,$db,$bb
	db "ax170arab.rom",0

	db $5e,$09,$4f,$ca,$95,$ab,$8e,$91,$87,$3e
	db $e3,$72,$a3,$f1,$23,$9b,$9a,$48,$a4,$8d
	db "ax170bios.rom",0

	db $f8,$cd,$4c,$05,$08,$3d,$ec,$fc,$09,$8c
	db $ff,$07,$7e,$05,$5a,$4a,$e1,$e9,$1a,$73
	db "ax350iiarab.rom",0

	db $35,$19,$5a,$b6,$7c,$28,$9a,$0b,$47,$08
	db $83,$46,$4d,$f6,$6b,$c6,$ea,$5b,$00,$d3
	db "ax350iibios.rom",0

	db $35,$8e,$69,$f4,$27,$39,$00,$41,$b5,$aa
	db $28,$01,$85,$50,$a8,$8f,$99,$6b,$dd,$b6
	db "ax350iidisk.rom",0

	db $eb,$b7,$6f,$90,$61,$e8,$75,$36,$50,$23
	db $52,$36,$07,$db,$61,$0f,$2e,$da,$1d,$26
	db "ax350iiext.rom",0

	db $50,$77,$b9,$c8,$6c,$e1,$dc,$0a,$22,$c7
	db $17,$82,$da,$c7,$fb,$3c,$a2,$a4,$67,$e0
	db "ax350iifarab.rom",0

	db $b0,$34,$76,$4e,$6a,$89,$78,$db,$60,$b1
	db $d6,$52,$91,$7f,$5e,$24,$a6,$6a,$79,$25
	db "ax350iifbios.rom",0

	db $bd,$0a,$d6,$48,$d7,$28,$c6,$91,$fc,$ee
	db $08,$ea,$aa,$a9,$5e,$15,$e2,$9c,$0d,$0d
	db "ax350iifdisk.rom",0

	db $4c,$bc,$eb,$a8,$f3,$7f,$08,$27,$2b,$61
	db $2b,$6f,$c2,$12,$ee,$af,$37,$9d,$a9,$c3
	db "ax350iifext.rom",0

	db $ac,$e2,$02,$e8,$73,$37,$fb,$c5,$4f,$ea
	db $21,$e2,$2c,$0b,$3a,$f0,$ab,$e6,$f4,$ae
	db "ax350iifpaint.rom",0

	db $54,$ff,$13,$b5,$88,$68,$01,$8f,$cd,$43
	db $c9,$16,$b8,$d7,$c7,$20,$0e,$bd,$ca,$be
	db "ax350iifword.rom",0

	db $ac,$e2,$02,$e8,$73,$37,$fb,$c5,$4f,$ea
	db $21,$e2,$2c,$0b,$3a,$f0,$ab,$e6,$f4,$ae
	db "ax350iipaint.rom",0

	db $3a,$74,$e7,$3b,$94,$d0,$66,$b0,$18,$7f
	db $eb,$74,$3c,$5e,$ce,$dd,$f0,$c6,$1c,$2b
	db "ax350iiword.rom",0

	db $0c,$08,$e7,$99,$a7,$cf,$13,$0a,$e2,$b9
	db $bc,$93,$f2,$8b,$d4,$95,$9c,$ee,$6f,$dc
	db "ax370arab.rom",0

	db $35,$19,$5a,$b6,$7c,$28,$9a,$0b,$47,$08
	db $83,$46,$4d,$f6,$6b,$c6,$ea,$5b,$00,$d3
	db "ax370bios.rom",0

	db $9e,$fa,$74,$4b,$e8,$35,$56,$75,$e7,$bf
	db $dd,$39,$76,$bb,$bf,$af,$85,$d6,$2e,$1d
	db "ax370disk.rom",0

	db $ee,$9c,$6a,$07,$37,$66,$be,$f2,$22,$0a
	db $57,$37,$2f,$5c,$0d,$bf,$c6,$e5,$5c,$8c
	db "ax370ext.rom",0

	db $1c,$9a,$58,$67,$d3,$9f,$6f,$02,$a0,$a4
	db $ef,$29,$19,$04,$62,$3e,$25,$21,$c2,$c5
	db "ax370paint.rom",0

	db $81,$67,$11,$7a,$00,$38,$24,$22,$0c,$36
	db $77,$56,$82,$ac,$bb,$36,$b3,$73,$3c,$5e
	db "ax370sakhr.rom",0

	db $4b,$45,$08,$13,$1d,$ca,$6d,$81,$16,$94
	db $ae,$63,$79,$f4,$13,$64,$c4,$77,$de,$58
	db "ax370swp.rom",0

	db $92,$ba,$c0,$b2,$99,$5f,$54,$f0,$ee,$bf
	db $16,$7c,$d4,$47,$36,$1a,$6a,$49,$23,$eb
	db "ax500arab.rom",0

	db $dd,$1b,$57,$7e,$a3,$ea,$69,$de,$84,$a6
	db $8d,$31,$12,$61,$39,$28,$81,$f9,$ea,$c3
	db "ax500bios.rom",0

	db $a9,$53,$be,$f0,$71,$b6,$03,$d6,$28,$0b
	db $df,$7a,$b6,$24,$9c,$2e,$6f,$1a,$4c,$d8
	db "ax500disk.rom",0

	db $7f,$86,$af,$13,$e8,$12,$59,$a0,$db,$8f
	db $70,$d8,$a7,$e0,$26,$fb,$91,$8e,$e6,$52
	db "ax500ext.rom",0

	db $80,$87,$2d,$99,$7d,$18,$e1,$a6,$33,$e7
	db $0b,$9d,$a3,$5a,$0d,$28,$11,$30,$73,$e5
	db "ax500paint.rom",0

	db $8e,$88,$99,$99,$ec,$ec,$30,$2f,$05,$d3
	db $bd,$0a,$0f,$12,$7b,$48,$9f,$cf,$37,$39
	db "ax500sakhr.rom",0

	db $86,$74,$d0,$00,$a5,$2e,$c0,$1f,$d8,$0c
	db $8c,$b7,$cb,$aa,$66,$d4,$c3,$ca,$5c,$f7
	db "ax500swp.rom",0

	db $ee,$0d,$8c,$cf,$c2,$47,$36,$80,$78,$d2
	db $71,$83,$c3,$4b,$3a,$5c,$0f,$4a,$e0,$f1
	db "bios.ic119",0

	db $69,$bf,$27,$b6,$10,$e1,$14,$37,$da,$d1
	db $f7,$a1,$c3,$7a,$63,$17,$9a,$29,$3d,$12
	db "cf2700g.ic32",0

	db $5e,$6b,$13,$06,$a3,$0b,$bb,$46,$af,$61
	db $48,$7d,$1a,$3c,$c1,$b0,$a6,$90,$04,$c3
	db "cf2700uk.ic32",0

	db $02,$74,$dd,$9b,$50,$96,$06,$5a,$7f,$4e
	db $d0,$19,$10,$11,$24,$c9,$bd,$1d,$56,$b8
	db "cieldisk.rom",0

	db $02,$74,$dd,$9b,$50,$96,$06,$5a,$7f,$4e
	db $d0,$19,$10,$11,$24,$c9,$bd,$1d,$56,$b8
	db "cieldisk.rom",0

	db $a0,$8a,$94,$0a,$a8,$73,$13,$50,$9e,$00
	db $bc,$5a,$c7,$49,$4d,$53,$d8,$e0,$34,$92
	db "cpc-51_v_1_01.ic05",0

	db $dd,$3c,$39,$c8,$cf,$a0,$6e,$c6,$9f,$54
	db $c9,$5c,$3b,$22,$91,$e3,$da,$7b,$d4,$f2
	db "cpc64122.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "cx5fbios.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "cx5fbios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "cx7mbios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "cx7mext.rom",0

	db $5c,$1f,$9c,$7f,$b6,$55,$e4,$3d,$38,$e5
	db $dd,$1f,$cc,$6b,$94,$2b,$2f,$f6,$8b,$02
	db "d23128ec.ic118",0

	db $61,$03,$b3,$9f,$1e,$38,$d1,$aa,$2d,$84
	db $b1,$c3,$21,$9c,$44,$f1,$ab,$b5,$43,$6e
	db "d23c256eac.ic119",0

	db $9a,$62,$d7,$a5,$cc,$da,$97,$42,$61,$f7
	db $c0,$60,$04,$76,$d8,$5e,$10,$de,$b9,$9b
	db "da1024d0365r.ic18",0

	db $5e,$87,$2d,$58,$53,$69,$87,$31,$a0,$ed
	db $22,$fb,$72,$db,$cd,$fd,$59,$cd,$19,$c3
	db "da531p6616_0.ic17",0

	db $5c,$46,$3d,$d9,$90,$58,$2e,$67,$7c,$82
	db $06,$f6,$10,$35,$a7,$c5,$4d,$8c,$67,$f0
	db "ddxbios.rom",0

	db $fe,$02,$54,$cb,$fc,$11,$40,$5b,$79,$e7
	db $c8,$6c,$77,$69,$bd,$63,$22,$b0,$49,$95
	db "ddxext.rom",0

	db $d5,$bf,$48,$14,$ea,$69,$44,$81,$c8,$ba
	db $db,$b8,$de,$8d,$56,$a0,$8e,$e0,$3c,$c0
	db "dpc200bios.rom",0

	db $d3,$af,$96,$3e,$25,$29,$66,$2e,$ae,$63
	db $f0,$4a,$25,$30,$45,$46,$85,$a1,$98,$9f
	db "dpc200ebios.rom",0

	db $d6,$72,$08,$45,$92,$8e,$e8,$48,$cf,$a8
	db $8a,$86,$ac,$cb,$06,$73,$97,$68,$5f,$02
	db "eddpbios.rom",0

	db $f1,$52,$5d,$e4,$e0,$b6,$0a,$66,$87,$15
	db $6c,$2a,$96,$f8,$a8,$b2,$04,$4b,$6c,$56
	db "eddpdisk.rom",0

	db $9c,$43,$10,$6d,$ba,$3a,$e2,$82,$9e,$9a
	db $11,$df,$fa,$9d,$00,$0e,$d6,$d6,$45,$4c
	db "exp20bios.rom",0

	db $4f,$2a,$7e,$01,$72,$f0,$21,$4f,$02,$5f
	db $23,$84,$5f,$6e,$05,$3d,$0f,$fd,$28,$e8
	db "exp20ext.rom",0

	db $50,$29,$cf,$47,$03,$1b,$22,$bd,$5d,$1f
	db $68,$eb,$fd,$3b,$e6,$d6,$da,$56,$df,$e9
	db "exp30bios.rom",0

	db $50,$29,$cf,$47,$03,$1b,$22,$bd,$5d,$1f
	db $68,$eb,$fd,$3b,$e6,$d6,$da,$56,$df,$e9
	db "exp30bios.rom",0

	db $cc,$17,$44,$c6,$c5,$13,$d6,$40,$9a,$14
	db $2b,$4f,$b4,$2f,$be,$70,$a9,$5d,$9b,$7f
	db "exp30ext.rom",0

	db $cc,$17,$44,$c6,$c5,$13,$d6,$40,$9a,$14
	db $2b,$4f,$b4,$2f,$be,$70,$a9,$5d,$9b,$7f
	db "exp30ext.rom",0

	db $be,$fe,$bc,$91,$6b,$fd,$b5,$e8,$05,$70
	db $40,$f0,$ae,$82,$b5,$51,$7a,$77,$50,$db
	db "exp30mus.rom",0

	db $be,$fe,$bc,$91,$6b,$fd,$b5,$e8,$05,$70
	db $40,$f0,$ae,$82,$b5,$51,$7a,$77,$50,$db
	db "exp30mus.rom",0

	db $ef,$3e,$01,$0e,$b5,$7e,$44,$76,$70,$0a
	db $3b,$bf,$f9,$d2,$11,$9a,$b3,$ac,$df,$62
	db "expbios.rom",0

	db $d6,$72,$08,$45,$92,$8e,$e8,$48,$cf,$a8
	db $8a,$86,$ac,$cb,$06,$73,$97,$68,$5f,$02
	db "expbios11.rom",0

	db $d6,$72,$08,$45,$92,$8e,$e8,$48,$cf,$a8
	db $8a,$86,$ac,$cb,$06,$73,$97,$68,$5f,$02
	db "exppbios.rom",0

	db $d4,$ce,$a8,$c8,$15,$f3,$ee,$ab,$e0,$c6
	db $a1,$c8,$45,$f9,$02,$ec,$43,$18,$bf,$6b
	db "exppdemo.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f12bios.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "f12ext.rom",0

	db $30,$d9,$14,$cd,$a2,$18,$08,$89,$a4,$0a
	db $33,$28,$e0,$a0,$c1,$32,$7f,$4e,$aa,$10
	db "f12note1.rom",0

	db $ed,$2f,$ea,$5c,$2a,$3c,$2e,$58,$d4,$f6
	db $9f,$9d,$63,$6e,$08,$57,$44,$86,$a2,$b1
	db "f12note2.rom",0

	db $91,$7d,$1c,$07,$9e,$03,$c4,$a4,$4d,$e8
	db $64,$f1,$23,$d0,$3c,$4e,$32,$c8,$da,$ae
	db "f12note3.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f1bios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "f1ext.rom",0

	db $9d,$b7,$2b,$b7,$87,$92,$59,$5a,$12,$49
	db $9c,$82,$10,$48,$50,$4d,$c9,$6e,$f8,$48
	db "f1note1.rom",0

	db $aa,$78,$fc,$9b,$cd,$23,$43,$f8,$4c,$f7
	db $90,$31,$0a,$76,$8e,$e4,$7f,$90,$c8,$41
	db "f1note2.rom",0

	db $58,$ac,$cf,$41,$a9,$06,$93,$87,$4b,$86
	db $ce,$98,$d8,$d4,$3c,$27,$be,$b8,$b6,$dc
	db "f1note3.rom",0

	db $4c,$e4,$1f,$cc,$1a,$60,$34,$11,$ec,$4e
	db $99,$55,$64,$09,$c4,$42,$07,$8f,$0e,$cf
	db "f1xdbios.rom.ic27",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "f1xddisk.rom.ic27",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "f1xdext.rom.ic27",0

	db $ad,$e0,$c5,$ba,$55,$74,$f8,$11,$4d,$70
	db $79,$05,$03,$17,$09,$9b,$45,$19,$e8,$8f
	db "f1xjfirm.rom",0

	db $21,$8d,$91,$eb,$6d,$f2,$82,$3c,$92,$4d
	db $37,$74,$a9,$f4,$55,$49,$2a,$10,$ae,$cb
	db "f1xjkfn.rom",0

	db $ad,$e0,$c5,$ba,$55,$74,$f8,$11,$4d,$70
	db $79,$05,$03,$17,$09,$9b,$45,$19,$e8,$8f
	db "f1xvfirm.rom",0

	db $21,$8d,$91,$eb,$6d,$f2,$82,$3c,$92,$4d
	db $37,$74,$a9,$f4,$55,$49,$2a,$10,$ae,$cb
	db "f1xvkfn.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f500bios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f500bios.rom",0

	db $e9,$3b,$8d,$a1,$e8,$dd,$db,$b3,$74,$22
	db $92,$b0,$e5,$e5,$87,$31,$b9,$0e,$93,$13
	db "f500disk.rom",0

	db $e9,$3b,$8d,$a1,$e8,$dd,$db,$b3,$74,$22
	db $92,$b0,$e5,$e5,$87,$31,$b9,$0e,$93,$13
	db "f500disk.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "f500ext.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "f500ext.rom",0

	db $6a,$ca,$f2,$ee,$b5,$7f,$65,$f7,$40,$82
	db $35,$d5,$e0,$7b,$75,$63,$22,$9d,$e7,$99
	db "f500kfn.rom",0

	db $6a,$ca,$f2,$ee,$b5,$7f,$65,$f7,$40,$82
	db $35,$d5,$e0,$7b,$75,$63,$22,$9d,$e7,$99
	db "f500kfn.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f900bios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "f900bios.rom",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "f900disa.rom",0

	db $fc,$76,$0d,$1d,$7b,$16,$37,$0a,$bc,$7e
	db $ea,$39,$95,$5f,$23,$0b,$95,$b3,$7d,$f6
	db "f900disk.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "f900ext.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "f900ext.rom",0

	db $6a,$ca,$f2,$ee,$b5,$7f,$65,$f7,$40,$82
	db $35,$d5,$e0,$7b,$75,$63,$22,$9d,$e7,$99
	db "f900kfn.rom",0

	db $6a,$ca,$f2,$ee,$b5,$7f,$65,$f7,$40,$82
	db $35,$d5,$e0,$7b,$75,$63,$22,$9d,$e7,$99
	db "f900kfn.rom",0

	db $55,$8b,$73,$83,$54,$45,$42,$cf,$73,$33
	db $70,$0f,$f9,$0c,$3e,$fb,$f9,$3b,$a2,$a3
	db "f900util.rom",0

	db $55,$8b,$73,$83,$54,$45,$42,$cf,$73,$33
	db $70,$0f,$f9,$0c,$3e,$fb,$f9,$3b,$a2,$a3
	db "f900util.rom",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "f9pbios.rom.ic11",0

	db $7f,$44,$0e,$c7,$29,$5d,$88,$9b,$09,$7e
	db $1b,$66,$bf,$9b,$c5,$ce,$08,$6f,$59,$aa
	db "f9prbios.rom",0

	db $a6,$d7,$b1,$fd,$4e,$e8,$96,$ca,$75,$13
	db $d0,$2c,$03,$3f,$c9,$a8,$aa,$06,$52,$35
	db "f9prext.rom",0

	db $48,$11,$95,$6f,$87,$8c,$3e,$03,$da,$46
	db $31,$7f,$78,$7c,$dc,$4b,$eb,$c8,$6f,$47
	db "f9sbios.ic11",0

	db $11,$66,$a9,$3d,$71,$85,$ba,$02,$4b,$df
	db $2b,$fa,$9a,$30,$e1,$c4,$47,$fb,$6d,$b1
	db "f9sfirm1.ic12",0

	db $7e,$fa,$c5,$4d,$d8,$f5,$80,$f3,$b7,$80
	db $9a,$b3,$5d,$b4,$ae,$58,$f0,$eb,$84,$d1
	db "f9sfirm2.ic13",0

	db $c4,$25,$75,$0b,$bb,$2a,$e1,$d2,$78,$21
	db $6b,$45,$02,$9d,$30,$3e,$37,$d8,$df,$2f
	db "fc200bios.rom.u5a",0

	db $e1,$8f,$72,$27,$1b,$64,$69,$3a,$2a,$2b
	db $c2,$26,$e1,$b9,$eb,$d0,$44,$8e,$07,$c0
	db "fc200bios.rom.u5b",0

	db $17,$1b,$58,$7b,$d5,$a9,$47,$a1,$3f,$31
	db $14,$12,$0b,$6e,$7b,$ac,$a3,$b5,$7d,$78
	db "fc80ubios.rom",0

	db $58,$db,$e7,$3a,$e8,$0c,$2c,$40,$9e,$76
	db $6c,$3a,$ce,$73,$0e,$cd,$7b,$ec,$89,$d0
	db "fc80uhan.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "fmxbios.rom",0

	db $7b,$be,$3f,$35,$5d,$31,$29,$59,$22,$68
	db $ae,$87,$f4,$0e,$a7,$e3,$ce,$d8,$8f,$98
	db "fsa1.ic3",0

	db $7a,$69,$e9,$b9,$59,$5f,$3b,$00,$60,$15
	db $5f,$4b,$41,$9c,$91,$5d,$4d,$9d,$8c,$a1
	db "fstm1bios.rom",0

	db $30,$73,$70,$40,$d9,$0c,$13,$6d,$34,$dd
	db $40,$9f,$e5,$79,$bc,$4c,$ca,$11,$c4,$69
	db "fstm1desk1.rom",0

	db $ff,$6e,$07,$d3,$97,$6b,$08,$74,$16,$4f
	db $ae,$68,$0a,$e0,$28,$d5,$98,$75,$20,$49
	db "fstm1desk2.rom",0

	db $a4,$bd,$bd,$b2,$0b,$f9,$fd,$3c,$49,$2a
	db $89,$0f,$bf,$54,$1b,$f0,$92,$ea,$a8,$e1
	db "fstm1ext.rom",0

	db $78,$9b,$b6,$cd,$b2,$d1,$ed,$03,$48,$f3
	db $63,$36,$da,$11,$b1,$49,$d7,$4e,$4d,$9f
	db "g10firm.rom",0

	db $c1,$e4,$6c,$00,$f1,$e3,$8f,$c9,$e0,$ab
	db $48,$7b,$f0,$51,$3b,$d9,$3c,$e6,$1f,$3f
	db "g30bios.rom",0

	db $c1,$e4,$6c,$00,$f1,$e3,$8f,$c9,$e0,$ab
	db $48,$7b,$f0,$51,$3b,$d9,$3c,$e6,$1f,$3f
	db "g30bios.rom",0

	db $f7,$c3,$ac,$13,$89,$18,$a4,$93,$eb,$91
	db $62,$8e,$d8,$8c,$f3,$79,$99,$05,$95,$79
	db "g30disk.rom",0

	db $60,$69,$d6,$3c,$68,$b0,$3f,$a5,$6d,$e0
	db $40,$fb,$5f,$52,$ee,$ad,$bf,$fe,$2a,$2c
	db "g30disk.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "g30ext.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "g30ext.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "g30kfn.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "g30kfn.rom",0

	db $78,$2e,$54,$cf,$88,$eb,$4a,$97,$46,$31
	db $ea,$a7,$07,$aa,$d9,$7d,$3e,$b1,$ea,$14
	db "g30rs232c.rom",0

	db $b2,$77,$61,$59,$a7,$b9,$2d,$74,$30,$8b
	db $43,$4a,$6b,$3e,$5f,$eb,$a1,$61,$e2,$b7
	db "g900232c.rom",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "g900bios.ic109",0

	db $0d,$e3,$c8,$02,$05,$75,$60,$56,$0a,$03
	db $d7,$96,$5f,$cc,$4c,$ff,$69,$f8,$57,$5c
	db "g900bios.rom",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "g900disk.ic117",0

	db $12,$f2,$cc,$79,$b3,$d0,$97,$23,$84,$0b
	db $ae,$77,$4b,$e4,$8c,$0d,$72,$1e,$c1,$c6
	db "g900disk.rom",0

	db $32,$88,$89,$4e,$1b,$e6,$af,$70,$58,$71
	db $49,$9b,$23,$c8,$57,$32,$db,$c4,$09,$93
	db "g900ext.ic112",0

	db $32,$88,$89,$4e,$1b,$e6,$af,$70,$58,$71
	db $49,$9b,$23,$c8,$57,$32,$db,$c4,$09,$93
	db "g900ext.rom",0

	db $87,$79,$b0,$04,$e7,$60,$5a,$3c,$41,$98
	db $25,$f0,$37,$3a,$5d,$8f,$a8,$4e,$1d,$5b
	db "g900util.rom",0

	db $f2,$a1,$d3,$26,$d7,$2d,$4c,$70,$ea,$21
	db $4d,$78,$83,$83,$8d,$e8,$84,$7a,$82,$b7
	db "hb-f1xdj_main.rom",0

	db $f2,$a1,$d3,$26,$d7,$2d,$4c,$70,$ea,$21
	db $4d,$78,$83,$83,$8d,$e8,$84,$7a,$82,$b7
	db "hb-f1xdj_main.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "hb10bios.ic12",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "hbf5bios.ic25",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "hbf5ext.rom",0

	db $06,$ba,$91,$d6,$73,$2e,$e8,$a2,$ec,$d5
	db $dc,$c3,$8b,$0c,$e4,$24,$03,$d8,$67,$08
	db "hbf5note.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "hc7bios.rom",0

	db $e2,$11,$53,$40,$64,$ea,$6f,$43,$6f,$2e
	db $74,$58,$de,$d3,$5c,$39,$8f,$17,$b7,$61
	db "hc7firm.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "hc7gbbios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "hc80bios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "hc80ext.rom",0

	db $7f,$49,$8d,$b2,$f4,$31,$b9,$c0,$b4,$2d
	db $ac,$1c,$7c,$a4,$6a,$23,$6b,$78,$02,$28
	db "hc80firm.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "hc90a_kanjifont.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "hc95abios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "hc95aext.rom",0

	db $ca,$ef,$fd,$d6,$54,$39,$47,$26,$c8,$c0
	db $82,$4b,$21,$af,$7f,$f5,$1c,$0b,$10,$31
	db "hc95afirm.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "hc95akfn.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "hn613256p.ic6d",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "hn613256p.ic6d",0

	db $4d,$ad,$9d,$e7,$c2,$8b,$45,$23,$51,$cc
	db $12,$91,$08,$49,$b5,$1b,$d9,$a3,$7a,$b3
	db "hx10bios.ic2",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "hx10dbios.ic5",0

	db $01,$60,$0d,$06,$d8,$30,$72,$d4,$e7,$57
	db $b2,$97,$28,$55,$5e,$fd,$e2,$c7,$97,$05
	db "hx32bios.ic3",0

	db $ed,$58,$9d,$a7,$f3,$59,$a4,$e1,$39,$a2
	db $3c,$d8,$2d,$9a,$6a,$6f,$a3,$d7,$0d,$b0
	db "hx32firm.ic2",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "hx32kfn.rom",0

	db $5e,$05,$75,$26,$fe,$39,$d7,$9e,$88,$e7
	db $ff,$1c,$e0,$2e,$d6,$69,$bd,$38,$92,$9e
	db "hx33bios.ic7",0

	db $5e,$05,$75,$26,$fe,$39,$d7,$9e,$88,$e7
	db $ff,$1c,$e0,$2e,$d6,$69,$bd,$38,$92,$9e
	db "hx33bios.ic7",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "hx33kfn.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "hx34kfn.rom",0

	db $8a,$91,$9d,$be,$ed,$92,$db,$8c,$06,$a6
	db $11,$27,$9e,$fa,$ed,$85,$52,$81,$02,$39
	db "ide240a.rom",0

	db $c3,$ef,$ed,$da,$7a,$b9,$47,$a0,$6d,$93
	db $45,$f7,$b8,$26,$10,$76,$fa,$7c,$ee,$ef
	db "jq00014.ic117",0

	db $dc,$c3,$a6,$77,$32,$aa,$01,$c4,$f2,$ee
	db $8d,$1a,$d8,$86,$44,$4a,$4d,$ba,$fe,$06
	db "kanji.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "kanjifont.rom",0

	db $e7,$61,$e7,$08,$1c,$61,$3a,$d4,$89,$3a
	db $66,$43,$34,$ce,$10,$58,$41,$d0,$e8,$0e
	db "m531000-52_68503.u14",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "mbh1bios.rom",0

	db $3e,$00,$58,$32,$13,$8f,$fd,$e8,$b1,$c3
	db $60,$25,$75,$4f,$81,$c2,$11,$2b,$23,$6d
	db "mbh1firm.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "mbh2bios.rom",0

	db $e2,$14,$0f,$a2,$e8,$e5,$90,$90,$ec,$cc
	db $f5,$5b,$62,$32,$3e,$a9,$dc,$c6,$6d,$0b
	db "mbh2firm.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "mbh3bios.rom",0

	db $74,$ee,$82,$cc,$09,$ff,$cf,$78,$f6,$e9
	db $a3,$f0,$d9,$93,$f8,$f8,$0d,$81,$44,$4c
	db "mbh3firm.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "mbh3sub.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "mbh50bios.rom",0

	db $a3,$02,$85,$15,$ed,$82,$9e,$90,$0c,$c8
	db $de,$b4,$03,$e1,$7b,$09,$a3,$8b,$f9,$b0
	db "microsoldisk.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "mlf80bios.ic2d",0

	db $0c,$be,$0d,$f4,$af,$45,$e8,$f5,$31,$e9
	db $c7,$61,$40,$3a,$c9,$e7,$18,$08,$f2,$0c
	db "mlfx1bios.ic6c",0

	db $c1,$e4,$6c,$00,$f1,$e3,$8f,$c9,$e0,$ab
	db $48,$7b,$f0,$51,$3b,$d9,$3c,$e6,$1f,$3f
	db "mlg10bios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "mlg10ext.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "mlg10kfn.rom",0

	db $e4,$fd,$f5,$18,$a8,$b9,$c8,$ab,$42,$90
	db $c2,$1b,$83,$be,$2c,$34,$79,$65,$fc,$24
	db "mlg1bios.rom",0

	db $1e,$9a,$95,$59,$43,$ae,$ea,$9b,$18,$07
	db $dd,$f1,$25,$0b,$a6,$43,$6d,$8d,$d2,$76
	db "mlg1ext.rom",0

	db $5c,$f0,$ab,$ca,$6d,$bc,$f9,$40,$bc,$33
	db $c4,$33,$ec,$b4,$e4,$ad,$a0,$2f,$bf,$e6
	db "mlg1paint.rom",0

	db $e4,$fd,$f5,$18,$a8,$b9,$c8,$ab,$42,$90
	db $c2,$1b,$83,$be,$2c,$34,$79,$65,$fc,$24
	db "mlg3bios.rom",0

	db $1e,$9a,$95,$59,$43,$ae,$ea,$9b,$18,$07
	db $dd,$f1,$25,$0b,$a6,$43,$6d,$8d,$d2,$76
	db "mlg3ext.rom",0

	db $b1,$ac,$74,$c2,$55,$0d,$55,$35,$79,$c1
	db $17,$6f,$5d,$fd,$e8,$14,$21,$8e,$c3,$11
	db "mlg3rs232c.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "mpc10.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "mpc100bios.ic122",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "msx2basic_tmm23256.ic023",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "msx2basicext_tmm23128p.i",0

	db $a7,$ed,$5f,$d9,$40,$f4,$e3,$a3,$3e,$67
	db $68,$40,$c0,$a8,$3a,$c7,$ee,$54,$d9,$72
	db "mx15bios.rom",0

	db $d1,$86,$94,$e9,$e7,$04,$0b,$28,$51,$fe
	db $98,$5c,$ef,$b8,$97,$66,$86,$8a,$2f,$d3
	db "nms8250fbios.ic119",0

	db $c3,$ef,$ed,$da,$7a,$b9,$47,$a0,$6d,$93
	db $45,$f7,$b8,$26,$10,$76,$fa,$7c,$ee,$ef
	db "nms8250fdisk.ic117",0

	db $fd,$4b,$cc,$81,$a8,$16,$0a,$1d,$ea,$06
	db $03,$6c,$5f,$79,$d2,$00,$f9,$48,$f4,$d6
	db "nms8250fext.ic118",0

	db $61,$03,$b3,$9f,$1e,$38,$d1,$aa,$2d,$84
	db $b1,$c3,$21,$9c,$44,$f1,$ab,$b5,$43,$6e
	db "nms8260bios.rom",0

	db $c3,$ef,$ed,$da,$7a,$b9,$47,$a0,$6d,$93
	db $45,$f7,$b8,$26,$10,$76,$fa,$7c,$ee,$ef
	db "nms8260disk.rom",0

	db $5c,$1f,$9c,$7f,$b6,$55,$e4,$3d,$38,$e5
	db $dd,$1f,$cc,$6b,$94,$2b,$2f,$f6,$8b,$02
	db "nms8260ext.rom",0

	db $77,$f9,$fe,$96,$4f,$6d,$8c,$b8,$c4,$af
	db $3b,$5f,$e6,$3c,$e6,$59,$1d,$52,$88,$e6
	db "nms8260hdd.rom",0

	db $7e,$d7,$c5,$5e,$03,$59,$73,$7a,$c5,$e6
	db $8d,$38,$cb,$69,$03,$f9,$e5,$d7,$c2,$b6
	db "panadisk.rom",0

	db $7e,$d7,$c5,$5e,$03,$59,$73,$7a,$c5,$e6
	db $8d,$38,$cb,$69,$03,$f9,$e5,$d7,$c2,$b6
	db "panadisk.rom",0

	db $66,$5d,$80,$5f,$96,$61,$6e,$10,$37,$f1
	db $82,$30,$50,$65,$7b,$78,$49,$89,$92,$83
	db "pd5031.ic13",0

	db $4f,$01,$02,$cd,$c2,$72,$16,$fd,$9b,$cd
	db $b9,$66,$3d,$b7,$28,$d2,$cc,$d8,$ca,$6d
	db "pd5031.rom",0

	db $e9,$98,$f0,$c4,$41,$f4,$f1,$80,$0e,$f4
	db $4e,$42,$cd,$16,$59,$15,$02,$06,$cf,$79
	db "perfect1bios.rom",0

	db $b6,$f2,$ca,$2e,$8a,$18,$d6,$c7,$cd,$32
	db $6c,$b8,$d1,$a1,$d7,$d7,$47,$f2,$30,$59
	db "phc-70fd.rom",0

	db $4c,$e4,$1f,$cc,$1a,$60,$34,$11,$ec,$4e
	db $99,$55,$64,$09,$c4,$42,$07,$8f,$0e,$cf
	db "phc77bios.rom",0

	db $0f,$bd,$45,$ef,$3d,$d7,$bb,$82,$d4,$c3
	db $1f,$19,$47,$88,$4f,$41,$1f,$1c,$a3,$44
	db "phc77ext.rom",0

	db $db,$03,$21,$1b,$7d,$b4,$68,$99,$df,$41
	db $db,$2b,$1d,$fb,$ec,$97,$21,$09,$a9,$67
	db "phc77kfn.rom",0

	db $41,$80,$54,$41,$58,$a5,$7c,$99,$16,$22
	db $69,$e3,$3e,$4f,$2c,$77,$c9,$fc,$e8,$4e
	db "phc77msxwrite.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "pv7bios.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "px7ukbios.rom",0

	db $4f,$01,$02,$cd,$c2,$72,$16,$fd,$9b,$cd
	db $b9,$66,$3d,$b7,$28,$d2,$cc,$d8,$ca,$6d
	db "px7ukpbasic.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "pxv60bios.rom",0

	db $03,$40,$70,$7c,$5d,$e2,$31,$0d,$cf,$5e
	db $56,$9b,$7d,$b4,$c6,$a6,$a5,$59,$0c,$b7
	db "qxxca0259.ic125",0

	db $62,$0a,$20,$9b,$df,$db,$65,$a2,$23,$80
	db $03,$1f,$ce,$65,$4b,$d1,$df,$61,$de,$f2
	db "qxxca0270.ic127",0

	db $d3,$af,$96,$3e,$25,$29,$66,$2e,$ae,$63
	db $f0,$4a,$25,$30,$45,$46,$85,$a1,$98,$9f
	db "r09256c-fra.ic8",0

	db $c9,$91,$44,$07,$78,$d5,$dc,$9b,$a5,$4c
	db $c0,$e0,$f8,$e0,$32,$d2,$f4,$51,$36,$6f
	db "rs232c_fdd_jvc024c_27c25",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "spc800bios.u7",0

	db $b8,$37,$70,$cc,$a8,$45,$3a,$15,$3d,$7e
	db $26,$00,$70,$a3,$a3,$c0,$59,$d6,$4e,$d3
	db "sub.ic118",0

	db $4d,$0c,$37,$ad,$72,$23,$66,$ac,$7a,$a3
	db $d6,$42,$91,$c3,$db,$72,$88,$4d,$eb,$2d
	db "sx100bios.rom",0

	db $21,$a9,$f6,$0c,$b6,$37,$0d,$06,$17,$ce
	db $54,$c4,$2b,$b7,$d8,$e4,$0a,$4a,$b5,$60
	db "t704p890h11.ic8d",0

	db $9e,$d3,$ab,$6d,$89,$36,$32,$b9,$24,$6e
	db $91,$b4,$12,$cd,$5d,$b5,$19,$e7,$58,$6b
	db "tc531000p_6611.ic212",0

	db $9f,$7c,$fa,$93,$2b,$d7,$df,$d0,$d9,$ec
	db $aa,$dc,$51,$65,$5f,$b5,$57,$c2,$e1,$25
	db "tc53257p_2047.ic3",0

	db $82,$9c,$00,$c3,$11,$4f,$25,$b3,$da,$e5
	db $15,$7c,$0a,$23,$8b,$52,$a3,$ac,$37,$db
	db "tmm23256ad_2023.ic8",0

	db $01,$60,$0d,$06,$d8,$30,$72,$d4,$e7,$57
	db $b2,$97,$28,$55,$5e,$fd,$e2,$c7,$97,$05
	db "tmm23256p_2011.ic2",0

	db $4e,$2e,$c9,$c0,$29,$4a,$18,$a3,$ab,$46
	db $3f,$18,$2f,$93,$33,$d2,$af,$68,$cd,$ca
	db "tmm23256p_2014.ic3",0

	db $82,$9c,$00,$c3,$11,$4f,$25,$b3,$da,$e5
	db $15,$7c,$0a,$23,$8b,$52,$a3,$ac,$37,$db
	db "tmm23256p_2023.ic2",0

	db $82,$9c,$00,$c3,$11,$4f,$25,$b3,$da,$e5
	db $15,$7c,$0a,$23,$8b,$52,$a3,$ac,$37,$db
	db "tmm23256p_2023.ic2",0

	db $32,$89,$33,$6b,$2c,$12,$16,$1f,$d9,$26
	db $a7,$e5,$ce,$86,$57,$70,$ae,$70,$38,$af
	db "tmm23256p_2046.ic3",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "tms23256p_2011.ic2",0

	db $4e,$2e,$c9,$c0,$29,$4a,$18,$a3,$ab,$46
	db $3f,$18,$2f,$93,$33,$d2,$af,$68,$cd,$ca
	db "tms23256p_2014.ic3",0

	db $cd,$eb,$0e,$d8,$ad,$ec,$aa,$ad,$b7,$8d
	db $5a,$53,$64,$fd,$60,$32,$38,$59,$16,$85
	db "tpc310acc.rom",0

	db $7b,$ba,$23,$66,$9b,$7a,$bf,$b6,$a1,$42
	db $f9,$e1,$73,$5b,$84,$7d,$6e,$4e,$82,$67
	db "tpc310bios.rom",0

	db $39,$df,$c4,$62,$60,$f9,$9b,$67,$09,$16
	db $b1,$e5,$5f,$67,$a5,$d4,$13,$6e,$6e,$54
	db "tpc310ext.rom",0

	db $18,$1b,$f5,$8d,$a7,$18,$4e,$12,$8c,$d4
	db $19,$da,$31,$09,$b9,$33,$44,$a5,$43,$cf
	db "tpc310turbo.rom",0

	db $ae,$81,$cc,$93,$e3,$99,$2e,$25,$3d,$42
	db $f4,$84,$51,$ad,$c4,$80,$60,$74,$f4,$94
	db "turbo_jvc019e_27c256.ic0",0

	db $d4,$68,$60,$42,$69,$ae,$76,$64,$ac,$73
	db $9e,$a9,$f9,$22,$a0,$5e,$14,$ff,$a3,$d1
	db "turbo.rom",0

	db $f7,$c3,$ac,$13,$89,$18,$a4,$93,$eb,$91
	db $62,$8e,$d8,$8c,$f3,$79,$99,$05,$95,$79
	db "uc-v102disk.rom",0

	db $a4,$f1,$93,$71,$fd,$09,$b7,$3f,$27,$76
	db $cb,$63,$7b,$0e,$9c,$bd,$84,$15,$f8,$eb
	db "uc-v102rs232.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "v10bios.rom",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "v20bios.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "v25bios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "v25ext.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "v30fbios.rom",0

	db $33,$11,$7c,$47,$54,$3a,$4e,$b0,$03,$92
	db $cb,$9f,$f4,$e5,$03,$00,$49,$99,$a9,$7a
	db "v30fdisk.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "v30fext.rom",0

	db $97,$f9,$a0,$b4,$5e,$e4,$b3,$4d,$87,$ca
	db $3f,$16,$3d,$f3,$2e,$1f,$48,$b0,$f0,$9c
	db "v8bios.rom",0

	db $42,$25,$2c,$f8,$7d,$ee,$b5,$81,$81,$a7
	db $bf,$ec,$7c,$87,$41,$90,$a1,$35,$17,$79
	db "vg8000v1_0.663",0

	db $47,$37,$0b,$ec,$7c,$a1,$f0,$61,$5a,$54
	db $ed,$a5,$48,$b0,$7f,$bc,$0c,$7e,$f3,$98
	db "xbasic2.rom",0

	db $47,$37,$0b,$ec,$7c,$a1,$f0,$61,$5a,$54
	db $ed,$a5,$48,$b0,$7f,$bc,$0c,$7e,$f3,$98
	db "xbasic2.rom",0

	db $47,$37,$0b,$ec,$7c,$a1,$f0,$61,$5a,$54
	db $ed,$a5,$48,$b0,$7f,$bc,$0c,$7e,$f3,$98
	db "xbasic2.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "yc64bios.u20",0

	db $30,$2a,$fb,$5d,$8b,$e2,$6c,$75,$83,$09
	db $ca,$3d,$f6,$11,$ae,$69,$cc,$ed,$28,$21
	db "yis503bios.rom",0

	db $89,$63,$fc,$04,$19,$75,$f3,$1d,$c2,$ab
	db $10,$19,$cf,$dd,$49,$67,$99,$9d,$e5,$3e
	db "yis503f.rom",0

	db $0f,$85,$1e,$e7,$a1,$cf,$79,$81,$9f,$61
	db $cc,$89,$e9,$94,$8e,$e7,$2a,$41,$38,$02
	db "yis503iiirbios.rom",0

	db $f4,$f7,$a5,$4c,$df,$5a,$9d,$d6,$c5,$9f
	db $7c,$b2,$19,$c2,$c5,$eb,$0a,$00,$fa,$8a
	db "yis503iiircpm.rom",0

	db $eb,$b7,$eb,$54,$0a,$39,$05,$09,$ed,$fd
	db $36,$c8,$42,$88,$ba,$85,$e6,$3f,$2d,$1f
	db "yis503iiirebios.rom",0

	db $f4,$f7,$a5,$4c,$df,$5a,$9d,$d6,$c5,$9f
	db $7c,$b2,$19,$c2,$c5,$eb,$0a,$00,$fa,$8a
	db "yis503iiirecpm.rom",0

	db $03,$bf,$6d,$2a,$c8,$6f,$5c,$9a,$b6,$18
	db $e1,$55,$44,$27,$87,$c7,$00,$f9,$9f,$ed
	db "yis503iiireext.rom",0

	db $03,$bf,$6d,$2a,$c8,$6f,$5c,$9a,$b6,$18
	db $e1,$55,$44,$27,$87,$c7,$00,$f9,$9f,$ed
	db "yis503iiirext.rom",0

	db $30,$7a,$7b,$e0,$64,$44,$2f,$eb,$4a,$b2
	db $e1,$a2,$bc,$97,$1b,$13,$8c,$1a,$11,$69
	db "yis503iiirnet.rom",0

	db $30,$7a,$7b,$e0,$64,$44,$2f,$eb,$4a,$b2
	db $e1,$a2,$bc,$97,$1b,$13,$8c,$1a,$11,$69
	db "yis503iiirnet.rom",0

	db $00,$81,$ea,$0d,$25,$bc,$5c,$d8,$d7,$0b
	db $60,$ad,$8c,$fd,$c7,$30,$78,$12,$c0,$fd
	db "yis604bios.rom",0

	db $b8,$e3,$0d,$60,$4d,$31,$9d,$51,$1c,$bf
	db $bc,$61,$e5,$d8,$c3,$8f,$bb,$9c,$5a,$33
	db "yis604ext.rom",0

	db $0f,$85,$1e,$e7,$a1,$cf,$79,$81,$9f,$61
	db $cc,$89,$e9,$94,$8e,$e7,$2a,$41,$38,$02
	db "yis805128r2bios.rom",0

	db $3a,$48,$1c,$7b,$7e,$4f,$04,$06,$a5,$59
	db $52,$bc,$5b,$9f,$8c,$f9,$d6,$99,$37,$6c
	db "yis805128r2disk.rom",0

	db $eb,$b7,$eb,$54,$0a,$39,$05,$09,$ed,$fd
	db $36,$c8,$42,$88,$ba,$85,$e6,$3f,$2d,$1f
	db "yis805128r2ebios.rom",0

	db $3a,$48,$1c,$7b,$7e,$4f,$04,$06,$a5,$59
	db $52,$bc,$5b,$9f,$8c,$f9,$d6,$99,$37,$6c
	db "yis805128r2edisk.rom",0

	db $03,$bf,$6d,$2a,$c8,$6f,$5c,$9a,$b6,$18
	db $e1,$55,$44,$27,$87,$c7,$00,$f9,$9f,$ed
	db "yis805128r2eext.rom",0

	db $e8,$fd,$2b,$bc,$1b,$da,$b1,$2c,$73,$a0
	db $fe,$c1,$78,$a1,$90,$f9,$06,$35,$47,$bb
	db "yis805128r2enet.rom",0

	db $7f,$d2,$a2,$8c,$4f,$da,$eb,$14,$0f,$3c
	db $8c,$8f,$b9,$02,$71,$b1,$47,$2c,$97,$b9
	db "yis805128r2epaint.rom",0

	db $03,$bf,$6d,$2a,$c8,$6f,$5c,$9a,$b6,$18
	db $e1,$55,$44,$27,$87,$c7,$00,$f9,$9f,$ed
	db "yis805128r2ext.rom",0

	db $e8,$fd,$2b,$bc,$1b,$da,$b1,$2c,$73,$a0
	db $fe,$c1,$78,$a1,$90,$f9,$06,$35,$47,$bb
	db "yis805128r2net.rom",0

	db $7f,$d2,$a2,$8c,$4f,$da,$eb,$14,$0f,$3c
	db $8c,$8f,$b9,$02,$71,$b1,$47,$2c,$97,$b9
	db "yis805128r2paint.rom",0

	db $70,$6d,$d6,$70,$36,$ba,$ee,$c7,$12,$7e
	db $4c,$cd,$8c,$8d,$b8,$f6,$ce,$7d,$0e,$4c
	db "ym2301-23907.tmm23256p-2",0

mame_end_database:
	db 0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0
	db "Not in MAME database.",0

