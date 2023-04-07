; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #C000
        JP INSTAL
        JP LOAD

SAVE    DI
        LD (STEK+1),SP
        LD SP,#57FF
        LD A,I
        LD (REG_I+1),A
        LD (REG_IY+2),IY
        EXX
        LD (REG_HL+1),HL
        LD HL,#2758
        EXX
        LD IY,#5C3A
        LD A,#3F
        LD I,A
        IM 1

        CALL SV_SPAM
        CALL RS_VAR

        LD (STEK2+1),SP
        LD SP,#61A0

        CALL OPNSTM
        CALL LEV2SCR
S_ABRT  CALL PRNTME
        CALL IFNAGA
        PUSH HL
        CALL PRNTSF
        POP HL
        CALL SEARCHF
        JR NZ,OVERWR
        CALL PRNTSVF
        LD HL,#4800
        LD DE,#BB8
        LD C,#0B
        CALL DOS
        CALL Z,DSKERR
        JR Z,S_ABRT




        JP EXIT
OVERWR  LD C,8
        CALL DOS
        CALL Z,DSKERR
        JR Z,S_ABRT
        CALL PRNTOW
        LD DE,(#5CEB)
        LD BC,#0C06
        LD HL,#4800
        CALL DOS


        JP EXIT

LOAD    DI
        LD (STEK+1),SP
        LD SP,#57FF
        LD A,I
        LD (REG_I+1),A
        LD (REG_IY+2),IY
        EXX
        LD (REG_HL+1),HL
        LD HL,#2758
        EXX
        LD IY,#5C3A
        LD A,#3F
        LD I,A
        IM 1
        CALL SV_SPAM
        CALL RS_VAR

        LD (STEK2+1),SP
        LD SP,#61A0

        CALL OPNSTM
L_ABRT  CALL PRNTME
        CALL IFNAGA
        PUSH HL
        CALL PRNTSF
        POP HL
        CALL SEARCHF
        CALL Z,DSKERR
        JR Z,L_ABRT
        LD C,8
        CALL DOS
        CALL Z,DSKERR
        JR Z,L_ABRT
        CALL PRNTLF
        LD HL,#4800
        LD DE,(#5CEB)
        LD BC,#0C05
        CALL DOS
        CALL Z,DSKERR
        JR Z,L_ABRT
        CALL SCR2LEV

EXIT    CALL FADE0
STEK2   LD SP,#3131
        CALL SV_SPAM

REG_HL  LD HL,#2121
REG_IY  LD IY,#2121
REG_I   LD A,#3E
        DI
        LD I,A
STEK    LD SP,#3131
        IM 2
        EI
        RET

DOS     EX AF,AF'
DOS1    PUSH BC
        PUSH DE
        PUSH HL
        XOR A
        OUT (#FE),A
        EX AF,AF'
        CALL LL_3D13
        POP HL
        POP DE
        POP BC
        EX AF,AF'
        LD A,(23823)
        CP #14
        RET Z
        CP 6
        RET Z
        OR A
        JR NZ,DOS1
        XOR A
        INC A
        RET

SEARCHF LD DE,#5CDD
        LD BC,8
        LDIR
        LD A,"l"    ;EXT OF FILE!!!
        LD (DE),A
        LD A,9
        LD (23814),A
        LD C,#0A
        CALL LL_3D13
        LD A,C
        CP #FF
        RET












IFNAGA  CALL IF_CSL
        CALL INPUTF
        CP 7
        JR Z,EXIT
        LD A,(FNAME+1)
        CP #3A
        JR Z,WCHDRV
        LD HL,FNAME
        JR WOCHD
WCHDRV  CALL CH_DRV
        JR Z,IFNAGA
        LD HL,FNAME+2
WOCHD   RET


CH_DRV  LD A,(FNAME)
        OR #20
        SUB #61
        JR C,ERRDRV
        CP 4
        JR NC,ERRDRV
        LD C,1
;       LD (#5CCD),A
;       LD (#5CF6),A
;       LD (#5D19),A
        CALL LL_3D13
        LD A,(23823)
        OR A
        JR NZ,ERRDRV
        LD A,(FNAME)
        LD (FNAME0),A
        XOR A
        INC A
        RET

DSKERR  LD A,2+16
        OUT (#FE),A
        RET

ERRDRV  CALL DSKERR
        XOR A
        RET
OPNSTM  LD HL,#5800
        LD DE,#5801
        LD BC,#2FF
        LD (HL),L
        LDIR
        LD A,7
        LD (23693),A
        LD A,2
        CALL 5633
        RET
PRNTFN  LD DE,FNAME_M
        LD BC,TXTMEE-FNAME_M
        JR LL_8252
PRNTME  LD DE,TXT_ME
        LD BC,FNAME_M-TXT_ME
        JR LL_8252
IF_CSL  LD DE,IFCTXT
        LD BC,IFCTXTE-IFCTXT
        JR LL_8252
PRNTSF  LD DE,SF_TXT
        LD BC,SF_TXTE-SF_TXT
        JR LL_8252
PRNTOW  LD DE,OW_TXT
        LD BC,OW_TXTE-OW_TXT
        JR LL_8252
PRNTSVF LD DE,SV_TXT
        LD BC,SVTXTE-SV_TXT
        JR LL_8252
PRNTLF  LD DE,LF_TXT
        LD BC,LF_TXTE-LF_TXT
LL_8252 JP 8252

TXT_ME  DB #16,0,0,#10,5
        DB         "   DISK OPTIONS BY ALX/BW/XPJ"
        DB #0D,    "        (FOR 128K ONLY!)"
        DB #10,7
        DB #0D,#0D,"         ENTER FILENAME: ",#0D
FNAME_M DB #16,4,12
FNAME   DB "A:_         "
TXTMEE
FNAME0  DB "A:_         "
IFCTXT  DB #16,7,0,#10,6,"PRESS 'CS+1 TO QUIT    "
IFCTXTE
SF_TXT  DB #16,3,0,"         SEARCHING FILE: "
        DB #16,7,7,"BREAK' TO ABORT    "
SF_TXTE
LF_TXT  DB #16,3,0,"          LOADING FILE:  "
LF_TXTE
OW_TXT  DB #16,3,0,"        OVERWRITING FILE:"
OW_TXTE
SV_TXT  DB #16,3,0,#10,6,"           SAVING FILE:  "
SVTXTE


INPUTF  LD HL,FNAME0
        LD DE,FNAME
        LD BC,12
        LDIR
        CALL PRNTFN
INPUTFN LD A,2
        LD (FN_LEN+1),A
        LD HL,FNAME+2
        LD (SYMADR+1),HL
WAITKEY EI
        RES 5,(IY+1)
WAITKL  BIT 5,(IY+1)
        JR Z,WAITKL
        LD A,(23560)
        CP 7
        RET Z
        CP #0D
        JR Z,ENTERK
        CP 12
        CALL Z,BACKSP
        CP #1F
        JR C,WAITKEY
        CP #7E
        JR NC,WAITKEY
        CALL ENTRSYM
        CALL PRNTFN
        JR WAITKEY
ENTERK  CALL POOK
        LD HL,(SYMADR+1)
        LD (HL),#20
        LD A,(FN_LEN+1)
        CP 3
        JR NC,ENTF
        JR WAITKEY
ENTF    JP PRNTFN
ENTRSYM CALL POOK
        PUSH AF
FN_LEN  LD A,#3E
        CP 10
        JR Z,NO_ES
        INC A
        LD (FN_LEN+1),A
        POP AF
SYMADR  LD HL,#2121
        LD (HL),A
        INC HL
        LD (SYMADR+1),HL
        LD (HL),#5F
        INC HL
        LD (HL),#20
        RET

NO_ES   POP AF
        RET

BACKSP  CALL POOK
        PUSH AF
        LD HL,(SYMADR+1)
        LD A,(FN_LEN+1)
        OR A
        JR Z,NO_BS
        DEC A
        LD (FN_LEN+1),A
        LD (HL),#20
        DEC HL
        LD (SYMADR+1),HL
        LD (HL),#5F
        INC HL
        LD (HL),#20
NO_BS   CALL PRNTFN
        POP AF
        RET

POOK    PUSH AF
        XOR A
        LD C,10
POOK_P  LD B,#10
        DJNZ $
        OUT (#FE),A
        XOR #10
        DEC C
        JR NZ,POOK_P
        POP AF
        RET

INSTAL  DI
        LD HL,(23606)
        INC H
        LD DE,#C500
        PUSH DE
        LD BC,#300
FNT_L   LD A,(HL)
        SRL A
        OR (HL)
        LD (DE),A
        INC HL
        INC DE
        DEC BC
        LD A,B
        OR C
        JR NZ,FNT_L
        POP DE
        DEC D
        LD (23606),DE
        CALL SV_VAR
        RET


LEV2SCR LD HL,#61A8
        LD DE,#4800
        LD BC,#BB8
        JR COMLDIR
SCR2LEV LD HL,#4800
        LD DE,#61A8
        LD BC,#BB8
        JR COMLDIR
RS_SPAM LD HL,#CF00
        JR L_SPAM1
SV_SPAM LD DE,#CF00
        JR S_SPAM1
RS_VAR  LD HL,#D500
L_SPAM1 LD DE,#5C00
        JR L_VAR1
SV_VAR  LD DE,#D500
S_SPAM1 LD HL,#5C00
L_VAR1  LD BC,#61A7-#5C00
COMLDIR LDIR
        RET

FADE0   LD E,8
FADEL0  HALT
        LD HL,#5800
        LD B,0
FADEL1  LD A,(HL)
        OR A
        JR Z,NO_FADE
        DEC (HL)
NO_FADE INC HL
        DJNZ FADEL1
        DEC E
        JR NZ,FADEL0
        RET


        INCLUDE "3D13"
