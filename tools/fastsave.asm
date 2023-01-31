; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

; TR-DOS Fast saver (use VG chip and TR-DOS ROM directrly instead of #3D13 entry point)
        ORG #8000
        DI
        LD DE,#0100
TRSC    EQU $-2
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
        LD IX,#2D73
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
LL5B5F  LD (TRSC),DE
        RET
DOS     PUSH IX
        JP #3D2F
