; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #5B14
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

        ORG #5B17
ZZUU    LD A,7
        OUT (#FE),A
        LD A,0
        OUT (#FE),A
        JR ZZUU

START   EQU #65E3
        DISPLAY "savage_main_2",START,#0-#5C0-START-1

        ORG START
        LD A,(#5B14)
        OR A
        JR Z,NO_UL
        LD A,#B7
        LD (#7F98),A
NO_UL   LD A,(#5B15)
        OR A
        JR Z,NO_I
        LD A,#C3
        LD (#7F75),A
NO_I    LD BC,#BFFE
        IN A,(C)
        RRA
        JR C,NO_SKP
        LD B,C
        IN A,(C)
        RRA
        JR C,NO_SKP
        LD A,3
        LD (#E064),A
        LD (#8C63),A
        LD HL,#8B6D
        LD (HL),#C3
        INC L
        LD (HL),.COR_PAS_
        INC L
        LD (HL),'COR_PAS_
NO_SKP
        LD A,#C9
        LD (#6033),A
        LD B,#C0
        LD HL,#66D9
        CALL #6003
        PUSH HL
        PUSH DE
        EX DE,HL
        LD A,#C9
        LD (#601F),A
        LD HL,#401F
        LD BC,#0CC0
DDEP_L1 PUSH BC
        PUSH HL
        PUSH DE
DDEP_L2 LD A,(DE)
        DUP 8
        RLA
        RR C
        EDUP
        LD A,C
        XOR (HL)
        LD (HL),A
        DEC HL
        INC DE
        DJNZ DDEP_L2
        POP DE
        POP HL
        CALL #6010
        EX DE,HL
        CALL #6010
        EX DE,HL
        POP BC
        DEC C
        JR NZ,DDEP_L1
        POP DE
        POP HL
        LD B,#18
        LDIR
        LD HL,CODCHG
        LD DE,#6010
        LD C,#10
        LDIR
        LD A,#ED
        LD (#6033),A
        LD HL,#A600
        LD B,#20
        CALL #6003
        EX DE,HL
        LD B,#20
        CALL #6003

        JR #66BC

CODCHG  PUSH HL
        LD HL,#0020
        ADD HL,DE
        EX DE,HL
        POP HL
        DS 8,0
        DB #10,#EC

        ORG #66BC
        INCBIN "savage2#"

        ORG #66D9
        INCBIN "paneL#2_"

        ;synchronize scroller
        ORG #C11C
        LD A,#00
SCR_SYNC_COUNTER EQU $-1
        INC A
        AND 3
        LD (SCR_SYNC_COUNTER),A
        CALL Z,SCRFIX
        NOP
        NOP

        ORG #669C
SCRFIX
        PUSH IY
        PUSH HL
        LD HL,#2758
        EXX
        LD IY,#5C3A
        LD A,I
        PUSH AF
        XOR A
        LD I,A
        IM 1
        EI
        HALT
        DI
        IM 2
        POP AF
        LD I,A
        EXX
        POP HL
        POP IY
        RET



        ;fix troubles while entering password

        ORG #8B73
        CALL #D9BB

        CALL KEY_IN_
        BIT 1,L
        JP NZ,KEYERR

        CALL KEY_IN_
        JP NZ,KEYERR+3

        LD B,#7F
        CALL KEY_IN
        BIT 4,L
        JR NZ,KEYERR+6

        CALL KEY_IN_
        JR NZ,KEYERR+9

        LD B,#FB
        CALL KEY_IN
        BIT 4,L
        JR NZ,KEYERR+12

        LD B,#FB
        CALL KEY_IN
        BIT 4,L
        JR NZ,KEYERR+15

        CALL KEY_IN_
        JR NZ,KEYERR+18

        ;correct!
COR_PAS
        LD HL,#8C54
        CALL #C0ED
        LD A,3
        LD (#E064),A
        LD (#8C63),A
        CALL #89FA
        LD A,1
        CALL #8A76
COR_PAS_
        JP #8C2B


KEY_IN_ LD B,#FD
KEY_IN  CALL #D9B1
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
        CALL #8C64
;       CALL #D9BB
KEY_IPL LD B,#18
KEY_INP CALL KEY_II
        JR NZ,KEY_INP
        DEC BC
        LD A,B
        OR C
        JR NZ,KEY_INP

        BIT 0,L
        RET


KEY_II  XOR A
        IN A,(#FE)
        CPL
        AND #1F
        RET
        DS 17,0
KEYERR
        DUP 6
        CALL KEY_IN
        EDUP

        ;clear garbage (before setting steck memory here)
        ORG #D012
        DS #22,0

        ;clear garbage
        ORG #FEFE
        DS #101,0

        ;level completed
        ORG #B49B
        JP #5B17

        ORG #A600
        INCBIN "bk1pix_"
        INCBIN "bk2pix_"

        ORG #AE00
        INCBIN "bk1atr"
        ORG #AF00
        INCBIN "bk2atr"

        ORG START

