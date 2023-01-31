; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

CHEAT   EQU #FF         ;0 - cheat off

        ORG #5B14
        DB CHEAT

        ORG #60AE
        INCBIN "sarlmoor"

        ;clear original ROM font
        ORG #FCB2
        DUP #130
        DB 0
        EDUP

        ;clear data garbage
        ORG #FEAE
        DUP #100
        DB 0
        EDUP

        ORG #60AE
        DUP 4
        DB 0
        EDUP
        ORG #60B8
        DI

        ;correct CLS
        MACRO CLS
        CALL #7CC3
        CALL #7CE1
        ENDM
        ORG #C219
        CLS
        ORG #C268
        CLS
        ORG #C3AC
        CLS
        ORG #C484
        CLS
        ORG #7CC3
        CALL CLS0002
        ORG #7CD2
        CALL CLS0002
        ORG #7CE1
        LD HL,#5800
        XOR A
CLS0001 DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLS0001
        RET
CLS0002 EI
        HALT
        LD HL,#5800
        RET

        ;correct 'game over' & 'congratulations' string routines
        ORG #C4E5
        CALL KPAUS11
KPAUS12 CALL KEY_RQ
        JR Z,KPAUS12
        RET
        ORG #C519
        JR #C4E5

        ;correct 'slides' routines
        ORG #C98E
GR_MTK  LD B,7
GR_MTK0 EI
        HALT
        JR #C9A0
        DUP 6
        DB 0
        EDUP

        ORG #C6AE
        LD B,6
        ORG #C6D1
        LD B,6
        ORG #C6F4
        LD B,6
        ORG #C717
        LD B,6
        ORG #C739
        LD B,6

        ORG #C918
        CALL SYNCP01
        LD B,15
        ORG #C92A
        CALL SYNCP01
        LD B,15
        ORG #C93C
        CALL SYNCP01
        LD B,15
        ORG #C94E
        CALL SYNCP01
        LD B,15
        ORG #C962
        CALL SYNCP01
        LD B,15

        ;correct border colour on the start of this program
        ORG #60B9
        CALL #7CB2

        ;optimizing sprite output routines
        ORG #CA3A
        OR A
        RET Z
        LD C,A
        ADD HL,BC
        JR #CA19
        DUP 5
        DB 0
        EDUP

        ORG #CA02
        LD B,22
PAUS000 EI
        HALT
        DJNZ PAUS000
        RET
KEY_RQ  XOR A
KEY_RQ1 IN A,(#FE)
        CPL
        AND #1F
        RET

        ORG #6000
        LD A,(#5B14)
        OR A
        JR Z,NOCHEAT
        XOR A
        LD H,A
        LD L,A
        LD (#9E48+1),HL
        LD (#9EEF+1),HL
        LD (#87C2+1),HL
        LD (#AE92+1),HL
        LD (#9E48),A
        LD (#9EEF),A
        LD (#87C2),A
        LD (#AE92),A
        LD A,#C9
        LD (#AE1D),A
        LD (#BC83),A
        LD A,#B7
        LD (#A342),A
        LD HL,#82B0
        LD DE,#82B1
        LD BC,#8395-#82B0
        LD (HL),B
        LDIR
        LD A,#CD
        LD (#9D9F),A
        LD (#9DE2),A
        LD (#AEEE),A
        LD (#B764),A
        LD (#AEA9),A

        LD HL,SYNCP02
        LD (#AEA9+1),HL

        LD HL,SKPLEV1
        LD (#9D9F+1),HL
        LD (#9DE2+1),HL
        LD HL,SKPLEV2
        LD (#AEEE+1),HL
        LD HL,SKPLEV3
        LD (#B764+1),HL

NOCHEAT JR #60B2
SYNCP01
        EI
        HALT
        LD BC,#700
        CALL SYNCPL
        JP #CA19
SYNCP02 LD BC,#700
SYNCPL  DEC BC
        LD A,B
        OR C
        JR NZ,SYNCPL
        RET

KPAUS11 CALL KEY_RQ
        JR NZ,KPAUS11
        RET

CHEATK  LD A,#FB
        CALL KEY_RQ1
        CP 4+8+16
        RET

SKPLEV1 CALL CHEATK
        LD A,(#6822)
        RET NZ
        LD A,1
        RET
SKPLEV2 CALL CHEATK
        LD A,(#6822)
        RET NZ
        LD A,2
        LD (#6D94),A
        DEC A
        RET
SKPLEV3 CALL CHEATK
        LD A,(#6822)
        RET NZ
        LD A,4
        LD (#60E1),A
        LD A,1
        RET
        RET

