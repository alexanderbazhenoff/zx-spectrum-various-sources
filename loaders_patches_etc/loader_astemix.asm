; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #7000
        DISP 23883
        DI
        LD SP,24999
        XOR A
        LD (23624),A
        LD (23693),A
        OUT (#FE),A
        CALL 3435
        LD HL,(23606)

        LD DE,#8100
        PUSH DE
        LD B,#80
CH_L    PUSH BC

        LD B,4


CH_L1   LD A,(HL)
        RRA
        OR (HL)
        LD (DE),A
        INC HL
        INC DE
        DJNZ CH_L1


        LD B,4

CH_L2   LD A,(HL)
        RLA
        OR (HL)
        LD (DE),A
        INC HL
        INC DE
        DJNZ CH_L2

        POP BC
        DJNZ CH_L
        DEC D
        POP DE
        LD (23606),DE
        EI
        XOR A
        CALL 5633
        LD DE,TEXT
        LD BC,ENDTEXT-TEXT
        CALL 8252
        JP MTK

TEXT    DEFB "    *ASTEMEX IN CARICAMENTO*    "
        DEFB "RESTORED AFTER FUCKING SNAPSHOT,"
        DEFB "DISKED,PACKED,CHEATED BY ALX/BW!"
        DEFB "IF U WANNA CHEAT U MAY PRESS 'C'"
        DEFB "  WHILE THE GAME DECRUNCHING!"
ENDTEXT


MTK     LD HL,#5B00-#A0
        LD DE,#5B00-#9F
        LD BC,#20
        LD (HL),6+#40
        LDIR
        LD C,#40
        LD (HL),7
        LDIR
        LD C,#40
        LD (HL),#7+#40
        LDIR

        LD HL,#3C00
        LD (23606),HL

        LD B,#51
PAUSE   HALT
        DJNZ PAUSE

        LD HL,25000
        LD DE,(#5CF4)
        LD BC,#5C05
LOAD    PUSH BC
        PUSH DE
        PUSH HL
        CALL LL_3D13
        POP HL
        POP DE
        POP BC
        LD A,(23823)
        OR A
        JR NZ,LOAD

        LD B,8
FADE0   HALT
        HALT
        LD HL,#5A00
FADE    LD A,(HL)
        AND 7+8+16+32
        OR A
        JR Z,NO_FADE
        DEC A
NO_FADE LD (HL),A
        INC L
        JR NZ,FADE
        DJNZ FADE0

        JP 25000


LL_3D13 LD (REG_A+1),A
        PUSH HL
        LD HL,(23613)
        LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        EX AF,AF'
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23823),A
        LD (23824),A
        EXA
        LD (SP2),SP
REG_A   LD A,#C3
        JP #3D13
D_ERR   LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),A
        LD A,#C9
        LD (#5CC2),A
        RET
DRIA    EX (SP),HL
        PUSH AF
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR Z,NO_ERR
NO_ERR  POP AF
        EX (SP),HL
        RET
RIA     POP HL
        POP HL
        POP HL
        XOR A
        LD (23560),A
        LD A,2
        OUT (#FE),A
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F

