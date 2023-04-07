; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #6000

        DI
        LD HL,#AE00
        LD A,H
        LD I,A
        INC A
        LD B,L
INTR_L  LD (HL),A
        INC HL
        DJNZ INTR_L
        LD (HL),A
        LD H,A
        LD L,A
        LD A,#C9
        LD (HL),A
        IM 2
        EI

        LD DE,SCREEN
        LD HL,#C000+#20
        LD BC,#C020

LOOP    PUSH BC
        PUSH HL
LOOP1   LD A,(DE)
        LD (HL),A
        INC DE
        PUSH BC
        LD BC,#20
        ADD HL,BC
        POP BC
        DJNZ LOOP1
        POP HL
        POP BC
        DEC HL
        DEC C
        JR NZ,LOOP
JMP2    LD HL,ATRIB
        LD DE,#D800
        LD BC,#300
        LDIR

        LD DE,#DAFF
        LD HL,#5B00
        LD BC,#1801
        EXX
        LD DE,#D800
        LD HL,#401F
        LD BC,#C0C0
PUTLOOP EI
        HALT
        DI
        EXX
        DEC C
        JR NZ,NOADD
        PUSH DE
        CALL STEKPSH
        PUSH BC
        PUSH HL
PUTL1   PUSH BC
        CALL STEKOUT
        POP BC
        DJNZ PUTL1
        POP HL
        POP BC
        POP DE
        PUSH BC
        LD BC,#20
        OR A
        SBC HL,BC
        EX DE,HL
        OR A
        SBC HL,BC
        EX DE,HL
        POP BC
        DEC B
        LD C,8
NOADD   EXX
     ;  JR JOPA
        PUSH DE
        CALL STEKPSH
        POP DE
        PUSH BC
        PUSH DE
        PUSH HL
PUTL2   PUSH BC
        PUSH HL
        INC HL
        CALL STEKOUT
        POP HL
        INC H
        LD A,H
        AND 7
        JR NZ,ASDFG
        LD A,L
        ADD A,#20
        LD L,A
        JR C,ASDFG
        LD A,H
        SUB 8
        LD H,A
ASDFG   POP BC
        DJNZ PUTL2
        POP HL
        POP DE
        EX DE,HL
        OR A
        LD C,#20
        SBC HL,BC
        EX DE,HL
        POP BC
JOPA
        DEC B
        DEC C
        JR NZ,PUTLOOP

        DI
        LD A,#3F
        LD I,A
        IM 1
        EI
        RET

STEKOUT LD (STEK+1),SP
        LD SP,HL
        DUP 16
        LD HL,#2121
        PUSH HL
        EDUP
PUTDATA EQU $-2
        LD (REG_HL+1),SP
REG_HL  LD HL,#2121
STEK    LD SP,#3131
        RET

STEKPSH EX DE,HL
        PUSH DE
        PUSH HL
        PUSH BC
        LD DE,PUTDATA
        DUP 15
        LD B,(HL)
        DEC HL
        LD A,(HL)
        DEC HL
        LD (DE),A
        DEC DE
        LD A,B
        LD (DE),A
        DEC DE
        DEC DE
        DEC DE
        EDUP

        LD B,(HL)
        DEC HL
        LD A,(HL)
        DEC HL
        LD (DE),A
        DEC DE
        LD A,B
        LD (DE),A
        DEC DE
        DEC DE
        DEC DE

        POP BC
        POP HL
        POP DE
        EX DE,HL
        RET

SCREEN  INCBIN "PICTURE"
ATRIB   EQU $-#300