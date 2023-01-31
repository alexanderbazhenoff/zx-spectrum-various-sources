; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6590
        INCBIN "savage3#"

        ORG #5B14    ;cheat
        DB #FF,#FF

        ORG #6003
        LD DE,#4000
        LD C,#20

        PUSH HL,DE,BC
LOOP    PUSH BC
        PUSH DE
LOOP1   LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        LD A,D
        AND 7
        JR NZ,AROUND
        LD A,E
        SUB #E0
        LD E,A
        SBC A,A
        AND #F8
        ADD A,D
        LD D,A
AROUND  DJNZ LOOP1
        POP DE
        INC DE
        POP BC
        DEC C
        JR NZ,LOOP
        POP HL
        LD L,H
        LD H,C
        DUP 5
        ADD HL,HL
        EDUP
        LD B,H
        LD C,L
        POP HL
        POP DE
        LDIR
        RET

START   EQU #652D
        DISPLAY "savage_main_2",START,#0-#5C0-START-1

        ORG START
        LD A,(#5B14)
        OR A
        JR Z,NO_UL
        LD A,#B7
        LD (#E1F8),A
NO_UL   LD A,(#5B15)
        OR A
        JR Z,NO_I
        LD A,#C9
        LD (#C370),A
        LD (#C358),A
        LD A,#C3
        LD (#E129),A
NO_I    LD BC,#BFFE
        IN A,(C)
        RRA
        JR C,NO_SKP
        LD B,C
        IN A,(C)
        RRA
        JR C,NO_SKP
        LD A,3
        LD (#E2F6),A
        LD (#8776),A
        LD (KMEN_MASK),A
        XOR A
        LD HL,#782F
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
NO_SKP
        LD HL,#F014
        LD B,#40
        CALL #6003
        JR #6590


        ;---fix bug in menue (playing music)
        ORG #E704
        LD A,#3E
KPORT   EQU $-1
        IN A,(#FE)
        CPL
        AND #E6
KMASK   EQU $-1
        RET Z
        IN A,(#FE)
        DS 3,0

        ORG #781F
        CALL MENUEMUS

        ORG #6577
MENUEMUS
        PUSH AF
        LD A,#F7
        LD (KPORT),A
        LD A,7
KMEN_MASK EQU $-1
        LD (KMASK),A
        POP AF
        CALL #8786
        XOR A
        LD (KPORT),A
        LD A,#1F
        LD (KMASK),A
        RET

        ;fix troubles while entering password

        ORG #8600
        CALL #D798

        CALL KEY_IN_
        JP NZ,KEYERR

        LD B,#FB
        CALL KEY_IN
        BIT 2,L
        JP NZ,KEYERR+3

        LD B,#FB
        CALL KEY_IN
        JR NZ,KEYERR+6

        CALL KEY_IN_
        BIT 4,L
        JR NZ,KEYERR+9

        LD B,#DF
        CALL KEY_IN
        JR NZ,KEYERR+12

        CALL KEY_IN_
        BIT 1,L
        JR NZ,KEYERR+15

        ;correct!
COR_PAS
        LD HL,#8739
        LD DE,#1109
        CALL #D480
        LD A,3
        LD (#E2F6),A
        LD (#8776),A
        CALL #E2C4
        LD A,1
        CALL #8786
COR_PAS_
        JP #86AA


KEY_IN_ LD B,#FD
KEY_IN  CALL #D78E
        LD C,#FE
        PUSH BC
KEY_I2L LD B,4
KEY_2IN CALL KEY_II
        JR Z,KEY_I2L
        DEC BC
        LD A,B
        OR C
        JR NZ,KEY_2IN
        POP BC
        IN L,(C)
        CALL #8777
;       CALL #D78E
KEY_IPL LD B,#18
KEY_INP CALL KEY_II
        JR NZ,KEY_INP
        DEC BC
        LD A,B
        OR C
        JR NZ,KEY_INP

        BIT 3,L
        RET


KEY_II  XOR A
        IN A,(#FE)
        CPL
        AND #1F
        RET
        DS 7,#C9
KEYERR
        DUP 5
        CALL KEY_IN
        EDUP

        ;fix score_out bug
        ORG #D682
        LD HL,(#E2F7)
        LD A,(#E302)
        OR A
        JP Z,NO_ADD_SCORE
        DEC A
        INC HL
        LD (#E302),A
        LD (#E2F7),HL
NO_ADD_SCORE

        ;---converted panel
        ORG #F014
        INCBIN "panel#3_"

        ;---clear garbage
        ORG #FF00
        DS #FF,0

        ORG #E312
        DS #50,0

        ORG START
