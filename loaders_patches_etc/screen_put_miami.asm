; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #8000

BORDER  EQU 5


        DI
        EXX
        PUSH HL
        EXX
        LD BC,#7FFD
        LD HL,#C010
        LD E,#17
        OUT (C),L
        LD (HL),L
        OUT (C),E
        LD (HL),E
        OUT (C),L
        LD A,(HL)
        CP E
        JP Z,MOD48
        LD A,#17
        OUT (C),A
        LD HL,#AE00
        LD DE,#AE01
        LD BC,#100
        LD A,H
        LD I,A
        INC A
        LD (HL),A
        LDIR
        IM 2
        LD A,#C9
        LD (#AFAF),A
        LD HL,CLCL
        LD (#AFB0),HL
        LD H,C
        LD L,H

        EI
        HALT
        LD A,#C3
        LD (#AFAF),A
        EI
L_LOOP  INC HL
        LD B,15
L_PAUS  DJNZ L_PAUS
        NOP
        NOP
        JP L_LOOP

CLCL    POP DE
        LD A,H
        CP 1
        JP C,MOD48
        LD A,L
        CP #3F
        JP C,MOD48




        LD A,#C9
        LD (#AFAF),A
        LD HL,#D800
        LD (JMP2+1),HL
        XOR A
        LD (LOOP1+1),A
        CALL PUTSCR
        LD HL,#AC00
        PUSH HL
        LD DE,#AC01
        LD (HL),#10
        LD BC,320
        LDIR
        EXX
        LD BC,#7FFD
        EXX

        LD BC,160
        POP HL
        LD DE,#AC00+319

BMLP    EI
        HALT
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL

                        ;10
BORD    LD A,#18+BORDER ;7
        LD (HL),A       ;6
        INC HL          ;6
        INC HL          ;6
        LD (DE),A       ;6
        DEC DE          ;6
        DEC DE          ;6
        EXX             ;4

        LD HL,#AC00     ;10
        LD DE,318       ;10

BLP1    LD A,(HL)       ;7
        OUT (C),A       ;12
        AND 7           ;7
        OUT (#FE),A     ;11
        INC HL          ;6
        LD A,(#7E7E)    ;13
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)    ;TT=104
        LD A,(HL)
        LD A,(HL)       ;6
        LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        NOP             ;4

        DEC DE          ;6
        LD A,D          ;4
        OR E            ;4
        JP NZ,BLP1      ;10
        EXX
        DEC BC
        LD A,B
        OR C
        JP NZ,BMLP
        LD A,(BORD+1)
        AND 7
        OUT (#FE),A
        LD BC,#7FFD
        PUSH BC
        LD A,#1F
        OUT (C),A
        LD HL,#C000
        LD DE,#4000
        LD BC,#1B00
        LDIR
        POP BC
        LD A,#10
        OUT (C),A
        JR EXIT

MOD48   IM 1
        EI
        HALT
        LD HL,#5800
        LD DE,#5801
        LD A,1+8
        LD (HL),A
        LD BC,#2FF
        OUT (#FE),A
        LDIR
        CALL PUTSCR

EXIT    EXX
        POP HL
        EXX
        IM 1
        LD A,#3B
        LD I,A
        EI
        RET



PUTSCR  LD DE,#4000
        LD HL,SCREEN
        LD BC,#C020

LOOP    PUSH BC
        PUSH DE
LOOP1   JR SCR1
        PUSH DE
        PUSH HL
        LD HL,#8000
        ADD HL,DE
        PUSH HL
        POP DE
        POP HL
        LD A,(HL)
        LD (DE),A
        POP DE
        JR SCR2
SCR1    LD A,(HL)
        LD (DE),A
SCR2    INC HL
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
        EI
        HALT
JMP2    LD DE,#5800
        LD BC,#300
        LDIR
        RET

SCREEN INCBIN "PICTURE"
ENDFIL
