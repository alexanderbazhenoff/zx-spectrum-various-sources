; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG 25000
        DI
        LD SP,#5E00
        LD B,#FF
BRDM    PUSH BC
        LD A,B
        LD (PAUPAR+1),A
        LD L,#40
        LD A,R
        AND #3F
        LD H,A
BRD     LD A,R
        XOR (HL)
        OUT (#FE),A
        XOR A
        OUT (#FE),A
        LD A,R
        XOR (HL)
PAUPAR  AND 0
        LD B,A
        INC B
PAUSB   DJNZ PAUSB
        DEC L
        JR NZ,BRD
        POP BC
        DJNZ BRDM

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
        DI
        LD HL,JAJA
        LD DE,#4000
        LD BC,COD_BL-JAJA
        PUSH DE
        JP #33C3
JAJA
        DISP #4000
        LD HL,COD_BL
        LD DE,#5E00
        LD BC,#9470
        LDIR
        JR NO_UL
        LD A,#B7
        LD (#E0AA),A
NO_UL   JR NO_UT
        LD A,#C9
        LD (#A5A5),A
NO_UT   JR NO_I
        LD A,#C9
        LD (#D3EB),A
NO_I    JR NO_OOF
        LD A,#C9
        LD (#D3EB),A
        LD (#CE84),A
NO_OOF  JR NO_IGK
        LD HL,DATA
        LD DE,#5B00
        LD BC,#002A
        LDIR
        LD A,#C3
        LD (#CE39),A
        LD HL,#5B00
        LD (#CE3A),HL
NO_IGK  JR NO_FE
        LD A,#CD
        LD (#CD44),A
NO_FE   LD BC,#7FFE
        IN A,(C)
        BIT 4,A
        JR NZ,NO_KE
        LD B,#FB
        IN A,(C)
        BIT 1,A
        JR NZ,NO_KE
        XOR A
        LD (#CD44),A
        LD H,A
        LD L,A
        LD (#CD45),A
        LD A,7
        OUT (#FE),A
        LD BC,#5000
PAUSC   DEC BC
        LD A,B
        OR C
        JR NZ,PAUSC
        XOR A
        OUT (#FE),A
NO_KE   JP #5E00
DATA    CALL #E4CC
        PUSH BC
        PUSH AF
        LD BC,#DFFE
        IN A,(C)
        RRA
        JR C,NOSKIP
        LD B,#BF
        IN A,(C)
        BIT 1,A
        JR NZ,NOSKIP
        BIT 4,A
        JR NZ,NOSKIP
        LD B,#FB
        IN A,(C)
        BIT 2,A
        JR NZ,NOSKIP
        XOR A
        LD (#B542),A
NOSKIP  POP AF
        POP BC
        JP #CE3C

        ENT
COD_BL  INCBIN "CODE"
ENDCODE
