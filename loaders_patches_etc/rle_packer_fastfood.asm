; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

START   EQU #6000
LENGHT  EQU #9EFE
COMPRTO EQU #5F00 ;куда все упихивать

DEPPAR  EQU 1     ;if 0 - no depacker
DEPADR  EQU #5D3B ;depacker addr
AUTORUN EQU #FDFD ;#0052 - if none
DEPTO   EQU #6000

BT_TABL EQU #4600

        DISPLAY "on exit: IY=new lenght"

        ORG #6000
        DISP #4000
        LD A,DEPPAR
        JP COMPRES

        LD HL,#0000
COMP_BEG EQU $-2
        LD DE,#4000
        LD BC,#0000
COMPLEN EQU $-2
DECR_L  LD A,(HL)
        CP #00
PREFIX1C        EQU $-1
        SCF
        JR Z,DECR_SEQ
        CP #00
PREFIX2C        EQU $-1
        JR Z,DECR_SEQ
DECR_M1 LDI
        JP PE,DECR_L
DECREND JP #0052
DECR_SEQ
        EXA
        INC HL
        DEC BC
        LD A,(HL)
        OR A
        INC HL
        DEC BC
        JR Z,INST_PREFIX
        EXA
        LD A,0
        JR C,DECR_SEQ0
        LD A,(HL)
        INC HL
        DEC BC

DECR_SEQ0
        PUSH BC
        LD C,A
        EXA
        LD B,A
        LD A,C
DECR_SEQL2
        LD (DE),A
        INC DE
        DJNZ DECR_SEQL2
        POP BC
DECR_M3
        LD A,B
        OR C
        JR NZ,DECR_L
        JR DECREND

INST_PREFIX
        EXA
        LD (DE),A
        INC DE
        JR DECR_M3
DECR_ENDOF
        ;----

