; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

ROUTADR EQU 40000
ATRBUF  EQU #C000
SPEED   EQU 6

        ORG ROUTADR

SCRFADE DI
        LD HL,#2758
        EXX
        EI
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
        ;LD HL,#5800
        LD H,#58
        ;LD BC,#300
        LD B,3
        PUSH DE
        PUSH HL
        LDIR
        POP DE
        POP HL
        LD B,8
FADEPL  PUSH BC
        PUSH AF
        PUSH DE
        PUSH HL
        PUSH HL
        DUP SPEED
        HALT
        EDUP
        LD B,3
        LDIR
        POP HL
        CALL FADE_
        POP HL
        POP DE
        POP AF
        POP BC
        DJNZ FADEPL
NOFADE0 LD HL,SCREEN
        ;LD DE,#4000
        LD D,#40
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
        LD HL,SCREEN+#1800              ;?
        LD DE,ATRBUF+#1500
        ;LD BC,#300
        LD B,3
        PUSH HL
        PUSH BC
        LDIR
        POP BC
        POP HL
        LD DE,ATRBUF
        PUSH DE
        LDIR
        POP HL
        LD B,6
        LD DE,ATRBUF+#1200
SFAD_L  PUSH BC
        PUSH HL
        PUSH HL
        PUSH DE
        CALL FADE_
        POP DE
        POP HL
        LD B,3
        LDIR
        LD A,D
        SUB 6
        LD D,A
        POP HL
        POP BC
        DJNZ SFAD_L

        LD B,7
        LD HL,ATRBUF+#300
OUT_L   PUSH BC
        LD DE,#5800
        ;LD BC,#300
        LD B,3
        DUP SPEED
        HALT
        EDUP
        LDIR
        POP BC
        DJNZ OUT_L

        RET

FADE_   ;LD BC,#300
        LD B,3
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
ENDOBJ  DISPLAY "total lenght: ",ENDOBJ-ROUTADR
