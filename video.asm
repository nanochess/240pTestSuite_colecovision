        ;
        ; 240p test suite (video tests unit)
        ;
        ; Original program by Artemio Urbina. @artemio
        ; Colecovision version by Oscar Toledo G. @nanochess
        ;
        ; Creation date: Dec/20/2023.
	; Revision date: Dec/21/2023. Added Grid Scroll Test.
        ; Revision date: Dec/22/2023. Added Checkerboard.
        ;

menu_video:
        dw $0820
        db "*Checkerboard",0
        dw $0920
        db "*Grid Scroll Test",0
        dw $0a20
        db "*Horizontal Stripes",0
    if 0
        dw $0820
        db "*Drop Shadow Test",0
        dw $0920
        db "*Striped Sprite Test",0
        dw $0a20
        db "*Lag Test",0
        dw $0b20
        db "*Timing & Reflex Test",0
        dw $0c20
        db "*Scroll Test",0
        dw $1020
        db "*Phase & Sample Rate",0
        dw $1120
        db "*Disappearing Logo",0
        dw $1220
        db "*Backlit Zone Test",0
        dw $1320
        db "*Diagonal Test",0
    endif
        dw $0b20
        db "*Back to Main Menu",0
        dw $0000

video_menu:
        call clean_menu
        ld hl,menu_video
        call build_menu

        or a
        jp z,checkerboard
        dec a
        jp z,grid_scroll
        dec a
        jp z,draw_stripes
        
        jp main_menu

grid_scroll:
        call DISSCR
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR
        ld a,1
        ld (speed),a
        ld (acc),a
        xor a
        ld (x),a
        ld (y),a
        ld (pause),a
        ld (direction),a
        ld (back),a
        ld a,$ff
        ld (oldbuttons),a

.1:     halt
        ld a,(speed)
        cp 1
        jr nc,$+4
        ld a,1
        cp 6
        jr c,$+4
        ld a,5
        ld (speed),a

        ld a,(pause)
        or a
        jr nz,.2
        ld a,(direction)
        or a
        jr z,.3
        ld a,(acc)
        or a
        ld a,(speed)
        jp p,$+5
        neg
        ld b,a
        ld a,(x)
        add a,b
        ld (x),a
        jr .2

.3:
        ld a,(acc)
        or a
        ld a,(speed)
        jp p,$+5
        neg
        ld b,a
        ld a,(y)
        add a,b
        ld (y),a
.2:
        ld a,(back)
        or a
        ld hl,.square
        jr z,$+5
        ld hl,.diagonal

        ld a,(y)
        and 7
        ld e,a
        ld d,0
        add hl,de
        ld a,(x)
        and 7
        ld de,buffer
        jr z,.12
        ld c,a
.14:
        ld a,(hl)
        inc hl
        ld b,c
        rlca
        djnz $-1
        ld (de),a
        inc de
        ld a,e
        cp 255 and (buffer+8)
        jp nz,.14
        jr .11

.12:    ld de,buffer
        ld bc,8
        ldir
.11:
        ld hl,buffer
        ld de,$0000
        ld bc,8
        call nmi_off
        call LDIRVM3
        call nmi_on

        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 0,b         ; Up
        jr z,.4
        ld a,(speed)
        inc a
        ld (speed),a
.4:
        bit 2,b         ; Down
        jr z,.5
        ld a,(speed)
        dec a
        ld (speed),a
.5:
        bit 6,b         ; Button A
        jr z,.6
        ld a,(pause)
        xor 1
        ld (pause),a
.6:
        bit 7,b         ; Button B
        jr z,.7
        ld a,(direction)
        xor 1
        ld (direction),a
.7:
        bit 4,b         ; #
        jr z,.8
        ld a,(acc)
        neg
        ld (acc),a
.8:
        bit 1,b
        jr nz,.9
        bit 3,b
        jr z,.10
.9:
        ld a,(back)
        xor 1
        ld (back),a
.10:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
        call reload_menu
        jp video_menu

.square:
        db $ff
        db $81
        db $81
        db $81
        db $81
        db $81
        db $81
        db $ff
        db $ff
        db $81
        db $81
        db $81
        db $81
        db $81
        db $81
        db $ff

.diagonal:
        db $0f
        db $1e
        db $3c
        db $78
        db $f0
        db $e1
        db $c3
        db $87
        db $0f
        db $1e
        db $3c
        db $78
        db $f0
        db $e1
        db $c3
        db $87

checkerboard:
        call DISSCR
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR

        xor a
        ld (alternate),a
        ld (invert),a
        ld (field),a
        ld (dframe),a
        ld (cframe),a
        ld a,$ff
        ld (oldbuttons),a
        halt
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3

.1:
        halt
        ld a,(alternate)
        ld b,a
        ld a,(invert)
        or b
        jr z,.2
        ld a,(field)
        or a
        jr z,.3
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        xor a
        ld (field),a
        jr .4

.3:
        ld hl,.stripesneg
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        ld a,1
        ld (field),a
