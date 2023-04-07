; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


        ORG #6000
        DISPLAY
        DUP 23
        DISPLAY /L,"-"
        EDUP
        DISPLAY "| lamergy #KIDS intro |"
        DISPLAY
        DUP 23
        DISPLAY /L,"-"
        EDUP

        MACRO HERO
        CALL OUT_SPR_NO_ATR
        ENDM


BORD     EQU 0
SPR_ADR  EQU #7F00
FONT_ADR EQU #7700
SCR_BUF  EQU #7400
SCR_TBL  EQU #7300
STAR_TBL EQU #7200
INT_TABL EQU #7700
SCRJ_POS EQU 36

        CALL CLR_SCR_BUF
        LD H,#76
        LD A,H
        LD I,A
        DEC A
INT_INI LD (HL),A
        INC HL
        DJNZ INT_INI
        LD (HL),A
        CALL CLS2
        HALT
        CALL BANK18

        XOR A
        CALL OUTSCR
        DI
        CALL OUT_SPR_HH
        EI
        HALT
        LD A,#17
        CALL BANK
        LD H,#D8        ;!
        LD DE,#D801
        LD BC,#02FF
        LD (HL),#3F
        LDIR
        CALL BANK10

        LD HL,SRC_TBL
        LD D,'SCR_TBL
        EXX
        LD HL,STAR_TBL
        EXX
        LD B,SCRJ_POS
INS_SCR_TBL_L
        PUSH BC
        LD A,(HL)
        PUSH HL
        CALL #22B0
        EX DE,HL
        LD (HL),E
        INC L
        LD (HL),D
        INC L
        EX DE,HL
        POP HL
        PUSH HL
        LD A,(HL)
        SUB 191
        NEG
        ADD A,48
        LD C,8*21
        CALL #22B0
        PUSH HL
        EXX
        POP DE
        LD A,D
        ADD A,#80
        LD D,A
        LD (HL),E
        INC L
        LD (HL),D
        INC L
        EXX
        POP HL
        INC HL
        POP BC
        DJNZ INS_SCR_TBL_L

        CALL MUS_ADR

        IM 2

        LD B,#16*3+3
        CALL FLASHES
        LD B,#20*3
PAUS1   HALT
        DJNZ PAUS1
        XOR A
        LD (COUNTERS_SW),A

