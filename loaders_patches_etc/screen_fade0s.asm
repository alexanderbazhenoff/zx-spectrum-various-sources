; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

ADDR    EQU #6000 ;START OF CODE
TABL    EQU #FF00

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
        LD (STEK),SP
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
        LD SP,#3131
STEK    EQU $-2
        DEC C
        JR NZ,FAD_LL
        RET
ENDOBJ
        DISPLAY "SCREEN FADE TO 0 SUB-PROG (STEK VER.) (C)ALX"
        DISPLAY "Org_addr=",ADDR
        DISPLAY "Lenght=",ENDOBJ-ADDR
        DISPLAY "Tabl_addr:",TABL,"...",TABL+#100