.4:
        xor a
        ld (invert),a
.2:
        ld a,(dframe)
        or a
        jr z,.9
        ld hl,buffer
        ld (hl),'F'
        inc hl
        ld (hl),'r'
        inc hl
        ld (hl),'a'
        inc hl
        ld (hl),'m'
        inc hl
        ld (hl),'e'
        inc hl
        ld (hl),':'
        inc hl
        ld (hl),' '
        inc hl
        ld a,(cframe)
        rrca
        rrca
        rrca
        rrca
        and $0f
        add a,$30
        ld (hl),a
        inc hl
        ld a,(cframe)
        and $0f
        add a,$30
        ld (hl),a
        ld hl,buffer
        ld de,$3816
        ld bc,$0009
        call LDIRVM
        ld a,(cframe)
        add a,1         ; cannot be inc a
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (cframe),a
        jr .5

.9:
        ld hl,$3816
        ld bc,$0009
        xor a
        call FILVRM
.5:
        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 6,b
        jr z,.6
        ld a,(alternate)
        xor 1
        ld (alternate),a

.6:
        bit 7,b
        jr z,.7
        ld a,(alternate)
        or a
        jr nz,.7
        ld a,1
        ld (invert),a
.7:
        bit 4,b
        jr z,.8
        ld a,(dframe)
        xor 1
        ld (dframe),a
        xor a
        ld (frame),a
        ld a,(dframe)
        or a
        jr nz,.8
        ld a,(field)
        xor 1
        ld (field),a
        ld a,1
        ld (invert),a
.8:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
        call reload_menu
        jp video_menu

.stripespos:
        db $55,$aa,$55,$aa,$55,$aa,$55,$aa
.stripesneg:
        db $aa,$55,$aa,$55,$aa,$55,$aa,$55

draw_stripes:
        call DISSCR
        call clear_sprites
        call load_letters
        call nmi_off
        ld hl,$0000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$0800
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$1000
        ld bc,$0008
        xor a
        call FILVRM
        ld hl,$2000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$2800
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3000
        ld bc,$0008
        ld a,$f1
        call FILVRM
        ld hl,$3800
        ld bc,$0300
        ld a,$00
        call FILVRM
        call nmi_on
        call ENASCR

        xor a
        ld (alternate),a
        ld (invert),a
        ld (field),a
        ld (dframe),a
        ld (cframe),a
        ld a,$ff
        ld (oldbuttons),a
        halt
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3

.1:
        halt
        ld a,(alternate)
        ld b,a
        ld a,(invert)
        or b
        jr z,.2
        ld a,(field)
        or a
        jr z,.3
        ld hl,.stripespos
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        xor a
        ld (field),a
        jr .4

.3:
        ld hl,.stripesneg
        ld de,$0000
        ld bc,$0008
        call LDIRVM3
        ld a,1
        ld (field),a
.4:
        xor a
        ld (invert),a
.2:
        ld a,(dframe)
        or a
        jr z,.9
        ld hl,buffer
        ld (hl),'F'
        inc hl
        ld (hl),'r'
        inc hl
        ld (hl),'a'
        inc hl
        ld (hl),'m'
        inc hl
        ld (hl),'e'
        inc hl
        ld (hl),':'
        inc hl
        ld (hl),' '
        inc hl
        ld a,(cframe)
        rrca
        rrca
        rrca
        rrca
        and $0f
        add a,$30
        ld (hl),a
        inc hl
        ld a,(cframe)
        and $0f
        add a,$30
        ld (hl),a
        ld hl,buffer
        ld de,$3816
        ld bc,$0009
        call LDIRVM
        ld a,(cframe)
        add a,1         ; cannot be inc a
        daa
        cp $60
        jr nz,$+3
        xor a
        ld (cframe),a
        jr .5

.9:
        ld hl,$3816
        ld bc,$0009
        xor a
        call FILVRM
.5:
        call read_joystick_button
        cpl
        ld c,a
        ld a,(oldbuttons)
        cpl
        and c
        ld b,a
        ld a,c
        ld (oldbuttons),a

        bit 6,b
        jr z,.6
        ld a,(alternate)
        xor 1
        ld (alternate),a

.6:
        bit 7,b
        jr z,.7
        ld a,(alternate)
        or a
        jr nz,.7
        ld a,1
        ld (invert),a
.7:
        bit 4,b
        jr z,.8
        ld a,(dframe)
        xor 1
        ld (dframe),a
        xor a
        ld (frame),a
        ld a,(dframe)
        or a
        jr nz,.8
        ld a,(field)
        xor 1
        ld (field),a
        ld a,1
        ld (invert),a
.8:
        bit 5,b
        jp z,.1
        ld a,15
        ld (debounce),a
        call reload_menu
        jp video_menu

.stripespos:
        db $00,$ff,$00,$ff,$00,$ff,$00,$ff
.stripesneg:
        db $ff,$00,$ff,$00,$ff,$00,$ff,$00


