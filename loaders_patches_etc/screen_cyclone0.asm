; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG 40000
        DI
        LD HL,#FF10
        LD E,#11
        LD BC,#7FFD
        OUT (C),L
        LD (HL),L
        OUT (C),E
        LD (HL),E
        OUT (C),L
        LD A,(HL)
        CP E
        JP Z,PUT48

        EXX
        PUSH HL
        PUSH IY
        LD HL,#BCBC
        LD (HL),#C9
        LD C,L
        INC H
        LD L,0
        LD B,L
        LD A,H
        LD I,A
INT_IL  LD (HL),C
        INC HL
        DJNZ INT_IL
        LD (HL),A
        INC L
        IM 2

        LD BC,#8FF
MASKI_L LD (HL),C
        OR A
        SLA C
        INC L
        DJNZ MASKI_L
        LD HL,#BF08
        LD A,#80
BITMSIL LD (HL),A
        RRCA
        DEC L
        DJNZ BITMSIL

        LD IX,#BE00
        LD IY,#BF00
        LD HL,SCREEN
        LD BC,#0A10
        CALL CONV
        LD BC,#0A11
        CALL CONV
        LD BC,#0A13
        CALL CONV
        LD BC,#0217
        CALL CONV

        LD HL,SCREEN+#1800
        LD DE,#5800
        LD BC,#1820
        EXX
        LD DE,#4000
        LD BC,#0A10
        CALL PUT
        LD BC,#0A11
        CALL PUT
        LD BC,#0A13
        CALL PUT
        LD BC,#0217
        CALL PUT

        IM 1
        LD A,#3F
        POP IY
        POP HL
        EXX
        LD A,#10
        LD BC,#7FFD
        OUT (C),A

EXIT    LD HL,#583F

        LD DE,#20
        LD B,#20
P_L     PUSH BC
        PUSH HL
        PUSH HL
        CALL POLOS
        HALT
        POP HL
        CALL POLOS
        POP HL
COMPOL  DEC L
        POP BC
        DJNZ P_L
        LD HL,#8000
        LD DE,#8001
        LD BC,#3FFF
        LD (HL),L
        JP #33C3


POLOS   LD BC,#840
POL_L   LD A,(HL)
        XOR C
        LD (HL),A
        ADD HL,DE
        DJNZ POL_L
        RET

PUT     LD HL,#C000
        LD A,C

        PUSH BC
        LD BC,#7FFD
        OUT (C),A
        POP BC

PUTM    PUSH BC
        PUSH DE

        EXX
        PUSH BC
        PUSH DE
        PUSH HL
LIQ_ALM PUSH BC
        PUSH DE
        LD A,(HL)
        LD (DE),A
        INC E
        CALL FILL
        POP DE
        LD B,0
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        POP BC
        DJNZ LIQ_ALM
        POP HL
        POP DE
        POP BC
        INC HL
        INC E
UZUZ
        EXX

        LD BC,#C008
PUT01   PUSH BC
        PUSH DE
        XOR A
        OUT (#FE),A
        EI
        HALT

PUT11   PUSH DE

        LD A,(HL)
        LD (DE),A
        RRA
        CCF
        LD A,#FF
        ADC A,0
        INC E
        CALL FILL
        POP DE
        INC HL
        CALL NEXTLS
        DJNZ PUT11

        POP DE
        POP BC
        DEC C
        JR NZ,PUT01

        PUSH HL
COMCTRL LD HL,COMFIL
        LD (HL),#1A
        DEC HL
        DEC HL
        LD (COMCTRL+1),HL

        POP HL
        POP DE
        INC DE
        POP BC
        DEC B
        JP NZ,PUTM

        RET


CONV    LD DE,#C000
        LD A,C
        PUSH BC
        LD BC,#7FFD
        OUT (C),A
        POP BC
CONV3   PUSH BC



        LD BC,#C008
CONV2   PUSH BC
        PUSH HL
        LD A,C
        LD (MASKN),A
        LD (BITCHK),A
CONV1   PUSH BC
        LD A,(IX+0)
MASKN   EQU $-1
        LD C,A
        CPL
        LD B,A
        LD A,(HL)
        AND C
        PUSH AF
        LD C,(IY+0)
BITCHK  EQU $-1
        LD A,(HL)
        OR A
        AND C
        CP C
        JR Z,FF_LIN
        LD B,0
FF_LIN  POP AF
        OR B
        LD (DE),A

        INC HL
        INC DE
        POP BC
        DJNZ CONV1
        POP HL
        POP BC
        DEC C
        JR NZ,CONV2
        LD BC,#C0
        ADD HL,BC
        POP BC
        DJNZ CONV3

        RET

FILL    LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
        LD (DE),A
        INC E
COMFIL  LD (DE),A



        RET

NEXTLS  INC D
        LD A,D
        AND 7
        RET NZ
        LD A,E
        ADD A,#20
        LD E,A
        RET C
        LD A,D
        SUB 8
        LD D,A
        RET

PUT48   LD HL,SCREEN
        LD DE,#4000
        LD BC,#C020


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
        ADD A,#20
        LD E,A
        JR C,AROUND
        LD A,D
        SUB 8
        LD D,A
AROUND  DJNZ LOOP1
        POP DE
        INC DE
        POP BC
        DEC C
        JR NZ,LOOP
JMP2    EI
        HALT
        LD DE,#5800
        LD BC,#300
        LDIR
        JP EXIT

SCREEN  INCBIN "PICTURE1"
ENDCOD
