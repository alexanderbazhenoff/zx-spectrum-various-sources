; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #8000

        DISP #5D3B
        DB 0,1,#FF,#FF
        DB #F0,#C0,#B0,#22,"23922",#22; ,":",#EA
        DB #16,0,0
        DB #13,1,#10,7,#11,1
        DB "  Loader by Alx/BW 04.11.2001  ",#10

        DI
        LD SP,#6100
CLS     XOR A
        OUT (#FE),A
        LD HL,#5B00
CLS_L   DEC HL
        LD (HL),A
        OR (HL)
        JR Z,CLS_L
        LD HL,40000
        LD B,3
        CALL LOAD
        CALL 40000
        LD HL,25500
        LD B,#11
        CALL LOAD
        LD B,#80
PAUSE   EI
        HALT
        LD A,#FE
        IN A,(#FE)
        BIT 3,A
        JR NZ,NOCHEAT
        XOR A
        LD (CHEAT),A
NOCHEAT LD A,#DF
        IN A,(#FE)
        RRA
        JR C,NOFIX
        XOR A
        LD (FIX),A
NOFIX   DJNZ PAUSE
        CALL 25500
        LD A,#14
        CALL BANK
        LD HL,#C000
        LD B,#0A
        CALL LOAD
        LD A,#10
        CALL BANK
        LD HL,#6100
        LD B,#5E
        CALL LOAD1
        CALL #6100

        JR NO_C
CHEAT   EQU $-1
        XOR A
        LD (45600),A
        LD A,#C9
        LD (49941),A
NO_C    JR NO_F
FIX     EQU $-1
        LD A,#55
        LD (#9902),A
        LD HL,#1D6
        LD (#98BC),HL
        LD (#98C5),HL
        LD HL,#2AB
        LD (#9952),HL
        LD HL,MULDAT
        LD DE,#9967
        LD BC,#25
        LDIR
NO_F    JP #FF00

;АДРЕС БУФФЕРА ДЛЯ РАСПАКОВКИ.
TableAdr       EQU #F000;[#05C0]
Tree1Adr       EQU TableAdr+#0000;[#0480]
Tree2Adr       EQU TableAdr+#0480;[#0080]
BitLenTb1      EQU TableAdr+#0480;[#0120]
BitLenTb2      EQU TableAdr+#05A0;[#0020]

LOAD    PUSH HL
        CALL LOAD1
        POP HL

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

LOAD1   LD DE,(#5CF4)
        LD C,5
TR_DOS  PUSH HL
        PUSH DE
        PUSH BC
        CALL TRDOS
        DI
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        RET Z
        JR TR_DOS

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

BANK    DI
        LD BC,#7FFD
        OUT (C),A
        RET

MULDAT  INCBIN "MUL"
        DB #0D
        ENT

ENDOBJ  DISPLAY ENDOBJ

