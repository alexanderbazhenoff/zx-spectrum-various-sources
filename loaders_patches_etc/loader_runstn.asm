; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #8000

        DISP #5D3B
        DB 0,1,#FF,#FF
        DB #20,#F0,#20,#C0,0,0,0,#0E,0,0,#76,#5D,0;
        DB #16,0,0
        DB #13,1,#10,7,#11,1
        DB " loader by beer drunker @lx :-) "
        DB #10

        LD SP,#6140
        LD A,9
        LD (23693),A
        LD (23624),A
        CALL 3435
        XOR A
        CALL 5633
        LD HL,TEXT
PRNTLP  LD A,(HL)
        OR A
        JR Z,END
        LD D,A
        LD A,1+16
SOUNDL1 OUT (#FE),A
        LD B,D
SOUNDL2 DJNZ SOUNDL2
        LD A,1
        OUT (#FE),A
        LD B,D
SOUNDL3 DJNZ SOUNDL3
        LD A,D
        RRCA
SOPAUS1 LD B,A
SOPAUS2 DJNZ SOPAUS2
        DEC A
        JR NZ,SOPAUS1
        LD A,D

        PUSH HL
        RST #10
        POP HL
        INC HL
        JR PRNTLP
END     LD B,#150
PAUS    HALT
        DJNZ PAUS
        LD HL,#5800
        LD DE,#5801
        LD BC,#02FF
        LD (HL),9
        LDIR

        LD HL,#9C40
        LD B,8
        CALL LOADDR
        LD B,#54
        LD HL,#6705
        CALL LOAD
        HALT
        XOR A
        OUT (#FE),A
        LD HL,#5800
        PUSH HL
        LD DE,#5801
        LD BC,#02FF
        LD (HL),A
        LDIR
        POP HL
CLSL2   DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLSL2
        DI
        LD DE,#FDE8
        LD HL,#5DC0
        LD SP,HL
        PUSH DE
        LD DE,#5DC1
        LD BC,#0944
        LD (HL),0
        JP #33C3


;АДРЕС БУФФЕРА ДЛЯ РАСПАКОВКИ.
TableAdr       EQU #6140;[#05C0]
Tree1Adr       EQU TableAdr+#0000;[#0480]
Tree2Adr       EQU TableAdr+#0480;[#0080]
BitLenTb1      EQU TableAdr+#0480;[#0120]
BitLenTb2      EQU TableAdr+#05A0;[#0020]

LOADDR  PUSH HL
LOAD    LD DE,(#5CF4)
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

TEXT    DB #11,1,#10,7
        DB "  Softlock ",#10,5,"protection ",#10,2,"cracked,  "
        DB " packed ",#10,5
        DB "and ",#10,7,"'fast disk version' ",#10,5
        DB "  by ",#10,2
        DB "mad beer-drunker ",#10,7,"@lx! :-)",0

        DB #0D
        ENT

ENDOBJ  DISPLAY ENDOBJ

