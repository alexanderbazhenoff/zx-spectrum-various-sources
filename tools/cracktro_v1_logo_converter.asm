; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #6000
        LD HL,30000
        LD DE,#4000
        LD BC,#1B00
        LDIR

        LD HL,#4008
        LD B,8
        LD DE,40000

FUCK    PUSH BC
        PUSH HL
        PUSH HL
        LD BC,#C001
        CALL SCR
        POP HL
        PUSH DE
        LD DE,8
        ADD HL,DE
        POP DE
        PUSH HL
        LD BC,#C001
        CALL SCR
        POP HL
        PUSH DE
        LD DE,8
        ADD HL,DE
        POP DE
        LD BC,#6801
        CALL SCR
        POP HL
        INC HL
        POP BC
        DJNZ FUCK

        LD HL,#5808
        LD BC,#1808
        CALL ATTR
        LD HL,#5810
        LD BC,#1808
        CALL ATTR
        LD HL,#5818
        LD BC,#0D08
        CALL ATTR
        RET

SCR
LOOP    PUSH BC
        PUSH HL
LOOP1   LD A,(HL)
        LD (HL),#FF
        LD (DE),A
        INC DE
        INC H
        LD A,H
        AND 7
        JR NZ,AROUND
        LD A,L
        ADD A,#20
        LD L,A
        JR C,AROUND
        LD A,H
        SUB 8
        LD H,A
AROUND  DJNZ LOOP1
        HALT
        POP HL
        INC HL
        POP BC
        DEC C
        JR NZ,LOOP
        RET

ATTR    PUSH BC
        LD (REG_HL+1),HL
        LD B,0
        LDIR
        PUSH HL
REG_HL  LD HL,0
        LD A,1+4+16+64+128
        LD (HL),A
        POP HL
        PUSH DE
        LD DE,#18
        ADD HL,DE
        HALT
        HALT
        HALT
        HALT
        HALT
        POP DE
        POP BC
        DJNZ ATTR
        RET


