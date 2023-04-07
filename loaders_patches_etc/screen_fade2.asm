; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG 40000
ATRBUF  EQU #C000
SRCBORD EQU 7
BORDER  EQU 5

        LD HL,#5800
        LD BC,#300
        LD D,B
        LD E,C
CHA_L   LD A,(HL)
        OR A
        JR NZ,NO0ATR
        DEC DE
NO0ATR  DEC BC
        INC HL
        LD A,B
        OR C
        JR NZ,CHA_L
        LD A,D
        OR E
        JR Z,NOFADE0

FADEP   LD DE,ATRBUF
        LD HL,#5800
        LD BC,#300
        PUSH DE
        PUSH HL
        LDIR
        POP DE
        POP HL
        LD A,SRCBORD
        LD B,8
FADEPL  PUSH BC
        PUSH AF
        PUSH DE
        PUSH HL
        PUSH HL
        EI
        DUP 4
        HALT
        EDUP
        OUT (#FE),A
        LD B,3
        LDIR
        POP HL
        CALL FADE_
        POP HL
        POP DE
        POP AF
        OR A
        JR Z,NO_FB
        DEC A
NO_FB
        POP BC
        DJNZ FADEPL
NOFADE0 LD HL,SCREEN
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
        LD A,BORDER
        LD (ATRBUF+#1C00),A
        LD (ATRBUF),A
        LD HL,SCREEN+#1800              ;?
        LD DE,ATRBUF+#1D00
        LD BC,#300
        PUSH HL
        PUSH BC
        LDIR
        POP BC
        POP HL
        LD DE,ATRBUF+#100
        PUSH DE
        LDIR
        POP HL
        DEC H
        LD B,6
        LD DE,ATRBUF+#1800
SFAD_L  PUSH BC
        PUSH HL
        PUSH HL
        PUSH DE
        LD BC,#400
        CALL FAD_LP
        POP DE
        POP HL
        LD B,4
        LDIR
        LD A,D
        SUB 8
        LD D,A
        POP HL
        POP BC
        DJNZ SFAD_L

        LD B,7
        LD HL,ATRBUF+#400
OUT_L   PUSH BC
        LD DE,#5800
        LD BC,#300
        EI
        DUP 4
        HALT
        EDUP
        LD A,(HL)
        OUT (#FE),A
        INC H
        LDIR
        POP BC
        DJNZ OUT_L

        RET

FADE_   LD BC,#300
FAD_LP  LD D,(HL)
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
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,FAD_LP
        RET

SCREEN  INCBIN "PICTURE"