PART1_LOOP
        HALT
        CALL FLP
        CALL OUT_SPR_HH
        CALL HOOY
        CALL SPC_SCAN
        JR C,PART1_LOOP

        HALT
        CALL CLS2
        CALL BANK18
        LD A,1
        CALL OUTSCR
        LD A,5
        LD DE,#481B
        HERO            ;ZAKS
        LD A,8
        LD DE,#5082     ;POGY
        HERO
        LD A,10
        LD DE,#5097
        HERO            ;DOZY
        LD A,12
        LD DE,#48D0
        HERO            ;DAISY
        LD A,14+1
        LD DE,#507B
        HERO            ;DORA
        LD A,17
        LD DE,#506B
        HERO            ;GRAND DIZZY
        LD A,19
        LD DE,#5071
        HERO            ;DANZIL
        LD A,20
        LD DE,#5065
        HERO            ;DYLAN
        LD A,22
        LD DE,#48CD
        HERO            ;DIZZY

        HALT

        LD A,#17
        CALL BANK
        LD DE,#C000
        LD IX,#D800
        LD A,1
        CALL OUT_SPR
        LD A,5
        LD DE,#C81B
        HERO            ;ZAKS
        LD A,9
        LD DE,#D082     ;POGY
        HERO
        LD A,10
        LD DE,#D097
        HERO            ;DOZY
        LD A,13
        LD DE,#C8D0
        HERO            ;DAISY
        LD A,14+1
        LD DE,#D07B
        HERO            ;DORA
        LD A,16
        LD DE,#D06B
        HERO            ;GRAND DIZZY
        LD A,18
        LD DE,#D071
        HERO            ;DANZIL
        LD A,21
        LD DE,#D065
        HERO            ;DYLAN
        LD A,23
        LD DE,#C8CD
        HERO            ;DIZZY
        LD H,C
        LD L,C
        LD (#D98F),HL
        LD (#D9AF),HL

        LD HL,TEXT_ADR2
        LD (TXT_POS),HL
        LD (TXT0POS),HL
        LD A,H
        LD (HOOY_SW),A
        LD HL,ENDTEXT_ADR2
        LD (TXTHOOY),HL
        LD A,#3E
HOOY0SW EQU $-1
        OR A
        CALL Z,HOOY0
        CALL CLR_SCR_BUF

        LD A,#15
        CALL BANK
        CALL BLYATNAHOOY

PART2_LOOP
        EI
        HALT

        IF0 BORD-1
        LD A,4
        OUT (#FE),A
        ENDIF

;-------GET ADDR FOR STAR--------
        CALL BANK10_

        LD A,(COUN1)
        ADD A,A
        LD H,'STAR_TBL
        LD L,A
        LD E,(HL)
        INC L
        LD D,(HL)
        PUSH DE

;-------SCREEN SWITCHER---------
        LD A,(COUN2)
        OR A
        LD A,(LAST_BANK)
        JR NZ,NO_SW_SCR
        XOR #8+2
NO_SW_SCR
        CALL BANK

;-------GLASS SCENE ;)-------
        LD A,#3E
GLASS_SCENE_SW EQU $-1
        OR A
        JR NZ,NO_GLASS
        LD H,A
        LD A,#00
FR_GLAS EQU $-1
        INC A
        CP #B
        LD (FR_GLAS),A
        JR Z,OFF_GLAS
        LD L,A
        LD DE,#D8EA
        ADD HL,DE
        LD A,#47
        PUSH HL
        CALL GLASS0
        CALL GLAS_DEL
        POP HL
        LD (GLAS_DADR),HL
        JR END_GLAS
OFF_GLAS
        LD (GLASS_SCENE_SW),A
        XOR A
        LD (FR_GLAS),A
        CALL GLAS_DEL
NO_GLASS
        LD A,(COUN4)
        CP #48
        JR NZ,END_GLAS
        XOR A
        LD (GLASS_SCENE_SW),A
END_GLAS

;-------GLASS SCENE2 ;)-------
        LD A,#3E
GLASS_SCENE_SW2 EQU $-1
        OR A
        JR NZ,NO_GLASS2
        LD H,A
        LD A,#00
FR_GLAS2 EQU $-1
        INC A
        CP #9
        LD (FR_GLAS2),A
        JR Z,OFF_GLAS2
        LD DE,FONT_ADR
        ADD A,A
        ADD A,A
        ADD A,A
        LD L,A
        ADD HL,DE
        PUSH HL
        CALL BANKT
        CALL OUT_GLAS2
        POP HL
        CALL BANKT2
        CALL OUT_GLAS2
        JR END_GLAS2
OFF_GLAS2
        LD (GLASS_SCENE_SW2),A
        XOR A
        LD (FR_GLAS2),A

NO_GLASS2
        LD A,R
        OR A
        JR NZ,END_GLAS2
        XOR A
        LD (GLASS_SCENE_SW2),A
END_GLAS2
        CALL BANKT

;-------DELETE & OUTPUT THE NEW STAR------
        LD HL,#C0D5
        LD B,56
DEL_STAR_L
        XOR A
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD (HL),A
        DEC L
        DEC L
        INC H
        LD A,H
        AND #7
        JR NZ,DEL_STAR0
        LD A,L
        ADD A,#20
        LD L,A
        JR C,DEL_STAR0
        LD A,H
        SUB 8
        LD H,A
DEL_STAR0
        DJNZ DEL_STAR_L

        POP DE
        LD A,4
        HERO

;-------ZAKS' EYES FUCKING-----
        LD A,0
FUCK_ZAKS_EYES_SW EQU $-1
        OR A
        JR Z,NO_FUCK_ANIM
        LD A,0
FUCK_FR EQU $-1
        INC A
        LD (FUCK_FR),A
        CP 3+8+3-1
        JR NZ,NO_END_FUCK
        XOR A
        LD (FUCK_FR),A
        LD (FUCK_ZAKS_EYES_SW),A
        JR NO_FUCK_ZAKS_EYES
NO_END_FUCK
        CP 3
        JR C,FUCK_INC
        CP 3+8
        JR C,NO_FUCK_ZAKS_EYES
        LD A,5
ZAKS_S  EQU $-1
        DUP 2
        DEC A
        EDUP
        LD (ZAKS_S),A
FUCK_INC
        LD A,(ZAKS_S)
        INC A
        LD (ZAKS_S),A
        JR NO_FUCK_ZAKS_EYES

NO_FUCK_ANIM
        LD A,(COUN4)
        CP #48
        JR NZ,NO_FUCK_ZAKS_EYES
        LD A,1
        LD (FUCK_ZAKS_EYES_SW),A

NO_FUCK_ZAKS_EYES

        LD A,(ZAKS_S)
        LD DE,#C81B
        HERO

;-------FLASH "KIDS"-----
        LD A,(COUN1)
        OR A
        LD A,7
        JR NZ,NO_FLASH_KIDS
        OR #40
NO_FLASH_KIDS
        LD HL,#D82C
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD (HL),A

;-------KOLBASSING DIZZY & DAISY-------
        LD A,(COUN3)
        OR A
        JR NZ,NO_SW_DIZZY_DAISY
        LD A,13
DAISY_S EQU $-1
        XOR 1
        LD (DAISY_S),A
        LD DE,#C8D0
        HERO            ;DAISY
        LD A,22
DIZZY_S EQU $-1
        XOR 1
        LD (DIZZY_S),A
NO_SW_DIZZY_DAISY

;-------SMILING DIZZY--------
        LD A,0
SMIL_DIZ_SW EQU $-1
        OR A
        JR Z,NO_SMILE_ANIM
        LD A,0
SMIL_FR EQU $-1
        INC A
        LD (SMIL_FR),A
        CP 5+8+5-1
        JR NZ,NO_END_SMIL
        XOR A
        LD (SMIL_FR),A
        LD (SMIL_DIZ_SW),A
        JR NO_SMILE_DIZZY
NO_END_SMIL
        CP 5
        JR C,SMIL_INC
        CP 5+8
        JR C,NO_SMILE_DIZZY
        LD A,(DIZZY_S)
        DUP 4
        DEC A
        EDUP
        LD (DIZZY_S),A
SMIL_INC
        LD A,(DIZZY_S)
        INC A
        INC A
        LD (DIZZY_S),A
        JR NO_SMILE_DIZZY

NO_SMILE_ANIM
        LD A,(COUN4)
        OR A
        JR NZ,NO_SMILE_DIZZY
        LD A,1
        LD (SMIL_DIZ_SW),A

NO_SMILE_DIZZY
        LD A,(DIZZY_S)
        LD DE,#C8CD
        HERO


;-------ZZZZ DOZY--------
        LD A,R
        CP #47
        JR NZ,NO_Z_DOZY
        LD A,10
DOZY_S  EQU $-1
        XOR 1
        LD (DOZY_S),A
NO_Z_DOZY
        LD A,(DOZY_S)
        LD DE,#D097
        HERO            ;DOZY

;-------DORA-----------
        LD A,R
DORASWC CP #25
        JR NZ,NO_Z_DORA
        LD A,14+1
DORA_S  EQU $-1
        XOR 1
        LD (DORA_S),A
        LD HL,DORASWC
        LD A,(HL)
        XOR #35
        LD (HL),A
        INC HL
        LD A,(HL)
        XOR #4A
        LD (HL),A
NO_Z_DORA
        LD A,(DORA_S)
        LD DE,#D07B
        HERO            ;DORA

;-------FLP2--------
        CALL BANK10_

FLP2    CALL FLPCHR
        CALL BANK17_
        LD DE,#C77C
        LD (FLP2_SP),SP

        LD HL,SCR_BUF+#E7
        LD A,7
FLP2_L  EXA
        EX DE,HL
        LD SP,HL
        EX DE,HL
        SLA (HL)
        DEC HL
        DUP 12
        RL (HL)
        LD B,(HL)
        DEC HL
        RL (HL)
        LD C,(HL)
        DEC HL
        PUSH BC
        EDUP
        LD A,D
        DEC D
        AND 7
        JR NZ,FLP2_0
        LD A,E
        SUB #20
        LD E,A
        JR C,FLP2_0
        LD A,D
        ADD A,8
        LD D,A
FLP2_0  EXA
        DUP 8
        DEC HL
        EDUP
        DEC A
        JP NZ,FLP2_L
        LD SP,#3131
FLP2_SP EQU $-2

        LD HL,#C17C-24
        LD DE,#417C-24
        LD B,7
MOV_FLP2_L
        PUSH BC
        PUSH HL
        PUSH DE
        DUP 24
        LDI
        EDUP
        POP DE
        POP HL
        INC D
        LD A,D
        AND #7
        JR NZ,MOV_FLP20
        LD A,E
        ADD A,#20
        LD E,A
        JR C,MOV_FLP20
        LD A,D
        SUB 8
        LD D,A
MOV_FLP20
        INC H
        LD A,H
        AND #7
        JR NZ,MOV_FLP21
        LD A,L
        ADD A,#20
        LD L,A
        JR C,MOV_FLP21
        LD A,H
        SUB 8
        LD H,A
MOV_FLP21
        POP BC
        DJNZ MOV_FLP2_L

;-------VOLUME ANALISER-------
        LD BC,#0308
        LD HL,#5830
        LD DE,#D830
ANAL_LOOP ;)
        CALL AY_IN
        AND #F
        SRL A
        JR NC,AN_NO_B
        OR #40
