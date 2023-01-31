; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

 DISPLAY "OVERLAY MANAGER FOR NINJA HAMSTER GAME. 48K MODE"
        ORG #6000
        DISP #4000
LOAD48  EI
        LD DE,TEXT
        LD BC,TEXT2-TEXT
        CALL #203C
        DI
        LD (STEK),SP
        LD SP,#4900
        LD A,(#6D69)
        SRL A
        PUSH AF
        ADD A,#31
        RST #10
        POP AF
        ADD A,A
        ADD A,A
        LD IX,TABL
        LD D,0
        LD E,A
        ADD IX,DE
        LD A,(IX)
        OR A
        JR Z,NO_ASEC
        LD B,A
        LD HL,(#5CF4)
ASEC_L  INC L
        BIT 4,L
        JR Z,NO_AT
        INC H
        LD L,D
NO_AT   DJNZ ASEC_L
        LD (#5CF4),HL
NO_ASEC PUSH IX
        CALL LOAD_DA
        LD HL,#C4E0
        LD DE,#6590
        LD BC,#1A9
        PUSH BC
        LDIR
        LD HL,#C6E0
        LD DE,#A12C
        POP BC
        LDIR
        LD HL,#C8E0
        LD DE,#AF32
        LD C,#85
        LDIR
        LD HL,#C9E0
        LD DE,#B3B0
        LD BC,#6FF
        LDIR
        POP IX
        INC IX
        CALL LOAD_DA
        LD BC,#105
        LD HL,#FD38
        LD DE,(#5CF4)
        CALL #C31B
        LD HL,#5A00
        LD B,L
CLS3_L  LD (HL),18
        INC HL
        DJNZ CLS3_L
        LD SP,#3131
STEK    EQU $-2
        LD HL,#4000
        LD DE,#4001
        LD BC,#17FF
        LD (HL),L
        JP #33C3

TABL    DB #0,10,40,0
        DB 51,10,36,0
        DB 98,#9,40,0
        DB 148,9,40

LOAD_DA LD HL,#D4E0
        LD B,(IX+1)
LOAD    PUSH HL
        LD C,5
        LD DE,(#5CF4)
        CALL #C31E
        POP HL
        LD DE,#C4E0

DEHRUST PUSH DE
        PUSH HL
        INC HL
        INC HL
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        DEC BC
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        LD C,(HL)
        INC HL
        LD B,(HL)
        DEC BC
        POP HL
        ADD HL,BC
        SBC HL,DE
        ADD HL,DE
        JR C,LL4019
        LD D,H
        LD E,L
LL4019  LDDR
        EX DE,HL
        POP DE
        LD C,#0C
        ADD HL,BC
        PUSH HL
        POP IX
        LD A,#03
LL4025  DEC HL
        LD B,(HL)
        DEC HL
        LD C,(HL)
        PUSH BC
        DEC A
        JR NZ,LL4025
        LD B,A
        EXX
        LD D,#BF
        LD C,#10
        CALL LL4115
LL4036  LD A,(IX+#00)
        INC IX
        EXX
LL403C  LD (DE),A
        INC DE
LL403E  EXX
LL403F  ADD HL,HL
        DJNZ LL4045
        CALL LL4115
LL4045  JR C,LL4036
        LD E,#01
LL4049  LD A,#80
LL404B  ADD HL,HL
        DJNZ LL4051
        CALL LL4115
LL4051  RLA
        JR C,LL404B
        CP #03
        JR C,LL405D
        ADD A,E
        LD E,A
        XOR C
        JR NZ,LL4049
LL405D  ADD A,E
        CP #04
        JR Z,LL40C4
        ADC A,#FF
        CP #02
        EXX
LL4067  LD C,A
LL4068  EXX
        LD A,#BF
        JR C,LL4082
LL406D  ADD HL,HL
        DJNZ LL4073
        CALL LL4115
LL4073  RLA
        JR C,LL406D
        JR Z,LL407D
        INC A
        ADD A,D
        JR NC,LL4084
        SUB D
LL407D  INC A
        JR NZ,LL408D
        LD A,#EF
LL4082  RRCA
        CP A
LL4084  ADD HL,HL
        DJNZ LL408A
        CALL LL4115
LL408A  RLA
        JR C,LL4084
LL408D  EXX
        LD H,#FF
        JR Z,LL409B
        LD H,A
        INC A
        LD A,(IX+#00)
        INC IX
        JR Z,LL40A6
LL409B  LD L,A
        ADD HL,DE
        LDIR
LL409F  JR LL403E
LL40A1  EXX
        RRC D
        JR LL403F
LL40A6  CP #E0
        JR C,LL409B
        RLCA
        XOR C
        INC A
        JR Z,LL40A1
        SUB #10
LL40B1  LD L,A
        LD C,A
        LD H,#FF
        ADD HL,DE
        LDI
        LD A,(IX+#00)
        INC IX
        LD (DE),A
        INC HL
        INC DE
        LD A,(HL)
        JP LL403C
LL40C4  LD A,#80
LL40C6  ADD HL,HL
        DJNZ LL40CC
        CALL LL4115
LL40CC  ADC A,A
        JR NZ,LL40F3
        JR C,LL40C6
        LD A,#FC
        JR LL40F6
LL40D5  LD B,A
        LD C,(IX+#00)
        INC IX
        CCF
        JR LL4068
LL40DE  CP #0F
        JR C,LL40D5
        JR NZ,LL4067
        LD B,#03
        EX DE,HL
LL40E7  POP DE
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        DJNZ LL40E7
        LD HL,#2758
        EXX
        RET
LL40F3  SBC A,A
        LD A,#EF
LL40F6  ADD HL,HL
        DJNZ LL40FC
        CALL LL4115
LL40FC  RLA
        JR C,LL40F6
        EXX
        JR NZ,LL40B1
        BIT 7,A
        JR Z,LL40DE
        SUB #EA
        ADD A,A
        LD B,A
LL410A  LD A,(IX+#00)
        INC IX
        LD (DE),A
        INC DE
        DJNZ LL410A
        JR LL409F
LL4115  LD B,C
        LD L,(IX+#00)
        INC IX
        LD H,(IX+#00)
        INC IX
        RET
LCODE   EQU $-DEHRUST
TEXT    DB #10,7,#11,2," BLOCK "
TEXT2
ENDOBJ  DISPLAY ENDOBJ
