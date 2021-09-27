; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at https://github.com/aws/mit-0


; This is the info viewer for crack releases pack #3 by alx^bw.
; Never relesed.


FONTADR EQU #6000
ATRBUF  EQU #7000
TXTBUF  EQU #8700
DEPBUF  EQU #8100
SCR_ADR_TABL EQU #FF02
OVERLAYS EQU 2

TEST    EQU 1


        DISPLAY "info viewer for CRACK RELEASES PACK #3"
        DISPLIN
        DISPLAY "testmode is "
        IFN TEST
        DISPLAY /L,"on"
        ELSE 
        DISPLAY /L,"off"
        ENDIF 

        ;loader section
        ORG #5D3B
INTRSECS        EQU 29
MASK    EQU 1+2+4+8+16

        DB 0,1,#FF,#FF,#D9,#C0,"0"
        DB #0E,0,0
        DW START
        DB 0
        DB #16,0,0
        DB "loader by alx/brainwave o4.o5.3"
        DB #10
START
        LD HL,#5B00
        LD A,L
        OUT (#FE),A
CLS_L   DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLS_L

        LD HL,#6000
        LD SP,HL
        LD B,INTRSECS
LOADDR  PUSH HL
LOADDEP
        LD DE,(#5CF4)
        LD C,5

TR_DOS  PUSH HL
        PUSH DE
        PUSH BC
        CALL TRDOS
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        JR NZ,TR_DOS
        DI 
        LD D,H
        LD E,L
;----------------------------------
TableAdr       EQU DEPBUF;[#05C0]
Tree1Adr       EQU TableAdr+#0000;[#0480]
Tree2Adr       EQU TableAdr+#0480;[#0080]
BitLenTb1      EQU TableAdr+#0480;[#0120]
BitLenTb2      EQU TableAdr+#05A0;[#0020]
;----------------------------------

Depack         PUSH DE
               LD C,(HL)
               INC HL
               LD B,(HL)
               INC HL
               EX DE,HL
               ADD HL,BC
               EX DE,HL
               LD C,(HL)
               INC HL
               LD B,(HL)
               ADD HL,BC
               SBC HL,DE
               ADD HL,DE
               JR C,$+4
               LD D,H
               LD E,L
               LDDR 
               INC DE

               PUSH DE
               POP IX

UnpackTree     LD DE,BitLenTb1-1
               PUSH DE
               LD BC,#1201
               LD A,#10
               SRL C
               CALL Z,GetNextByte
               RLA 
               JR NC,$-6
               INC DE
               LD (DE),A
               DJNZ $-12

               PUSH BC
               LD DE,#0012
               CALL Tree1Create
               POP BC

               POP DE
UT0            CALL GetWord1
               CP #10
               JR C,UT1
               JR Z,UT2
               LD A,(DE)
               INC DE
               LD (DE),A
UT1            INC DE
               LD (DE),A
               JR UT0
UT2
               PUSH BC
               LD DE,#0120
               CALL Tree1Create
               LD HL,BitLenTb2
               LD BC,Tree2Adr
               LD DE,#0020
               CALL TreeCreate
               POP BC
               POP DE

               XOR A
               PUSH AF
               CALL GetWord1
               DEC H
               JR NZ,$-5

UnpackWord     DEC DE
               CALL GetWord1
               INC DE
               LD (DE),A

        PUSH AF
        AND MASK
        OUT (#FE),A
        XOR A
        OUT (#FE),A
        POP AF

               DEC H
               JR NZ,$-6-11+2
               OR A
               JR Z,Stop
               CALL DecodeNum
               PUSH HL


               LD HL,Tree2Adr
               CALL GetWord
               OR A
               JR Z,UW1
               CALL DecodeNum
               LD (LastDist),HL

               LD A,H
UW1            POP HL
               CP #01
               JR C,$+8
               INC HL
               CP #20
               JR C,$+3
               INC HL
               PUSH BC
               LD B,H
               LD C,L
               LD H,D
               LD L,E
               PUSH DE
LastDist       EQU $+1
               LD DE,#0000
               OR A
               SBC HL,DE
               POP DE
               LDIR 
               POP BC
               JR UnpackWord

Stop           POP AF
               RET Z
               LD (DE),A
               INC DE
               JR $-4

DecodeNum      ADD A,-#05
               RET NC
               ADD A,#05-#03
               RRA 
               LD L,#01
               RL L
               SRL C
               CALL Z,GetNextByte
               ADC HL,HL
               DEC A
               JR NZ,$-8
               INC HL
               RET 

GetWord1       LD HL,Tree1Adr

GetWord        SRL C
               CALL Z,GetNextByte
               JR NC,$+4
               INC HL
               INC HL
               LD A,(HL)
               INC HL
               LD L,(HL)
               LD H,A
               CP #40
               JR NC,GetWord
               LD A,L
               RET 
GetNextByte    LD C,(IX)
               INC IX
               RR C
               RET 

Tree1Create    LD HL,BitLenTb1
               LD BC,Tree1Adr

;HL=Адрес таблицы длин слов
;BC=Адрес дерева
;DE=Длина таблицы длин слов

TreeCreate     INC DE
               DEC HL
               DEC HL
               PUSH BC
               EXX 
               POP DE
               LD H,D
               LD L,E
               XOR A
               PUSH AF
               INC A
               PUSH HL
               PUSH AF
               LD C,A

TC1            EXX 
               LD B,D
               LD C,E
               ADD HL,BC
               EXX 

TC2            LD B,A
               LD A,C
               EXX 
               CPDR 
               LD A,B
               OR C
               EXX 
               LD A,B
               JR NZ,TC4
               INC C
               JR TC1
TC3            INC DE
               INC DE
               INC DE
               INC DE
               LD (HL),D
               INC HL
               LD (HL),E
               LD H,D
               LD L,E
               INC A
               PUSH HL
               PUSH AF
TC4            CP C
               JR NZ,TC3
               EXX 
               PUSH BC
               EXX 
               POP BC
               DEC BC
               LD (HL),B
               INC HL
               LD (HL),C
               LD C,A
               POP AF
               RET Z
               POP HL
               INC HL
               INC HL
               JR TC2

TRDOS   PUSH HL
        LD HL,(23613)
        LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23824),A
        LD (23823),A
        DEC A
        LD (#5D15),A
;       LD (23610),A
        LD (#5D17),A
        LD (SP2),SP
        JP #3D13
DERR    LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),HL
        LD A,#C9
        LD (#5CC2),A
COMRET  RET 
DRIA    EX (SP),HL
        PUSH AF
        LD A,R
        IFN MASK
        AND MASK
        ENDIF 
        OUT (#FE),A
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR NZ,NO_ERR
        LD A,L
        CP #10
        JR Z,DERR
NO_ERR  XOR A
        OUT (#FE),A
        POP AF
        EX (SP),HL
        RET 
RIA     DUP 3
        POP  HL
        EDUP 
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F


        ;main section

        ORG FONTADR
        INCBIN "viewer.f"
        DS #800,#00
        ORG FONTADR+2
        DI 
        JP INSTALL

        ORG ATRBUF
        DS #300,#00

INSTALL
        LD HL,FONTADR
        LD DE,#4800
        PUSH HL
FONTCNV1
        PUSH DE
        LD B,8
FONTCNV2
        LD A,(HL)
        LD (DE),A
        RES 3,D
        DUP 4
        ADD A,A
        EDUP 
        LD (DE),A
        SET 3,D
        INC HL
        INC D
        DJNZ FONTCNV2
        POP DE
        INC E
        JR NZ,FONTCNV1
        LD HL,#4000
        LD BC,#1000
        POP DE
        LDIR 
        LD A,#C9
        LD (#5D92),A
        LD H,L
        LD (#5E02),HL
        LD H,#FE
        LD A,H
        DEC A
INITIM2 LD (HL),A
        INC HL
        DJNZ INITIM2
        LD (HL),A
        LD H,A
        LD L,A
        LD (HL),#C3
        INC L
        LD (HL),.INT_SR
        INC L
        LD (HL),'INT_SR
        LD HL,(#5CF4)
        LD (DATA_TR_SEC),HL

        LD HL,#FF11
        LD BC,#7FFD
        LD A,#10
        OUT (C),A
        LD (HL),A
        OUT (C),L
        LD (HL),L
        OUT (C),A
        CP (HL)
        JR NZ,MODE_48
        OUT (C),L
        PUSH BC
        LD HL,MUSIC
        LD DE,#C000
        LD BC,EMUSIC-MUSIC
        LDIR 
        POP BC
        OUT (C),A
        XOR A
        LD (MUSPLAY),A
        LD (MUSINIT),A
        LD (MUSSHUT),A
MODE_48

        CALL MUSINIT
        LD IX,SCR_ADR_TABL
        LD HL,ATRBUF
        LD DE,#4100
        LD BC,#1820
SCR_AT1 PUSH BC
        LD (IX+0),E
        LD (IX+1),D
        LD (IX+2),L
        LD (IX+3),H
        DUP 4
        INC IX
        EDUP 
        LD B,0
        ADD HL,BC
        LD A,E
        ADD A,#20
        LD E,A
        JR NC,SCR_AT2
        LD A,D
        ADD A,8
        LD D,A
SCR_AT2 POP BC
        DJNZ SCR_AT1
        LD HL,COLOR_DATA
        LD DE,FONTADR+#200
        LD BC,#0610
COLD_I1 PUSH BC,DE
        LD B,0
        LDIR 
        POP DE,BC
        INC D
        DJNZ COLD_I1

LOAD_BLOK
        DI 
        CALL MUSSHUT
        XOR A
        LD I,A
        IM 1
        LD IY,#5C3A
        LD HL,#2758
        EXX 
        LD A,#00
BLOK_NO EQU $-1

        DUP 2
        ADD A,A
        EDUP 
        LD E,A
        LD D,0
        LD HL,BLOK_INDEX
        ADD HL,DE
        LD A,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD B,(HL)
        OR A
        JR Z,sec_nad
        INC B
sec_nad LD HL,#2121
DATA_TR_SEC EQU $-2
        PUSH AF
tsc_adl LD A,D
        OR E
        JR Z,tsc_ade
        INC L
        BIT 4,L
        JR Z,tsc_nad
        INC H
        LD L,0
tsc_nad DEC DE
        JR tsc_adl
tsc_ade
        EX DE,HL
        LD HL,TXTBUF
        PUSH HL
        PUSH BC
        LD C,5
        CALL #5D81
        POP BC
        POP HL
        POP AF
        LD L,A
        LD DE,TXTBUF
        PUSH DE
        LDIR 

        DI 
        LD A,#FE
        LD I,A
        IM 2
        EI 
        POP HL
        PUSH HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        DEC HL
        PUSH DE
        CALL #5D93
        POP DE,HL
        XOR A
        ADD HL,DE
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL

        LD (PAGS_TABL_ADR),HL
        LD DE,TXTBUF
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
PAGS_I0 LD B,24
PAGS_I1 LD A,(DE)
        INC DE
        OR A
        JR Z,PAGS_IE
        CP #0D
        JR NZ,PAGS_I1
        DJNZ PAGS_I1
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        JR PAGS_I0
PAGS_IE LD (HL),#FF
        INC HL
        LD (HL),#FF

        LD A,#3F
LAST_PAGE_SW EQU $-1
        OR A
        JR NZ,NO_LAST_PAGE
        DEC HL,HL,HL
        LD (PAGS_TABL_ADR),HL
        LD A,H
        LD (LAST_PAGE_SW),A
NO_LAST_PAGE

PAGE_PRINT
        HALT 
        XOR A
        LD (OUT_ATR_SW),A
        LD HL,#5B00
        LD B,9
        CALL STEK_CLEAR
        LD HL,#5000
        CALL STEK_CLEAR0
        LD HL,#4800
        CALL STEK_CLEAR0

        LD BC,'FONTADR+1*#100+'FONTADR+9
        EXX 
        LD IX,SCR_ADR_TABL
        LD HL,#2121
PAGS_TABL_ADR EQU $-2
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD B,24
        JP PR_NEXTLINE1
PRINT_L0
        LD A,(DE)
        INC DE
        CP #0D
        JP Z,PR_NEXTLINE1
        OR A
        JP Z,PRINT_END
;       CP #20          ;если текст содержит строки неначина-
;       JP NC,PRINT_1   ;ющиеся с цветового кода, то
                        ;добавить эти строки
        LD C,A
PRINT_L1
        LD A,(DE)
        INC DE
        CP #21
        JP NC,PRINT_1
        CP #0D
        JR Z,PR_NEXTLINE1
        CP #20
        JP Z,PR_SPACE1
        LD C,A
        LD (HL),C
PRINT_L2
        LD A,(DE)
        INC DE
        CP #21
        JP NC,PRINT_2
        CP #0D
        JR Z,PR_NEXTLINE1
        CP #20
        JP Z,PR_SPACE2
        LD C,A
        INC L
        EXX 
        INC L
        EXX 
        JP PRINT_L1
PRINT_1 LD (HL),C
        EXX 
        LD D,B
        LD E,A
        PUSH HL
        DUP 6
        LD A,(DE)
        LD (HL),A
        INC D
        INC H
        EDUP 
        LD A,(DE)
        LD (HL),A
        POP HL
        EXX 
        JP PRINT_L2
PRINT_2 LD (HL),C
        INC L
        EXX 
        LD D,C
        LD E,A
        PUSH HL
        DUP 6
        LD A,(DE)
        OR (HL)
        LD (HL),A
        INC D
        INC H
        EDUP 
        LD A,(DE)
        OR (HL)
        LD (HL),A
        POP HL
        INC L
        EXX 
        JP PRINT_L1

PR_SPACE1
        LD (HL),C
        JP PRINT_L2
PR_SPACE2
        INC L
        EXX 
        INC L
        EXX 
        JP PRINT_L1

PR_NEXTLINE1
        LD L,(IX+2)
        LD H,(IX+3)
        EXX 
        LD L,(IX+0)
        LD H,(IX+1)
        EXX 
        DUP 4
        INC IX
        EDUP 
        DEC B
        JP NZ,PRINT_L0
;end of print page
PRINT_END
        LD A,H
        LD (OUT_ATR_SW),A
        DUP 3
        HALT 
        EDUP 

MAIN_CYCLE
        HALT 
        LD HL,KEYBUF+1
        BIT 0,(HL)
        JR Z,PAGE_DOWN
        INC HL
        BIT 0,(HL)
        JR Z,PAGE_UP

        IFN TEST
        BIT 1,(HL)
        JR Z,EXIT_OUT
        ENDIF 

        INC HL
        LD A,(KEYBUF)
        RRA 
        JR NC,KEY_WITH_CAPS

        BIT 2,(HL)
        JR Z,PAGE_DOWN
        BIT 3,(HL)
        JR Z,PAGE_UP
        INC HL
        BIT 2,(HL)
        JR Z,PAGE_DOWN
        BIT 1,(HL)
        JR Z,PAGE_UP
KEY_SLI INC HL
        INC HL
        INC HL
        BIT 3,(HL)
        JR NZ,NO_CPAL

        LD A,(TABL_ATR_ADR)
        INC A
        INC A
        CP 'FONTADR+7
        JR C,NB_CPAL
        LD A,'FONTADR+2
NB_CPAL
        DUP 8
        HALT 
        EDUP 
        LD (TABL_ATR_ADR),A
NO_CPAL BIT 2,(HL)
        JR NZ,NO_SMUS
        HALT 
        LD A,(MUS_PLAY_SW)
        CPL 
        OR A
        LD (MUS_PLAY_SW),A
        CALL MUSINIT
        DUP 8
        HALT 
        EDUP 
NO_SMUS
        JR MAIN_CYCLE


KEY_WITH_CAPS
        BIT 3,(HL)
        JR Z,PAGE_DOWN
        BIT 2,(HL)
        JR Z,PAGE_UP
        INC HL
        BIT 4,(HL)
        JR Z,PAGE_DOWN
        BIT 3,(HL)
        JR Z,PAGE_UP
        JR KEY_SLI

        IFN TEST
EXIT_OUT
        DI 
        CALL MUSINIT
        XOR A
        LD I,A
        IM 1
        EI 
        RET 
        ENDIF 

PAGE_UP
        LD HL,(PAGS_TABL_ADR)
        DEC HL
        LD D,(HL)
        DEC HL
        LD E,(HL)
        JR PAGE_UND

PAGE_DOWN
        LD HL,(PAGS_TABL_ADR)
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        DEC HL
PAGE_UND
        LD (PAGS_TABL_ADR),HL
        LD A,E
        OR D
        JR Z,L_PRV_BLOK
        INC DE
        LD A,E
        OR D
        JR Z,L_NXT_BLOK
        XOR A
        LD (OUT_ATR_SW),A
        JP PAGE_PRINT
NL_NXT_BLOK
        LD HL,(PAGS_TABL_ADR)
        DEC HL
        DEC HL
NL_NNP_BL
        LD (PAGS_TABL_ADR),HL
        JP MAIN_CYCLE
NL_PRV_BLOK
        LD HL,(PAGS_TABL_ADR)
        INC HL
        INC HL
        JR NL_NNP_BL

L_NXT_BLOK
        LD A,(BLOK_NO)
        CP OVERLAYS-1
        JR Z,NL_NXT_BLOK
        INC A
L_NNP_BL
        LD (BLOK_NO),A
        JP LOAD_BLOK
L_PRV_BLOK
        LD A,(BLOK_NO)
        OR A
        JR Z,NL_PRV_BLOK
        DEC A
        EXA 
        XOR A
        LD (LAST_PAGE_SW),A
        EXA 
        JR L_NNP_BL

;stek clear
STEK_CLEAR0
        LD B,6
STEK_CLEAR
        LD DE,0
        LD (STK_CL_SP),SP
        LD SP,HL
STK_CL1
        DUP #80
        PUSH DE
        EDUP 
        DEC B
        JP NZ,STK_CL1
        DUP #7F
        PUSH DE
        EDUP 
        LD (STK_CL_LB),SP
        LD SP,#3131
STK_CL_SP EQU $-2
        LD HL,#2121
STK_CL_LB EQU $-2
        DEC L
        LD (HL),E
        DEC L
        LD (HL),E
        RET 

KEYBUF  DS 8,#C9

INT_SR  DI 
        LD (INT_SR_HL),HL
        POP HL
        LD (INT_SR_RET),HL
        LD (INT_SR_SP),SP
        LD SP,0
        PUSH DE,BC,AF
        EXA 
        EXX 
        PUSH IX,HL,DE,BC,AF

        LD HL,KEYBUF
        LD BC,#FEFE
        LD E,8
KEY_RQL IN A,(C)
        AND #1F
        RLC B
        LD (HL),A
        INC HL
        DEC E
        JR NZ,KEY_RQL

        LD A,#FF
MUS_PLAY_SW EQU $-1
        OR A
        JR Z,NO_MUS_PLAY
        CALL MUSPLAY
NO_MUS_PLAY


        LD A,#3F
OUT_ATR_SW EQU $-1
        OR A
        JR Z,NO_OUT_ATR

        LD BC,#5800
        LD DE,ATRBUF
        LD H,'FONTADR+2
TABL_ATR_ADR EQU $-1
        LD A,48
OUTATR  EXA 

        DUP #0F
        LD A,(DE)
        LD L,A
        LD A,(HL)
        INC E
        LD (BC),A
        INC C
        EDUP 
        LD A,(DE)
        LD L,A
        LD A,(HL)
        INC DE
        LD (BC),A
        INC BC
        EXA 
        DEC A
        JP NZ,OUTATR
NO_OUT_ATR

        LD A,(TABL_ATR_ADR)
        XOR 1
        LD (TABL_ATR_ADR),A


        POP AF,BC,DE,HL,IX
        EXA 
        EXX 
        POP AF,BC,DE
        LD SP,#3131
INT_SR_SP EQU $-2
        LD HL,#2121
INT_SR_HL EQU $-2
        EI 
        JP #C3C3
INT_SR_RET EQU $-2

MUSPLAY RET 
        LD BC,#7FFD
        LD DE,#1110
        OUT (C),D
        PUSH DE,BC
        CALL #C005
        POP BC,DE
        OUT (C),E
        RET 

MUSINIT RET 
        LD BC,#7FFD
        LD DE,#1110
        OUT (C),D
        PUSH DE,BC
        CALL #C000
        POP BC,DE
        OUT (C),E
        RET 

MUSSHUT RET 
        LD BC,#7FFD
        LD DE,#1110
        OUT (C),D
        PUSH DE,BC
        CALL #C008
        POP BC,DE
        OUT (C),E
        RET 

BLOK_INDEX
        INCBIN "index#02"

COLOR_DATA
;   #01,#02,#03,#04,#05,#06,#07,#08,#09,#0A,#0B,#0C,#0D,#0E,#0F
;2bitplaned pallete
 DB 0
 DB #41,#43,#43,#44,#47,#46,#47,#41,#42,#41,#44,#44,#00,#47,#47
 DB 0
 DB #45,#42,#04,#45,#45,#45,#42,#43,#41,#06,#07,#46,#00,#41,#46
;colour pallete
 DB 0
 DB #41,#42,#43,#44,#45,#46,#47,#01,#02,#03,#04,#05,#00,#07,#06
 DB 0
 DB #41,#42,#43,#44,#45,#46,#47,#01,#02,#03,#04,#05,#00,#07,#06
;monochrome pallete
 DB 0
 DS 15,#47
 DB 0
 DS 15,#47

MUSIC   INCBIN "view_mus.C"
MUSIC2  INCBIN "viewmus2.C"
EMUSIC
END_OBJ DISPLAY "save [fname],#6000,",END_OBJ-#6000

        ORG #5CF4
        DW #2402

        ORG FONTADR+2
