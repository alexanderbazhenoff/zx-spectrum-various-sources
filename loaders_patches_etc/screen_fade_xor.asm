; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

ADDR    EQU #8E40 ;START OF CODE
TABL    EQU #8F00

        ORG ADDR
        LD HL,TABL
        LD B,L
FAD_LP  LD D,L
        LD A,D
        AND 1+2+4
        OR A
        JR Z,NODINK
        DEC D
NODINK  LD A,D
        AND 8+16+32
        OR A
        JR Z,NODPAP
        LD A,D
        SUB 8
        LD D,A
NODPAP  LD (HL),D
        INC L
        DJNZ FAD_LP
        EI
        LD C,8
FAD_LL  HALT
        HALT
        HALT
        HALT
        LD SP,#5800
        LD B,#C0
        LD H,TABL/#100
FAD_L1  POP DE
        LD L,E
        LD E,(HL)
        LD L,D
        LD D,(HL)
        PUSH DE
        POP DE
        POP DE
        LD L,E
        LD E,(HL)
        LD L,D
        LD D,(HL)
        PUSH DE
        POP DE
        DJNZ FAD_L1
        LD SP,#5DB0
        DEC C
        JR NZ,FAD_LL
        LD HL,#B000
        PUSH HL
        LD DE,#E100
        LD BC,0-#E100
        LDIR
        POP HL
        LD DE,#B001
        LD BC,#E0FF-#B000
        LD (HL),L
        LDIR
        LD HL,#5DB1
        LD DE,#5DB2
        LD BC,#6401-#5DB1
        XOR A
        LD (HL),A
        LDIR
        LD HL,#FF81
        PUSH HL
        LD HL,#8E40
        LD DE,#8E41
        LD BC,#9040-#8E40
        LD (HL),A
        JP #33C3


ENDOBJ
        DISPLAY "SCREEN FADE TO 0 SUB-PROG (STEK VER.) (C)ALX"
        DISPLAY "Org_addr=",ADDR
        DISPLAY "Lenght=",ENDOBJ-ADDR
        DISPLAY "Tabl_addr:",TABL,"...",TABL+#100
