; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6000+#8E00
        INCLUDE "BORDER"
        INCLUDE "$FADE0"
        DI
        LD HL,TEST
        LD DE,#4000
        LD BC,#20
        LDIR
        CALL #4000
        JR NZ,MODE128
        LD HL,LOAD
        LD DE,#5B00
        LD BC,#80
        LDIR
        JR START
MODE128 LD HL,ZUZU
        LD DE,#B71B
        LD BC,#10
        LDIR
START   LD HL,#A784
        PUSH HL
        LD HL,#6000+#8E00
        LD DE,#6000+#8E01
        LD BC,#FFFF-#6000-#8E00
        JP #33C3

ZUZU    DI
        IM 1
        LD BC,#7FFD
        LD A,#11
        OUT (C),A
        JP #C000

LOAD
        DISP #5B00
        DI
        LD HL,#5800
        LD B,L
        LD A,L
CLS     LD (HL),A
        INC HL
        DJNZ CLS
        LD HL,#C000
        LD DE,0
        LD B,#20
LL5B1C  PUSH BC
        PUSH DE
        LD A,D
        OR A
        RRA
        LD C,A
        LD A,#3C
        JR NC,LL5B28
        LD A,#2C
LL5B28  LD IX,#1FF3
        CALL DOS
        LD A,C
        LD C,#7F
        LD IX,#2A53
        CALL DOS
        LD A,#18
        LD IX,#2FC3
        CALL DOS
        POP DE
        POP BC
LL5B44  PUSH BC
        PUSH DE
        LD IX,#2F1B
        CALL DOS
        POP DE
        INC H
        INC E
        BIT 4,E
        JR Z,LL5B5C
        LD E,#0
        INC D
        POP BC
        DJNZ LL5B1C
        JR LL5B5F
LL5B5C  POP BC
        DJNZ LL5B44
LL5B5F  CALL #C000
        JP #C000
DOS     PUSH IX
        JP #3D2F

TEST    LD HL,#FFFF
        LD DE,#1011
        LD BC,#7FFD
        OUT (C),D
        LD (HL),D
        OUT (C),E
        LD (HL),E
        OUT (C),D
        CP E
        RET
