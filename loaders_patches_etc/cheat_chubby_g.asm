; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #639C
        LD SP,#5FFF
        INCLUDE "BORDER"
        LD HL,#FF00
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
        LD A,R
        OUT (#FE),A
        XOR A
        OUT (#FE),A
        DJNZ FAD_LP
        EI
        LD B,8
FAD_LL  PUSH BC
        HALT
        HALT
        HALT
        HALT
        LD HL,#5800
        LD BC,#300
        LD D,#FF
FAD_L1  LD E,(HL)
        LD A,(DE)
        LD (HL),A
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,FAD_L1
        POP BC
        DJNZ FAD_LL
        LD HL,CHEATPP
        LD DE,#4000
        PUSH DE
        LD B,1
        LDIR
        LD HL,FILE
        LD DE,#6000
        LD B,#90
        JP #33C3
CHEATPP
        DISP #4000
        JR NO_IL
        LD A,#B6
        LD (#749B),A
NO_IL   JR NO_I
        LD A,#11
        LD (#8FC9),A
NO_I    LD BC,#7FFE
        IN A,(C)
        BIT 4,A
        JR NZ,NO_SI
        LD B,#FB
        IN A,(C)
        BIT 1,A
        JR NZ,NO_SI
        LD A,7
        OUT (#FE),A
PAUS    DEC BC
        LD A,B
        OR C
        JR NZ,PAUS
        LD HL,#7550
        LD (#7464),HL
        LD (#746B),HL
NO_SI   JP #714B

        ENT
FILE    INCBIN "CODE"
ENDFILE
