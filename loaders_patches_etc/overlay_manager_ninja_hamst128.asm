; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

 DISPLAY "OVERLAY MANAGER FOR NINJA HAMSTER GAME. 128K MODE"
        ORG #FF00
        DISP #4900
        DI
        LD (STEK),SP
        LD SP,#4900
        LD A,(#6D69)
        SRL A
        LD HL,TABL
        ADD A,L
        LD L,A
        PUSH IY
        PUSH HL
        POP IY
        LD HL,#E600
        LD BC,#A00
        CALL MOV_DEP
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
        LD HL,#C000
        LD BC,#2600
        CALL MOV_DEP
        LD HL,#F000
        LD IX,#FD38
        LD BC,#100
        CALL MOV
        POP IY
        LD SP,#3131
STEK    EQU $-2
        EI
        HALT
        NOP
        NOP
        NOP
        RET

TABL    DB #11+8,#13+8,#14+8,#16+8

MOV_DEP LD IX,#C4E0
        PUSH IX
        CALL MOV
        POP HL
        JP #40B9

MOV     LD D,(IY)
        LD E,#18
        PUSH IY
        PUSH HL
        POP IY
        EX DE,HL
MOV_L   PUSH BC
        LD BC,#7FFD
        OUT (C),H
        LD A,(IY)
        OUT (C),L
        LD (IX),A
        INC IY
        INC IX
        POP BC
        DEC BC
        LD A,B
        OR C
        JR NZ,MOV_L
        POP IY
        RET

