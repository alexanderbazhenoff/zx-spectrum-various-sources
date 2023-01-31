; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #E7A7

        DI
        EXX
        PUSH HL
        LD HL,#2758
        EXX
        LD HL,#EA91
        LD DE,#5CDD
        LD BC,11
        LD A,C
        LD (23814),A
        LDIR
        LD C,#A
        CALL #E042
        LD A,(23823)
        CP C
        JR Z,NO_ERF
        OR A
        JR NZ,ERROR
NO_ERF  LD A,C
        CP #FF
        JR Z,ERROR
        LD C,8
        CALL #E042
        LD A,(23823)
        OR A
        JP NZ,ERROR
        LD DE,(#5CEB)
        LD HL,#5FB4
        LD BC,#5F05
        CALL DOS_NB
        LD DE,(#5CF4)
        LD HL,#5D3B
        LD BC,#0105
        PUSH HL
        CALL DOS_NB
        POP HL
        LD DE,#BEB4
        LD BC,#00E2
        LDIR
EXIT    DI
        EXX
        POP HL
        EXX
        EI
        RET
DOS_NB  PUSH HL
        PUSH DE
        PUSH BC
        CALL #3D13
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        RET Z
        JR DOS_NB
ERROR   CALL ERR1
        JR EXIT
ERR1    EI
        HALT
        LD A,2
        OUT (#FE),A
        LD B,#40
        CALL #D43D
        RET
ZUZU    DISPLAY "#E7A7...",ZUZU,"=",ZUZU-#E7A7," bytes"
