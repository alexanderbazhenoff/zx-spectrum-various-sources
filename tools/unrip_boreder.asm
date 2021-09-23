;Распаковщик RIP'а.
;Длина #121 (289) байт
;Во время распаковки используется буффер
;длиной #5C0 (1472) байта
;адрес начала буфера задается
;переменной TableAdr
;Для распаковки требуется занести
;в HL адрес начала запакованной
;инфорации;
;в DE занести адрес распаковки
;пример
               LD HL,SOURCE
               LD DE,DESTINATION
               CALL Depack
               RET 

BORDER  EQU 1           ;если 0, то бордюрных трещалок нет
MASK    EQU 1+2+4+8+16
MASKOR  EQU 2
DEPBUF  EQU #FA40


;Надеюсь, все понятно.


;----------------------------------
;НАЧАЛО РАСПАКОВЩИКА
;----------------------------------
;АДРЕС БУФФЕРА ДЛЯ РАСПАКОВКИ.
TableAdr       EQU #5000;[#05C0]
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
               JR C,MoveBlk
               LD D,H
               LD E,L
MoveBlk        LDDR 
               INC DE

               PUSH DE
               POP IX

UnpackTree     LD DE,BitLenTb1-1
               PUSH DE
               LD BC,#1201
UnpackTreeL1   LD A,#10
UnpackTreeL0   SRL C
               CALL Z,GetNextByte
               RLA 
               JR NC,UnpackTreeL0
               INC DE
               LD (DE),A
               DJNZ UnpackTreeL1

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
GW_L0          PUSH AF
               CALL GetWord1
               DEC H
               JR NZ,GW_L0

UnpackWord     DEC DE
UnpW0          CALL GetWord1
               INC DE
               LD (DE),A

               IFN BORDER
               PUSH AF
               AND MASK
               OR MASKOR
               OUT (#FE),A
               XOR A
               OUT (#FE),A
               POP AF
               ENDIF 

               DEC H
               JR NZ,UnpW0
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
               JR C,UW0
               INC HL
               CP #20
               JR C,UW0
               INC HL
UW0            PUSH BC
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
               JR Stop

DecodeNum      ADD A,-#05
               RET NC
               ADD A,#05-#03
               RRA 
               LD L,#01
               RL L
DNum0          SRL C
               CALL Z,GetNextByte
               ADC HL,HL
               DEC A
               JR NZ,DNum0
               INC HL
               RET 

GetWord1       LD HL,Tree1Adr

GetWord        SRL C
               CALL Z,GetNextByte
               JR NC,GetW0
               INC HL
               INC HL
GetW0          LD A,(HL)
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


