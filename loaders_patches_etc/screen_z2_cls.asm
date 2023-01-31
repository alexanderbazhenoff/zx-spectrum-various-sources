; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #9C40


BORDER  EQU 5
INTTABL EQU #AE00



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
        LD A,#18
        OUT (C),A
        LD HL,#4000
        LD DE,#4001
        LD BC,#1AFF
        LD (HL),L
        LDIR


        LD HL,INTTABL
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
        LD BC,#01FE
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
        LD BC,#9EFE
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
        INC A
        LD (PAUPA1),A
        LD A,(PAUPA2)
        DEC A
        LD (PAUPA2),A
        LD A,158
PAUPA3  EQU $-1
        DEC A
        LD (PAUPA3),A
        OR A
        JP NZ,ML
        OUT (C),H
        LD BC,#7FFD
        LD A,#10
        OUT (C),A


        IM 1
MODE48  EI
        RET


