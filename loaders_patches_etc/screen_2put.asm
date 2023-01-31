; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

STARTADR        EQU #6000

        ORG STARTADR
        LD HL,SCREEN+#1800+#180
        LD DE,#5980
        LD B,#C
OUT_1   PUSH BC
        PUSH DE
        PUSH HL
        EI
        HALT
        LD HL,SCREEN+#58
REG_HL1 EQU $-2
        LD DE,#4860
REG_DE1 EQU $-2
        CALL OUT_SR1
        DUP 8
        DEC HL
        EDUP
        LD A,E
        SUB #20
        LD E,A
        JR NC,MTK1
        LD A,D
        SUB 8
        LD D,A
MTK1    LD (REG_HL1),HL
        LD (REG_DE1),DE

        LD HL,SCREEN+#1800+#160
REG_HL3 EQU $-2
        LD DE,#5960
REG_DE3 EQU $-2
        PUSH HL
        PUSH DE
        LD C,#20
        PUSH BC
        LDIR
        POP BC
        POP DE
        POP HL
;       XOR A
        SBC HL,BC
        EX DE,HL
        SBC HL,BC
;       EX DE,HL
        LD (REG_DE3),HL
        LD (REG_HL3),DE

        LD HL,SCREEN+#60
REG_HL2 EQU $-2
        LD DE,#4880
REG_DE2 EQU $-2
        CALL OUT_SR1
        DUP 8
        INC HL
        EDUP
        LD A,E
        ADD A,#20
        LD E,A
        JR NZ,MTK2
        LD A,D
        ADD A,8
        LD D,A
MTK2    LD (REG_HL2),HL
        LD (REG_DE2),DE

        POP HL
        POP DE
        LD C,#20
        LDIR

        POP BC
        DJNZ OUT_1
        RET

OUT_SR1 PUSH HL
        PUSH DE
        LD BC,#20B9
OUT_SRL PUSH BC
        PUSH DE
        DUP 7
        LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        EDUP
        LD A,(HL)
        LD (DE),A
        POP DE
        INC DE
        LD B,0
        ADD HL,BC
        POP BC
        DJNZ OUT_SRL
        POP DE
        POP HL
        RET

SCREEN  INCBIN "PICTURE"
END_OBJECT      DISPLAY "lenght: ",END_OBJECT-STARTADR
