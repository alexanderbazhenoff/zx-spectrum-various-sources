; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #9C40

;       SAVE "FILENAME" CODE 40000,7327

BORDER  EQU 5




        DI
        LD BC,#7FFD
        LD HL,#FFFF
        LD DE,#1710
        OUT (C),E
        LD (HL),E
        OUT (C),D
        LD (HL),D
        OUT (C),E
        LD A,D
        CP (HL)
        JP Z,MODE48
        LD HL,#D800
        LD (JMP2+1),HL
        LD HL,SCREEN
        OUT (C),D
        LD DE,#C000
        CALL PR_SCR
        LD HL,#AE00
        LD A,H
        LD I,A
        INC A
        LD B,L
INTI_L  LD (HL),A
        INC HL
        DJNZ INTI_L
        LD (HL),A
        LD H,A
        LD L,A
        LD (HL),#C9
        IM 2

ML      EI
        HALT
        DI
        DUP 5
        LD (0),BC
        EDUP
        DUP 4
        NOP
        EDUP

        LD BC,#7FFD
        LD DE,#1810
        LD HL,BORDER
        OUT (C),E
        LD BC,#9EFE
PAUPA1  EQU $-1
        OUT (C),H

PAUS1   DUP 10
        LD (0),BC
        EDUP
        NOP
        LD E,#10
        DJNZ PAUS1

        LD BC,#7FFD
        OUT (C),D
        LD BC,#1FE
PAUPA2  EQU $-1
        OUT (C),L
        DUP 8
        LD (0),BC
        EDUP
        INC A
        DEC A

PAUS2   DUP 21
        LD (0),BC
        EDUP
        DEFB 0,0
        LD E,#10
        DJNZ PAUS2

        LD R,A
        LD E,#10
        NOP
        LD BC,#7FFD
        OUT (C),E
        LD C,#FE
        OUT (C),H

        LD A,(PAUPA1)
        DEC A
        LD (PAUPA1),A
        LD A,(PAUPA2)
        INC A
        LD (PAUPA2),A
        LD A,158
PAUPA3  EQU $-1
        DEC A
        LD (PAUPA3),A
        OR A
        JP NZ,ML
        OUT (C),L
        LD BC,#7FFD
        LD A,#17+8
        OUT (C),A
        PUSH BC
        LD HL,#C000
        LD DE,#4000
        LD BC,#1B00
        LDIR
        POP BC
        LD A,#10
        OUT (C),A


        IM 1
        EI
        RET




MODE48  LD HL,SCREEN
        PUSH HL
START   HALT
        LD HL,#5800
        LD DE,#5801
        LD A,BORDER*8+BORDER
        LD (HL),A
        LD BC,#2FF
        OUT (#FE),A
        LDIR

        POP HL
        LD DE,#4000
PR_SCR  LD BC,#C020

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
JMP2    LD DE,#5800
        LD BC,#300
        LDIR
        RET

SCREEN  INCBIN "PICTURE"
ENDOBJ
