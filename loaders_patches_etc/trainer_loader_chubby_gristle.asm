; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #7F00
        DISPLAY "TRAINER AND LOADER 4 Chubby Gristle by Alx/BW"
        DISPLAY "18.06.2002"
        HALT
        XOR A
        OUT (#FE),A
        LD HL,#5B00
CLS1    DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLS1
        LD DE,#5040
        LD IX,#5A40
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
        POP AF
        CP #0D
        CALL Z,TRAINALL
        CP " "
        JR Z,START
        CP "0"
        JR Z,START
        JR KEYSCAN
START   HALT
        LD HL,#5A00
        LD A,L
        LD B,A
CLS13L  LD (HL),A
        INC L
        DJNZ CLS13L
        LD DE,#50A0
        LD IX,#5AA0
        LD A,1
        CALL OUT_SPR1
        LD HL,LOADPP
        LD DE,#5D3B
        LD BC,ELOADPP-LOADPP
        LDIR
        LD HL,TRAIN_P
        LD A,(HL)
        OR A
        JR Z,NOTR1
        CPL
        LD (TR_PO1),A
NOTR1   INC HL
        LD A,(HL)
        OR A
        JR Z,NOTR2
        CPL
        LD (TR_PO2),A
NOTR2   JP #5D3B
        ENT

TRAINALL
        LD HL,TRAIN_P
        CALL TRAIN1
        INC HL
        JR TRAIN2

TRAIN1  LD DE,#504A
        LD IX,#5A4A
TR0     PUSH HL
        LD A,(HL)
        CPL
        LD (HL),A
        OR A
        JR Z,TRM1
        INC A
        INC A
TRM1    ADD A,2
        CALL OUT_SPR
        POP HL
        RET

TRAIN2  LD DE,#50AD
        LD IX,#5AAD
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
TRAIN_P DB #FF,#FF
LOADPP
        DISP #5D3B

;АДРЕС БУФФЕРА ДЛЯ РАСПАКОВКИ.
TableAdr       EQU #FA00;[#05C0]
Tree1Adr       EQU TableAdr+#0000;[#0480]
Tree2Adr       EQU TableAdr+#0480;[#0080]
BitLenTb1      EQU TableAdr+#0480;[#0120]
BitLenTb2      EQU TableAdr+#05A0;[#0020]

        LD SP,25500
        LD HL,#9C40
        LD B,#11
        CALL LOAD1
        LD HL,25500
        LD B,87
        CALL LOAD
        XOR A
        JR NOTRN1
TR_PO1  EQU $-1
        LD (25631),A
NOTRN1  JR NOTRN2
TR_PO2  EQU $-1
        LD (25625),A
NOTRN2  LD A,#BF
        IN A,(#FE)
        RRA
        JR NC,NOTRN2
        JP 25500


LOAD1   PUSH HL
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
        DI

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
               DEC H
               JR NZ,$-6
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

CLS2    OUT (#FE),A
        LD HL,#5B00
CLSL2   DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLSL2
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
ZAZA    DISPLAY "SAVE [fname],#7F00,",ZAZA-#7F00
        ORG #7F00
