; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE


        ORG #6000

ATRIB2  EQU #42
TABL    EQU 1

        LD HL,#2758
        EXX
        LD HL,#5AE0
        LD BC,#1847
FILATR  LD (HL),C
        INC HL
        DJNZ FILATR
        LD BC,#08*#100+ATRIB2
FILATR2 LD (HL),C
        INC HL
        DJNZ FILATR2
        RES 5,(IY+1)
        LD (IY-50),B
        CALL CRED_OUT
        LD HL,GFX2
        LD DE,#AFA0
        LD BC,#0060
        LDIR
        LD A,64
        EX DE,HL
        DEC HL
        LD DE,#B05F
CH_CNV1 EXA
        LD BC,#60
        PUSH HL
        PUSH DE
        XOR A
CH_CNV2 RL (HL)
        LDD
        JP PE,CH_CNV2
        POP DE
        INC D
        POP HL
        EXA
        DEC A
        JR NZ,CH_CNV1
        CALL CH_OUT
        LD B,100
PAUS_CC EI
        HALT
        BIT 5,(IY+1)
        JR Z,NO_CCKEY
        LD A,(IY-50)
        OR #20
        CP "c"
        JR Z,PR_CCKEY
NO_CCKEY
        DJNZ PAUS_CC
PR_CCKEY

        LD A,#2B
        LD (COM_HL),A
        LD HL,EPOS_TABL-1
        CALL CH_OUT1

CRED_DEL
        LD HL,#2405
        LD (OG_CH),HL
        LD B,7
        CALL CRED_
        RET



CH_OUT  LD HL,POS_TABL
CH_OUT1 HALT
        LD A,(HL)
        CP #FF
        RET Z
        PUSH HL
        ADD A,#B0
        LD H,A
        LD L,0
        LD DE,#52F8
        LD A,6
CH_OUT2 PUSH HL
        PUSH DE
        DUP 8
        LDI
        EDUP
        POP DE
        POP HL
        INC D
        LD BC,#0010
        ADD HL,BC
        DEC A
        JR NZ,CH_OUT2
        POP HL
COM_HL  INC HL
        JR CH_OUT1


CRED_OUT
        LD B,1
CRED_
        LD A,7
        LD HL,#57E0
PUT_ADR EQU $-2
        LD DE,GFX1
        LD C,#18
OGFXL_1 EI
        HALT
        HALT
        EXA
        PUSH DE
        PUSH BC
        PUSH HL
OGFXL_2 PUSH BC
        PUSH HL
        LD (HL),0
        INC H
        DEC B
        JR Z,OG_NO
        LD C,B
OGFXL_3 LD A,(DE)
        LD (HL),A
        INC DE
        INC H
        DJNZ OGFXL_3
        LD A,6
        SUB C
        JR Z,OG_NO
        LD B,A
OGFXL_4 INC DE
        DJNZ OGFXL_4
OG_NO   POP HL
        INC L
        POP BC
        DEC C
        JR NZ,OGFXL_2
        POP HL
        POP BC
        POP DE
OG_CH   DEC H
        INC B
        EXA
        DEC A
        JR NZ,OGFXL_1
        INC H
        LD (PUT_ADR),HL
        RET

GFX1    INCBIN "KR4_GFX1"
GFX2    INCBIN "KR4_GFX2"
        DB #FF
POS_TABL
        IF0 TABL
        INCBIN "kr4_tbl"
        ELSE
        INCBIN "kr4_tbl2"
        ENDIF
EPOS_TABL
        DB #FF


END_OBJ DISPLAY END_OBJ
