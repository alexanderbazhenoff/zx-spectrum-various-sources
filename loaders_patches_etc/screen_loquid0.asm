; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG 40000
        DI
        LD HL,#BDBD
        LD (#BCFF),HL
        LD (HL),#C9
        DEC L
        LD A,L
        LD I,A
        IM 2

        PUSH IY
        LD HL,#BF01
        LD BC,#8FF
MASKI_L LD (HL),C
        OR A
        SLA C
        INC L
        DJNZ MASKI_L
        LD HL,#BE08
        LD A,#80
BITMSIL LD (HL),A
        RRCA
        DEC L
        DJNZ BITMSIL

        LD IX,#BF00
        LD IY,#BE00
        LD HL,SCREEN
        LD BC,#0A10
        CALL CONV
        LD BC,#0A11
        CALL CONV
        LD BC,#0A13
        CALL CONV
        LD BC,#0217
        CALL CONV

        EI
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
        EI
        RET

PUT     LD HL,#C000
        LD A,C
        PUSH BC
        LD BC,#7FFD
        OUT (C),A
        POP BC

PUTM    PUSH BC
        PUSH DE
        LD BC,#C008
PUT01   PUSH BC
        PUSH DE
        XOR A
        OUT (#FE),A
        EI
        HALT
        LD A,7
        OUT (#FE),A

PUT11   PUSH BC
        PUSH HL
        PUSH DE
        LD A,(HL)
        LD (DE),A
        RRA
        CCF
        LD A,#FF
        ADC A,0
        INC E
        CALL FILL
        POP DE
        POP HL
        POP BC
        INC HL
        CALL NEXTLS
        DJNZ PUT11
        POP DE
        POP BC
        DEC C
        JR NZ,PUT01
        PUSH HL
COMCTRL LD HL,COMFIL
        LD (HL),#C9
        DEC HL
        DEC HL
        LD (COMCTRL+1),HL

        POP HL
        POP DE
        INC DE
        POP BC
        DJNZ PUTM
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

SCREEN  INCBIN "PICTURE"

