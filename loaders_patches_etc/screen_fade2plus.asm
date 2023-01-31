; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG 40000
ATRBUF  EQU #C000
BORDER  EQU 7

;FADEP  LD DE,ATRBUF
;       LD HL,#5800
;       LD BC,#300
;       PUSH DE
;       PUSH HL
;       LDIR
;       POP DE
;       POP HL
;       LD B,8
;FADEPL PUSH BC
;       PUSH DE
;       PUSH HL
;       PUSH HL
;       EI
;       DUP 4
;       HALT
;       EDUP
;       LD B,3
;       LDIR
;       POP HL
;       CALL FADE_
;       POP HL
;       POP DE
;       POP BC
;       DJNZ FADEPL
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
        LD DE,ATRBUF+#1D00
        LD B,#3
        PUSH HL
        PUSH BC
        LDIR
        POP BC
        POP HL
        LD D,'ATRBUF+#1
        PUSH DE
        LDIR
        POP HL
        DEC H
        LD B,6
        LD D,'ATRBUF+#18
SFAD_L  PUSH BC
        PUSH HL
        PUSH HL
        PUSH DE
        LD B,#4
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
        LD H,'ATRBUF+#4
OUT_L   PUSH BC
        LD D,#58
        LD B,3
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

FADE_   LD B,#3
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
ZUZU    DISPLAY "lenght: ",ZUZU-40000
