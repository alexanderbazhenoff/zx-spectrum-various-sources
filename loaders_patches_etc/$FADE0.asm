; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

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