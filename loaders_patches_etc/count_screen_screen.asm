; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #9C40

        DI
        LD HL,#2758
        EXX
        EI
        LD HL,SCREEN
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
JMP2    LD HL,SCREEN+#1800+384-32+11
        LD DE,#5800+384-32+11
        LD BC,#020A
        LD A,12
ATR_L   HALT
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
ATR_L1  PUSH BC
        LD B,0
        LDIR
D_BC    LD C,22
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        POP BC
        DJNZ ATR_L1
        LD A,(D_BC+1)
        DEC A
        DEC A
        LD (D_BC+1),A
        POP HL
        POP DE
        LD BC,#21
        OR A
        SBC HL,BC
        EX DE,HL
        SBC HL,BC
        EX DE,HL
        POP BC
        INC B
        INC B
        INC C
        INC C
        POP AF
        DEC A
        JR NZ,ATR_L
        HALT
        LD A,2
        OUT (#FE),A
        RET

SCREEN  INCBIN "PICTURE"
ENDSCR  DISPLAY ENDSCR-#9C40