AN_NO_B LD (HL),A
        LD (DE),A
        INC L
        INC E
        INC C
        DJNZ ANAL_LOOP

;-------MAGICLAND'S FLASH-------
        LD C,9
        CALL AY_IN
        CP 11
        LD A,#47
        JR NC,NO_MAG_FL
        XOR 3
NO_MAG_FL
        LD HL,#58CB
        CALL FILATR
        LD HL,#D8CB
        CALL FILATR
        CALL HOOY

;-------END OF ROUTINES

        IF0 BORD-1
        XOR A
        OUT (#FE),A
        ENDIF

        CALL SPC_SCAN
        JP C,PART2_LOOP

        HALT
        DI
        CALL BANK10
        LD A,#3F
        LD I,A
        IM 1
        LD HL,#5800
        LD DE,#5801
        LD BC,#02FF
        LD (HL),L
        LDIR

        CALL BANK10
        CALL MUS_ADR+8
        LD HL,#2758
        EXX
        RET

CLR_SCR_BUF
        LD HL,SCR_BUF
        LD DE,SCR_BUF+1
        LD BC,#100
        LD (HL),C
        LDIR
        RET

FILATR  LD B,10
FILATRL LD (HL),A
        INC L
        DJNZ FILATRL
        RET

AY_IN   PUSH BC
        LD A,C
        LD BC,#FFFD
        OUT (C),A
        IN A,(C)
        POP BC
        RET

GLASS   LD A,#46
GLASS0  LD BC,#0520
GLAS_L  PUSH BC
        LD (HL),A
        LD B,0
        ADD HL,BC
        POP BC
        DJNZ GLAS_L
        RET

GLAS_DEL
        LD HL,#2121
GLAS_DADR EQU $-2
        PUSH HL
        CALL GLASS
        POP HL
        CALL BANKT2
        CALL GLASS
        RET

BLYATNAHOOY
        EI
        LD A,(COUN1)
        OR A
        JR NZ,BLYATNAHOOY
        RET

FLASHES CALL FLASH
        LD B,#20*3
FLASH   EI
FLASH0  HALT
        DJNZ FLASH0
        LD A,#7
        OUT (#FE),A
        CALL BANK18
        HALT
        XOR A
        OUT (#FE),A
        JP BANK10

SPC_SCAN
        LD BC,#7FFE
        IN A,(C)
        RRA
        RET C
SPC_SC0 IN A,(C)
        RRA
        JR NC,SPC_SC0
        XOR A
        RET

FLP     CALL FLPCHR
        LD (OUTS_H2),SP
        JR NO_CLN_FLP
CLN_FLP_SW EQU $-1
        LD DE,0
        LD HL,#1111
LAST_FLP_ADR EQU $-2
        LD B,7
LFA_L   LD SP,HL
        DUP 16
        PUSH DE
        EDUP
        LD A,H
        DEC H
        AND 7
        JR NZ,CFLP_0
        LD A,L
        SUB #20
        LD L,A
        JR C,CFLP_0
        LD A,H
        ADD A,8
        LD H,A
CFLP_0  DJNZ LFA_L

NO_CLN_FLP
        XOR A
        LD (CLN_FLP_SW),A

        LD A,(COUN1)
        ADD A,A
        LD L,A

        LD H,'SCR_TBL
        LD E,(HL)
        INC L
        LD D,(HL)
        LD (LAST_FLP_ADR),DE

        LD HL,SCR_BUF+#E7
        LD A,7
FLP_L   EXA
        EX DE,HL
        LD SP,HL
        EX DE,HL
        SLA (HL)
        DEC HL
        DUP 16
        RL (HL)
        LD B,(HL)
        DEC HL
        RL (HL)
        LD C,(HL)
        DEC HL
        PUSH BC
        EDUP
        LD A,D
        DEC D
        AND 7
        JR NZ,FLP_0
        LD A,E
        SUB #20
        LD E,A
        JR C,FLP_0
        LD A,D
        ADD A,8
        LD D,A
FLP_0   EXA
        DEC A
        JP NZ,FLP_L
        JP OUTS2_6

FLPCHR  LD A,1
FLP_SCP EQU $-1
        DEC A
        LD (FLP_SCP),A
        RET NZ
        LD HL,TEXT_ADR
TXT_POS EQU $-2
        LD C,(HL)
TXT_CNG INC HL
FLP_00  LD (TXT_POS),HL
        LD H,A
        LD L,C
        LD A,C
        CP #FF
        JR NZ,NO_END_TXT
        LD HL,TEXT_ADR
TXT0POS EQU $-2
        XOR A
        LD C,#20
        JR FLP_00
NO_END_TXT
        LD DE,FONT_ADR
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,DE
        LD A,(HL)
        LD (33*1+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*2+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*3+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*4+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*5+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*6+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (33*7+SCR_BUF),A
        INC L
        LD A,(HL)
        LD (FLP_SCP),A
        RET

OUTSCR  LD DE,#4000
        LD IX,#5800
OUT_SPR
        CALL OUTS_CN
        CALL OUTSPR1
        LD BC,#0101
OUTS_BC EQU $-2
        PUSH IX
        POP DE
OUTSPR4 PUSH BC
        PUSH DE
        LD B,0
        LDIR
        POP DE
        LD C,#20
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        POP BC
        DJNZ OUTSPR4
        RET

OUT_GLAS2
        LD DE,#C7F4
        LD BC,#0801
        JR OUTSPR1

OUT_SPR_NO_ATR
        CALL OUTS_CN
OUTSPR1 PUSH DE
        PUSH BC
OUTSPR2 LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        LD A,D
        AND #7
        JR NZ,OUTSPR3
        LD A,E
        ADD A,#20
        LD E,A
        JR C,OUTSPR3
        LD A,D
        SUB 8
        LD D,A
OUTSPR3 DJNZ OUTSPR2
        POP BC
        POP DE
        INC DE
        DEC C
        JR NZ,OUTSPR1
        RET

OUTS_CN
        ADD A,A
        LD L,A
        LD H,'SPR_ADR
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD (OUTS_BC),BC
        SLA B
        SLA B
        SLA B
        RET

OUT_SPR_H2
        LD DE,#5020
        LD A,2
        CALL OUTS_CN
        LD (OUTS_H2),SP
        LD SP,HL
OUTS_H2L
        LD A,(DE)
        POP HL
        AND L
        OR H
        LD (DE),A
        INC E
        LD A,(DE)
        POP HL
        AND L
        OR H
        LD (DE),A
        DEC E
        INC D
        LD A,D
        AND #7
        JR NZ,OUTS_H20
        LD A,E
        ADD A,#20
        LD E,A
        JR C,OUTS_H20
        LD A,D
        SUB 8
        LD D,A
OUTS_H20
        DJNZ OUTS_H2L
OUTS2_6 LD SP,#3131
OUTS_H2 EQU $-2
        RET

OUT_SPR_HH
        CALL OUT_SPR_H2
OUT_SPR_H6
        LD DE,#505A
        LD A,3
        CALL OUTS_CN
        LD (OUTS_H2),SP
        LD SP,HL
OUTS_H6L
        LD (OUTS6DE),DE
        DUP 5
        LD A,(DE)
        POP HL
        AND L
        OR H
        LD (DE),A
        INC DE
        EDUP
        LD A,(DE)
        POP HL
        AND L
        OR H
        LD (DE),A
        LD DE,#1111
OUTS6DE EQU $-2
        INC D
        LD A,D
        AND #7
        JR NZ,OUTS_H60
        LD A,E
        ADD A,#20
        LD E,A
        JR C,OUTS_H60
        LD A,D
        SUB 8
        LD D,A
OUTS_H60
        DJNZ OUTS_H6L
        JR OUTS2_6

CLS2    LD A,#17
        CALL BANK
        LD HL,#C000
        LD DE,#C001
        LD BC,#1AFF
        LD (HL),L
        LDIR
        RET

LAST_BANK DB 0
BANK17_ LD A,(LAST_BANK)
BANK170 AND 8
        OR #17
        JR BANK_
BANK10_ LD A,(LAST_BANK)
BANK100 AND 8
        JR BANK_
BANKT2  LD A,(LAST_BANK)
        XOR 2
        JR BANK_
BANKT   LD A,(LAST_BANK)
        JR BANK_
BANK18  LD A,#18
        JR BANK
BANK10  LD A,#10
BANK    LD (LAST_BANK),A
BANK_   PUSH BC
        LD BC,#7FFD
        OUT (C),A
        POP BC
        RET

HOOY    LD A,#3E
HOOY_SW EQU $-1
        OR A
        RET Z
        LD BC,#BFFE
        IN A,(C)
        BIT 1,A
        RET NZ
        LD B,#DF
        IN A,(C)
        BIT 2,A
        RET NZ
        LD B,#FE
        IN A,(C)
        BIT 1,A
        RET NZ
        LD B,#7F
        IN A,(C)
        BIT 3,A
        RET NZ
        LD B,#FD
        IN A,(C)
        BIT 0,A
        RET NZ
        BIT 2,A
        RET NZ
        LD HL,ENDTEXT_ADR
TXTHOOY EQU $-2
        LD (TXT_POS),HL
        LD (TXT0POS),HL
        LD B,6
        LD A,B
        OUT (#FE),A
HOOYPAU HALT
        DJNZ HOOYPAU
        XOR A
        OUT (#FE),A
        LD (HOOY_SW),A
        LD (HOOY0SW),A
HOOY0   LD HL,TXT_CNG
        LD A,(HL)
        XOR #8
        LD (HL),A
        RET

SRC_TBL INCBIN "lameKtbl"

END_COD DISPLAY "end code: ",END_COD," (max=#71FF)"

        ORG #7575
INT_VEC DI
        PUSH AF,BC,DE,HL
        EXA
        EXX
        PUSH AF,BC,DE,HL,IX
        LD A,(LAST_BANK)
        PUSH AF
        AND 8
        OR #10
        CALL BANK_
        CALL MUS_ADR+5

        POP AF
        CALL BANK

        JR NO_COUNTERS
COUNTERS_SW EQU $-1
        LD A,25
COUN1   EQU $-1
        INC A
        CP #24
        JR NZ,NO_Z_C1
        XOR A
NO_Z_C1 LD (COUN1),A

        LD A,8
COUN2   EQU $-1
        INC A
        CP #12
        JR NZ,NO_Z_C2
        XOR A
NO_Z_C2 LD (COUN2),A

        LD A,8
COUN3   EQU $-1
        INC A
        CP 9
        JR NZ,NO_Z_C3
        XOR A
NO_Z_C3 LD (COUN3),A

        LD A,0
COUN4   EQU $-1
        INC A
        CP #24*4+1
        JR NZ,NO_Z_C4
        XOR A
NO_Z_C4 LD (COUN4),A

NO_COUNTERS
        POP IX,HL,DE,BC,AF
        EXA
        EXX
        POP HL,DE,BC,AF
        EI
        RET

END_COD1 DISPLAY "end int_rout: ",END_COD1," (max=#76FF)"

        ORG FONT_ADR
        INCBIN "lamescrl.f"

        ORG SPR_ADR
        INCBIN "lameKspr"

        ORG #C000
MUS_ADR
        INCBIN "lameKmu0"
        DB #FF,#20
TEXT_ADR
        INCBIN "lameKi1.W"
ENDTEXT_ADR EQU $-1
        DB #FF
TEXT_ADR2
        INCBIN "lameKi2.W"
ENDTEXT_ADR2 EQU $-1
        DB #FF

END_TEXTS DISPLAY "end texts & mus: ",END_TEXTS," (max=#FFFF)"
        ORG #6000

