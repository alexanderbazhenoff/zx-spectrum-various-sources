; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #7E00
ADDSECS EQU 1
 DISPLAY "TRAINER AND LOADER 4 El Captain Trueno collection"
        DISPLAY "by Alx^BW 2o.o9.2oo2"
        HALT
        XOR A
        OUT (#FE),A
        LD HL,#5B01
CLS1    DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLS1
        LD DE,#48E0
        LD IX,#59E0
        CALL OUT_SPR
        CALL TRAINALL
KEYSCAN LD HL,TRAIN_P
        RES 5,(IY+1)
WAITKEY BIT 5,(IY+1)
        JR Z,WAITKEY
        LD A,(IY-50)
        PUSH AF
        CP "1"
        CALL Z,TRAIN1
        INC HL
        CP "2"
        CALL Z,TRAIN2
        INC HL
        CP "3"
        CALL Z,TRAIN3
        POP AF
        CP #0D
        CALL Z,TREN
        CP " "
        JR Z,START
        CP "0"
        JR Z,START
        JR KEYSCAN
START
        HALT
        LD HL,#5900
        LD A,L
        LD B,A
CLS13L  LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        DJNZ CLS13L
        LD DE,#50A0
        LD IX,#5AA0
        LD A,1
        CALL OUT_SPR1
        LD HL,LOADPP
        LD DE,#5D3B
        LD BC,ELOADPP-LOADPP
        LDIR
        LD A,(TRAIN_P)
        OR A
        LD HL,LOADER1
        JR Z,PART1
        LD HL,(#5CF4)
        LD B,#6F
ADD_SEC INC L
        BIT 4,L
        JR Z,NO_ADT
        INC H
        LD L,0
NO_ADT  DJNZ ADD_SEC
        LD (#5CF4),HL
        LD HL,LOADER2
PART1
        LD BC,LOADER2-LOADER1+1
        LD SP,#F800
        PUSH DE
        LDIR

        LD HL,TRAIN_P+1
        LD A,(HL)
        INC HL
        OR A
        JR Z,NOTR2
        CPL
        LD (TR_PO2),A
NOTR2   LD A,(HL)
        OR A
        JR Z,NOTR3
        CPL
        LD (TR_PO3),A
NOTR3
        LD HL,MDATA
        LD DE,#FDC0
        LD BC,#D6+#6E
        LDIR
        LD HL,SCR
        LD DE,#9C40
        LD B,#C
        PUSH DE
        LDIR
        POP HL
        PUSH HL
        CALL DEP
        LD B,50
PAUSLG  HALT
        DJNZ PAUSLG
        CALL FADE0
        LD (CHP_SW),A
        LD A,6
        LD (#5B00),A
        RET


LOADER1
        DISP #5F33
        LD HL,#5FB4
        PUSH HL
        LD B,#6F
        CALL LOAD
        LD HL,#FDC0
        LD DE,#CEB4
        LD BC,#D6
        LDIR
        POP HL
        CALL DEP
        JR NOTRN2
TR_PO2  EQU $-1
        LD A,#B6
        LD (#9B1F),A
NOTRN2  JR NOTRN3
TR_PO3  EQU $-1
        XOR A
        LD (#7A16),A
NOTRN3  CALL FADE0
        JP #F3B2
        ENT
LOADER2
        DISP #5F33
        LD HL,#6000
        PUSH HL
        LD B,#6A
        CALL LOAD
        LD HL,#FDC0+#D6
        LD DE,#CA00
        LD BC,#6E
        LDIR
        POP HL
        CALL DEP
        JR NOTRN22
        LD A,#B6
        LD (#662A),A
NOTRN22 JR NOTRN32
        LD A,#C9
        LD (#7006),A
NOTRN32 CALL FADE0
        JP #6000

        ENT

TRAINALL
        LD HL,TRAIN_P
        CALL TRAIN1
TREN    LD HL,TRAIN_P+1
        CALL TRAIN2
        INC HL
        JR TRAIN3

TRAIN1  LD DE,#48EB
        LD IX,#59EB
        PUSH HL
        LD A,(HL)
        CPL
        LD (HL),A
        OR A
        JR Z,TRM0
        INC A
        INC A
TRM0    ADD A,4
        JR TRM2

TRAIN2  LD DE,#504D
        LD IX,#5A4D
TR0     PUSH HL
        LD A,(HL)
        CPL
        LD (HL),A
        OR A
        JR Z,TRM1
        INC A
        INC A
TRM1    ADD A,2
TRM2    CALL OUT_SPR
        POP HL
        RET

TRAIN3  LD DE,#50AE
        LD IX,#5AAE
        JR TR0

OUT_SPR HALT
OUT_SPR1
        ADD A,A
        LD L,A
        LD H,#80
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        PUSH BC
        SLA B
        SLA B
        SLA B
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

        POP BC
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
ENDCOD  DISPLAY "End of code: ",ENDCOD

        DS #FF,#C9
        ORG #8000
        INCBIN "TR_SPRIT"
TRAIN_P DB #FF,#FF,#FF
LOADPP
        DISP #5D3B

;АДРЕС БУФФЕРА ДЛЯ РАСПАКОВКИ.
TableAdr       EQU #F800;[#05C0]
Tree1Adr       EQU TableAdr+#0000;[#0480]
Tree2Adr       EQU TableAdr+#0480;[#0080]
BitLenTb1      EQU TableAdr+#0480;[#0120]
BitLenTb2      EQU TableAdr+#05A0;[#0020]

LOAD    EI
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
        RET

DEP            LD D,H
               LD E,L

DEPACK         PUSH DE
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
               CALL CHPURK
               DEC H
               JR NZ,$-6-3
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

CHPURK  JR NCHPURK
CHP_SW  EQU $-1
        PUSH AF
        BIT 2,A
        JR Z,CHP_M
        LD A,1+16
        OUT (#FE),A
CHP_M   LD A,7
        OUT (#FE),A
        POP AF
NCHPURK RET


TABL    EQU #F800
FADE0   LD HL,TABL
        LD B,L
FAD_LP  LD D,L
        LD A,D
        AND 1+2+4
        OR A
        JR Z,NODINK
        DEC D
NODINK  LD A,D
        AND 8+16+32
        OR A
        JR Z,NODPAP
        LD A,D
        SUB 8
        LD D,A
NODPAP  LD (HL),D
        INC L
        DJNZ FAD_LP
        LD C,8
FAD_LL  HALT
        HALT
        HALT
        HALT
        LD A,(#5B00)
        OUT (#FE),A
        LD (STEK),SP
        LD SP,#5800
        LD B,#C1
        LD H,TABL/#100
FAD_L1  POP DE
        LD L,E
        LD E,(HL)
        LD L,D
        LD D,(HL)
        PUSH DE
        POP DE
        POP DE
        LD L,E
        LD E,(HL)
        LD L,D
        LD D,(HL)
        PUSH DE
        POP DE
        DJNZ FAD_L1
        LD SP,#3131
STEK    EQU $-2
        DEC C
        JR NZ,FAD_LL
        RET

TRDOS   PUSH HL
        LD A,#FF
        LD (#5D15),A
        LD (#5D17),A
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
        EX AF,AF'
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
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR NZ,NO_ERR
        LD A,L
        CP #10
        JR Z,DERR
NO_ERR  POP AF
        EX (SP),HL
        RET
RIA     DUP 3
        POP  HL
        EDUP
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F
        ENT
ELOADPP
SCR     INCBIN "$.R"
MDATA   INCBIN "MDAT1"
MDATA2  INCBIN "MDAT2"
EMDATA
ZAZA    DISPLAY "SAVE [fname],#7E00,",ZAZA-#7F00
        ORG #7E00
