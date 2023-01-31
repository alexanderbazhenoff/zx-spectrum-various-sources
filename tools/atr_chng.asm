; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #CD78
ATTR    EQU 9

        LD HL,#596B
        LD DE,#16
        LD BC,#0A02
ATRC_L0 HALT
        PUSH BC
        PUSH HL
ATRC_L1 PUSH BC
ATRC_L2 LD (HL),ATTR
        INC HL
        DJNZ ATRC_L2
        ADD HL,DE
        POP BC
        DEC C
        JR NZ,ATRC_L1
        POP HL
        XOR A
        LD BC,#21
        SBC HL,BC
        POP BC
        DEC E
        DEC E
        INC B
        INC B
        INC C
        INC C
        LD A,C
        CP #1A
        JR NZ,ATRC_L0
        HALT
        LD A,ATTR&7
        OUT (#FE),A
        RET