COMPRES DI
        LD (DEP_SW),A
        LD (DEP_SW2),A
        LD HL,COMPRTO
        BIT 0,A
        JR Z,NO_DEP1
        LD (HL),#21
        INC HL
        LD (DPR1),HL
        INC HL
        INC HL
        LD (HL),#11
        INC HL
        LD (HL),.DEPADR
        INC HL
        LD (HL),'DEPADR
        INC HL
        LD (HL),#01
        INC HL
        LD (HL),#38+4+5+1
        INC HL
        LD (HL),0
        INC HL

        LD (HL),#D5
        INC HL
        LD (HL),#ED
        INC HL
        LD (HL),#B0
        INC HL

        LD (HL),#21
        INC HL
        LD (DPR4),HL
        INC HL
        INC HL
        LD (HL),#11
        INC HL
        LD (DPR5),HL
        INC HL
        INC HL
        LD (HL),#01
        INC HL
        LD (DPR6),HL
        INC HL
        INC HL
        LD (HL),#C9
        INC HL
        LD (#0000),HL
DPR1    EQU $-2
        PUSH HL
        LD BC,#38+4+5+1
        ADD HL,BC
NO_DEP1 LD (CMPT_ADR),HL
        LD (COMP_BEG),HL

        XOR A
CNTBTL0 LD DE,0
        LD HL,START
        LD BC,LENGHT
CNTBTL  CP (HL)
        JR NZ,NO_ADD
        INC DE
NO_ADD  EXA
        INC HL
        DEC BC
        LD A,B
        OR C
        JR Z,CNTBT_END
        EXA
        JR CNTBTL
CNTBT_END
        EXA
        LD L,A
        LD H,'BT_TABL
        LD (HL),D
        INC H
        LD (HL),E
;       DEC H
        INC A
        JR NZ,CNTBTL0

        LD D,A
        LD E,A
        CALL SRCH_MIN
        LD (PREFIX1A),A ;min
        LD (PREFIX1B),A
        LD (PREFIX1C),A
        INC A
        CALL SRCH_MIN
        LD (PREFIX2A),A ;max
        LD (PREFIX2B),A
        LD (PREFIX2C),A

        LD IY,0 ;NEW LEN

        LD IX,START
        LD HL,0
CMPT_ADR EQU $-2
        LD BC,LENGHT

COMPRL0 LD A,(IX)
        CP #00
PREFIX1A        EQU $-1
        JR Z,CMP_PREFIX
        CP #00
PREFIX2A        EQU $-1
        JR Z,CMP_PREFIX
        CP (IX+1)
        JR Z,SEQ_CHK
CMP_M3  LD (HL),A
CMP_M1  INC IY
        INC IX
        INC HL
        DEC BC
CMP_M2  LD A,B
        OR C
        JR NZ,COMPRL0
        LD (COMPLEN),IY
        LD A,#00
DEP_SW2 EQU $-1
        OR A
        JR Z,NO_DDDEP
        LD (#0000),HL
DPR4    EQU $-2
NO_DDDEP
        POP HL
        LD A,#00
DEP_SW  EQU $-1
        OR A
        RET Z
        LD IX,DEPTO
        LD BC,LENGHT
        ADD IX,BC
        LD (#0000),IX
DPR5    EQU $-2
        PUSH IY
        POP BC
        INC IY
        LD (#0000),IY
DPR6    EQU $-2
        LD (HL),#ED
        INC HL
        LD (HL),#B8
        INC HL
        LD (HL),#13
        INC HL
        LD (HL),#EB
        INC HL
        LD (HL),#11
        INC HL
        LD (HL),.DEPTO
        INC HL
        LD (HL),'DEPTO
        INC HL
        LD (HL),#01
        INC HL
        LD (HL),C
        INC HL
        LD (HL),B
        INC HL
        EX DE,HL
        LD HL,DECR_L
        LD BC,DECREND-DECR_L-2
        LDIR
        EX DE,HL

        LD BC,DEPADR+#A
        LD (HL),C
        INC HL
        LD (HL),B
        INC HL
        EX DE,HL
        INC HL
        INC HL
        LD BC,DECR_ENDOF-DECREND
        LDIR
        LD BC,#58
        ADD IY,BC
        RET
        NOP
        NOP

CMP_PREFIX
        LD (HL),A
        INC IY
        INC HL
;       LD (HL),0
;       INC IY
;       INC HL
        LD (HL),0
        JR CMP_M1

SEQ_CHK
        PUSH IX
        INC IX
        LD E,1
SEQ_CHKL1
        CP (IX)
        JR NZ,SEQ_CHK_E
        INC IX
        INC E
        JR NZ,SEQ_CHKL1
        DEC E
SEQ_CHK_E
        POP IX
        LD D,A
        OR A
        LD A,2
        JR Z,SEQ_0
        INC A
SEQ_0   CP E
        JR NC,CMP_MM1

        LD A,D
        LD D,#00
PREFIX1B        EQU $-1
        OR A
        JR Z,SEQ0_0
        LD D,#00
PREFIX2B        EQU $-1
SEQ0_0  LD (HL),D       ;pref
        INC IY
        INC HL
        LD (HL),E       ;seq_len
        INC IY
        INC HL
        OR A
        JR Z,SEQ_ADD
        LD (HL),A       ;seq_byte (seq_byte>0)
        INC IY
        INC HL

SEQ_ADD INC IX
        DEC BC
        DEC E
        JR NZ,SEQ_ADD
        JP CMP_M2

CMP_MM1 LD A,D
        JP CMP_M3

SRCH_MIN
        LD H,'BT_TABL
        LD L,A
        EXA
        LD A,(HL)
        CP D
        JR NZ,SRCH_NXT
        INC H
        LD A,(HL)
        CP E
        JR NZ,SRCH_NXT
        EXA
        RET
SRCH_NXT
        EXA
        INC A
        JR NZ,SRCH_MIN
        INC DE
        JR SRCH_MIN

        ENT


