; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6000

BORDER  EQU 0




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
        OUT (C),D
        LD HL,SCREEN
        LD DE,#C000
        CALL PR_SCR
        LD DE,#D800
        LD BC,#300
        LDIR
        LD HL,#AE00
        LD A,H
        LD I,A
        INC A
        LD B,L
INTI_L1 LD (HL),A
        INC HL
        DJNZ INTI_L1
        LD (HL),A
        LD H,A
        LD L,A
        LD (HL),#C9
        IM 2

ML1     EI
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
        LD BC,#B0FE
PAUPA11 EQU $-1
        OUT (C),H

PAUS11  DUP 10
        LD (0),BC
        EDUP
        NOP
        LD E,#10
        DJNZ PAUS11

        LD BC,#7FFD
        OUT (C),D
        LD BC,#1FE
PAUPA21 EQU $-1
        OUT (C),L
        DUP 8
        LD (0),BC
        EDUP
        INC A
        DEC A

PAUS21  DUP 21
        LD (0),BC
        EDUP
        DEFB 0,0
        LD E,#10
        DJNZ PAUS21

        LD R,A
        LD E,#10
        NOP
        LD BC,#7FFD
        OUT (C),E
        LD C,#FE
        OUT (C),H

        LD A,(PAUPA11)
        DEC A
        LD (PAUPA11),A
        LD A,(PAUPA21)
        INC A
        LD (PAUPA21),A
        LD A,116
PAUPA31 EQU $-1
        DEC A
        LD (PAUPA31),A
        OR A
        JP NZ,ML1
        OUT (C),L
        LD BC,#7FFD
        LD A,#17+8
        OUT (C),A
        LD HL,SCREEN2
        LD DE,#4000
        CALL PR_SCR
        LD DE,#5800
        LD BC,#300

        CALL WAITSPC

        LDIR
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
        LD BC,#3CFE
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
        LD BC,#74FE
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
        LD A,116
PAUPA3  EQU $-1
        DEC A
        LD (PAUPA3),A
        OR A
        JP NZ,ML

        IM 1
        EI
        RET

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
        RET

WAITSPC LD A,#7F
        IN A,(#FE)
        RRA
        JR C,WAITSPC
        RET
MODE48  LD HL,SCREEN
        CALL MOVE
        CALL WAITSPC
        LD HL,SCREEN2
        CALL MOVE
        EI
        RET
MOVE    LD DE,#A500
        LD BC,#1B00
        LDIR
        JP 40777

SCREEN  INCBIN "PICTURE"
SCREEN2 INCBIN "PICTURE1"
        ORG 40777
        INCBIN "SCR_FADE"
        ORG #A000
        DS #500,0
        ORG #A500
        DEFS #1B00,0
ENDCOD
        ORG #6000

