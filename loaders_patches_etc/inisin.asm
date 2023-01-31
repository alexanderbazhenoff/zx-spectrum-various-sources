; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6000
        LD D,#80
        LD HL,SINTAB-1
        LD E,#FF
        LD BC,#06FA
INS     INC E
        LD A,E
        AND 3
        JR NZ,$+3
        INC HL
        XOR A
        RLC (HL)
        RLA
        RLC (HL)
        RLA
        DEC A
        ADD A,B
        LD B,A
        ADD A,C
        LD C,A
        CALL INSR
        PUSH DE
        LD A,#80
        SUB E
        LD E,A
        LD A,C
        CALL INSR
        POP DE
        BIT 6,E
        JR Z,INS
        RET
INSR    LD (DE),A
        SET 7,E
        NEG
        LD (DE),A
        INC D
        SBC A,A
        LD (DE),A
        RES 7,E
        XOR A
        LD (DE),A
        DEC D
        RET
SINTAB  DD #5856155549218552215488548552154855