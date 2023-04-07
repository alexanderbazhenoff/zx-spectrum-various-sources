; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #9000
        DI
        LD HL,LOADER
        LD DE,#5D3B
        LD BC,ENDLOAD-LOADER
        LDIR

        LD HL,FONT
        PUSH HL
        LD DE,#8000
        LD BC,#200
        LDIR

        XOR A
        LD (23624),A
        LD (23693),A
        OUT (#FE),A
        CALL 3435
        LD DE,(23606)
        POP HL
        DEC H
        PUSH DE
        LD (23606),HL

        EI
        XOR A
        LD (23659),A
        LD A,2
        CALL 5633

        LD DE,TXT
        LD BC,ENDTEXT-TXT
        CALL 8252
        LD A,2
        LD (23659),A
        HALT
        LD DE,ATRTEXT
        LD HL,#5800
ATRTX_L LD A,(DE)
        OR A
        JR Z,ATREND
        LD B,A
        INC DE
        LD A,(DE)
        INC DE
ATRFT_L LD (HL),A
        INC HL
        DJNZ ATRFT_L
        JR ATRTX_L
ATREND

        CALL FLASH1
ATREND1 LD HL,#5800
        LD DE,#FD00
        LD BC,#300
        LDIR

        HALT
        LD A,7
        OUT (#FE),A
        LD A,#3F
        CALL FILATR2
        CALL PRNTGR
        HALT
        XOR A
        OUT (#FE),A
        LD HL,#FD00
        LD DE,#5800
        LD BC,#300
        LDIR

        LD A,R
        AND 1+2
        INC A
        INC A
        INC A
        OR #40
        CALL FILLATR
        XOR A
        LD (#5C08),A


        LD B,102
PLOOP   HALT
        PUSH BC
        LD A,(#5C08)
        CP "1"
        CALL Z,CHEAT1
        CP "2"
        JR Z,EXIT
        XOR A
        LD (#5C08),A

        POP BC
        DJNZ PLOOP
        JP ATREND1

EXIT    POP BC
        POP HL
        LD (23606),HL
        CALL FLASH1
        LD A,(CHEATP1)
        OR A
        JR Z,NOC
        XOR A
        LD (USTAM),A
NOC
        JP #5D3B

PRNTGR  HALT
PR_AGA  LD DE,GRHEAD
        LD BC,9
        CALL 8252
REG_HL  LD HL,GRTEXT
PRNTG_L LD A,(HL)
        OR A
        JR Z,ENDPG
        CP #FF
        JR Z,GR_AGA
        RST 16
        INC HL
        JR PRNTG_L
GR_AGA  LD HL,GRTEXT
        LD (REG_HL+1),HL
        JR PR_AGA
ENDPG   INC HL
        LD (REG_HL+1),HL
        RET

FLASH1  LD DE,#0778
        LD B,8
FLSH1_L PUSH BC
        HALT
        CALL ATRFIL
        HALT
        CALL ATRFIL
        POP BC
        DJNZ FLSH1_L
        RET

FILLATR LD HL,32*16+#5800
FILLA   LD B,#20
FILLA_L LD (HL),A
        INC HL
        DJNZ FILLA_L
        RET
FILATR2 LD HL,#5800
        LD C,24
FILATL2 CALL FILLA
        DEC C
        JR NZ,FILATL2
        RET

ATRFIL  LD A,D
        OUT (#FE),A
        LD HL,#5800
        LD BC,#300
ATRFL_L LD A,(HL)
        XOR E
        LD (HL),A
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,ATRFL_L
        LD A,D
        XOR 7
        LD D,A
        RET

CHEAT1  LD DE,CHETPR1
        LD BC,9
        CALL 8252
        LD HL,CHEATP1
        CALL TOGGLE
        RET

TOGGLE  LD A,(HL)
        CPL
        LD (HL),A
        OR A
        JR Z,CH_NOP
        LD A,"Y"
        RST 16
        LD A,"E"
        RST 16
        RET

CH_NOP  LD A,"N"
        RST 16
        LD A,"O"
        RST 16
        RET

CHEATP1 DEFB #00

CHETPR1 DEFB #16,20,29,#10,7,#11,0,#13,1

TXT
        DEFB "$%$%%$-$%-YO BROTHERS!$%$-%$%%$$"
        DEFB #0D,#0D
        DEFB "     DIGITAL EVOLVERS FROM",#0D
        DEFB "+B+R+A+I+N+W+A+V+E+ OF X-PROJECT"
        DEFB #0D,#0D
        DEFB "SHOCKS U 2DAY WITH THE GAME FROM"
        DEFB "ARCADIA SYST./MELBOURNE HOUSE'86"
        DEFB #0D,#0D
        DEFB "   +-R-O-A-D-+   +-W-A-R-S-+"
        DEFB #0D,#0D
        DEFB "STUFF:%$%-$$-%$-%$$%%$-$%%%$%-%$"
        DEFB #0D,#0D
        DEFB "MINI-CRACKTRO CODED,GAME CRACKED"
        DEFB "TRAINED,PACKED,DISKED.....ALX/BW"
        DEFB #0D,#0D
        DEFB "GREETZ:$%$%-$%-%$%%$-%$$%%%$-%$%"
        DEFB  #0D,#0D,#0D
        DEFB "$%$$BRAINWAVE TRAINER (+#01)%$%%"
        DEFB #0D,#0D
        DEFB "1.UNLIMIT LIVES..............NOP"
        DEFB "2.START GAME.................YEP"
        DEFB #0D,#0D
        DEFB "$%%$%$%$$-$%%-$CRACK'EM 2 DEATH!"
ENDTEXT


GRTEXT  DEFB "X-PROJECT, ANTARES, XTM ",0
        DEFB "PLACEBO, STUDIO STALL   ",0
        DEFB "SERZH SOFT, MAD CAT, CPU",0
        DEFB "RAZZLERS, REAL MASTERS  ",0
        DEFB "DELIRIUM TREMENS, H-PROG",0
        DEFB "FREE ART, RAWW ARSE, 3SC",0
        DEFB "CONCERN CHAOS, PHANTASY ",0
        DEFB "LFG, MYHEM, JAM, CDL, 4D",0
        DEFB "ALIEN FACTORY, REAL SOFT",0
        DEFB "COPPER FEET, ALONE CODER",0
        DEFB "IMAGE, SERGUN, DANZIL...",0
        DEFB "AND 2 ALL WHO KEEPS DA  ",0
        DEFB "SPECCY SCENE ALIVE!!!   ",0
        DEFB "                        ",0,#FF


GRHEAD  DEFB #16,16,7,#10,7,#11,7,#13,0

ATRTEXT DEFB 10,#43,#2,#45,10,#47,43,#43
        DEFB 12,#44,#9,#46,10,#44
        DEFB 20,#47,#3,#44,#9,#46
        DEFB 39,#45,#2,#44,#5,#46,#5,#44,#4,#45,#5,#47,#4,#44
        DEFB 32,#46
        DEFB 96,#47
        DEFB #6,#45,26,#43
        DEFB 32,#45       ;STUFF LIST
        DEFB 13,#44,#7,#47,#5,#46,#7,#47
        DEFB #8,#46,#7,#45,#6,#44,#5,#45,#6,#47
        DEFB 39,#45,93,#43
        DEFB 24,#45,#4,#43
        DEFB 32,#47
        DEFB #2,#47,27,#46,#3,#47
        DEFB #2,#47,27,#46,#3,#47
        DEFB 32,#47
        DEFB 15,#43,17,#47

        DEFB 0
FONT    INCBIN "CRKsquar"

LOADER
        DISP #5D3B
        LD SP,24499
        XOR A
        OUT (#FE),A
CLS     DEC HL
        LD (HL),A
        OR (HL)
        JR Z,CLS
        LD HL,#6000
        LD B,#18
        CALL LOAD
        LD HL,24500
        LD B,#51
        CALL LOAD
;       EI
;       RES 5,(IY+1)
;PAUSK  BIT 5,(IY+1)
;       JR Z,PAUSK

        JR NO_US
USTAM   EQU $-1
        LD HL,43059
        LD (HL),#7F
        INC HL
        LD (HL),0
NO_US
        JP 32765
LOAD
        PUSH HL         ;!!!
LOAD11  LD DE,(#5CF4)
        LD C,5
LOAD1   PUSH HL
        PUSH DE
        PUSH BC
        CALL LL_3D13
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        JR NZ,LOAD1
        RET

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
        ENT
ENDLOAD
