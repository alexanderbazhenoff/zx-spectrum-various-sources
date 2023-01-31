; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        DISPLAY "Livingstone 2.1 128 bank7"
        DISPLAY "save [fname],#DB00,#2301"
        ORG #DB00
;       DS #2301,0

        ORG #BB33
        DW #4000

        ORG #FD00
        DS #101,#FC

        ORG #FCFC
        JP INTBANK72

        ORG #DB00
        DB 0,0
        DW HERO_OUT_ATTR
        DW MISC_OUT_ATTR
        DB 0,0

        LD BC,#FEFE
        IN A,(C)
        RRA
        JP C,NO_SAVLOAD
        LD B,#FD
        IN A,(C)
        RRA
        RRA
        JR C,NOSAVE
        DI
        CALL AY_MUTE
        CALL SL_REGZ
        EX DE,HL
        LDIR
        EXX
        LD (#FF02),HL
        LD (#FF04),DE
        LD (#FF06),BC
        EXX
        PUSH IX
        LD (MSAV_SP),SP
        LD SP,#8000
        CALL MRESMOV
        CALL SAVMEM
        LD SP,#3131
MSAV_SP EQU $-2
        POP IX
        CALL SL_REGZ
        LDIR
        XOR A
        LD (MLOAD_SW),A
        EI
        JR NO_SAVLOAD

NOSAVE
        LD B,#BF
        IN A,(C)
        RRA
        RRA
        JR C,NO_SAVLOAD
        LD A,#3F
MLOAD_SW EQU $-1
        OR A
        JR NZ,NO_SAVLOAD
        DI
        CALL AY_MUTE
        PUSH IX
        LD (MLOD_SP),SP
        LD SP,#8000
        CALL MRESMOV
        CALL LODMEM
        LD SP,#3131
MLOD_SP EQU $-2
        POP IX
        CALL SL_REGZ
        LDIR
        EXX
        LD HL,(#FF02)
        LD DE,(#FF04)
        LD BC,(#FF06)
        EXX
        LD BC,#7FFD
        LD A,(#BB32)
        OR 7
        OUT (C),A
        LD HL,#5080
        LD DE,#D080
        LD BC,#0880
LOD_PC1 PUSH BC
        PUSH DE
        PUSH HL
        LD B,0
        LDIR
        POP HL,DE,BC
        INC H
        INC D
        DJNZ LOD_PC1
        LD H,#5A
        LD D,#DA
        LDIR
        EI

NO_SAVLOAD
WOK     LD A,(#AE29)
        AND 7
        OR A
        JR Z,WOK2
        DI
WNOK2   LD A,2
        OUT (#FE),A
        LD A,0
        OUT (#FE),A
        JP WNOK2
WOK2

        LD (CLS_SP),SP
        LD (INT7_SP2),SP
        LD HL,INTBANK71
        DI
        LD SP,#5000
        LD (#FCFD),HL
        EI
        LD DE,(#BB33)
        LD A,(#BB31)
        ADD A,D
        LD D,A

CLS_ADDHL EQU #1780
CLS_FBYTE EQU #BB3E
        DUP 7
        LD HL,CLS_ADDHL
        ADD HL,DE
        LD BC,(CLS_FBYTE)
        LD B,C
        LD SP,HL
        DUP #3F
        PUSH BC
        EDUP
CLS_ADDHL=CLS_ADDHL-#100
CLS_FBYTE=CLS_FBYTE-1
        EDUP
        LD HL,CLS_ADDHL
        ADD HL,DE
        LD BC,(CLS_FBYTE)
        LD B,C
        LD SP,HL
        DUP #40
        PUSH BC
        EDUP

        LD A,8
        LD HL,#BB3E
CLS1    LD C,(HL)
        LD B,C
        DUP #80
        PUSH BC
        EDUP
        DEC L
        DEC A
        JP NZ,CLS1

        LD A,7
        LD HL,#BB3E
CLS2    LD C,(HL)
        LD B,C
        DUP #80
        PUSH BC
        EDUP
        DEC L
        DEC A
        JP NZ,CLS2

        LD C,(HL)
        LD B,C
        DUP #7F
        PUSH BC
        EDUP

        LD (CLS3),SP
        LD HL,INTBANK72
        DI
        LD SP,#3131
CLS_SP  EQU $-2
        LD (#FCFD),HL
        EI
        LD HL,#2121
CLS3    EQU $-2
        DEC L
        LD (HL),C
        DEC L
        LD (HL),C

        LD HL,(#BB33)
        LD A,(#BB31)
        ADD A,H
        ADD A,#10
        LD H,A
        LD DE,#BB37
        LD B,8
CLS4    LD A,(DE)
        LD (HL),A
        INC L
        LD (HL),A
        DEC L
        INC H
        INC E
        DJNZ CLS4

        LD DE,#BC4F
        LD BC,(#AE2B)
        LD HL,(#BB35)
        LD A,(#BB31)
        ADD A,H
        LD H,A
        PUSH HL
        POP IY
        EXX
        LD BC,(#AE29)
        LD DE,(#BB33)
        LD A,(#BB31)
        ADD A,D
        LD D,A
        LD A,(#AE3C)
OUT1
        EXA
        PUSH DE


        DUP #20
        EXX
        LD A,(DE)
        INC DE
        LD L,A
        LD H,0
        ADD HL,BC
        LD L,(HL)
        LD (IY),L
        EXX
        OR A
        LOCAL
        JR Z,outps1
        LD L,A
        LD H,0
        DUP 3
        ADD HL,HL
        EDUP
        ADD HL,BC
        PUSH DE
        DUP 7
        LD A,(HL)
        LD (DE),A
        INC L           ;???
        INC D
        EDUP
        LD A,(HL)
        LD (DE),A
        POP DE
outps1  INC E
        ENDL
        INC IY
        EDUP

        POP DE
        LD A,E
        ADD A,#20
        LD E,A
        JR NC,OUT2
        LD A,D
        ADD A,8
        LD D,A
OUT2    EXA
        DEC A
        JP NZ,OUT1
        RET

INTBANK71
        DI
        LD (INT7_SP),SP
        LD SP,#3131
INT7_SP2 EQU $-2
        PUSH AF,BC,HL
        LD HL,INTEXIT
        LD (#DB00),HL
        JP #B1E6
INTEXIT POP HL,BC,AF
        LD SP,#3131
INT7_SP EQU $-2
        EI
        RET
INTBANK72
        DI
        PUSH AF,BC,HL
        LD HL,INTEXIT2
        LD (#DB00),HL
        JP #B1E6
INTEXIT2
        POP HL,BC,AF
        EI
        RET

HERO_OUT_ATTR
        LD A,(#BB31)
        ADD A,H
        LD H,A
HEROA1  PUSH BC,HL
        LD C,7
HEROA2  BIT 7,D
        JR Z,HEROA3
        LD A,(HL)
        AND C
        JR NZ,HEROA4
HEROA3  LD A,(HL)
        AND #F8
        OR E
        LD (HL),A
HEROA4  INC L
        DJNZ HEROA2
        POP HL
        LD C,#20
        ADD HL,BC
        POP BC
        DEC C
        JP NZ,HEROA1
        RET
MISC_OUT_ATTR
        LD A,(#BB31)
        ADD A,H
        LD H,A
        EXA
MISCA1  PUSH BC,HL
MISCA2  LD (HL),A
        INC L
        DJNZ MISCA2
        POP HL
        LD C,#20
        ADD HL,BC
        POP BC
        DEC C
        JP NZ,MISCA1
        JP #B1DB

SL_REGZ LD HL,#FE02
        LD DE,#7F00
        LD BC,#0100
        RET
MRESMOV LD A,(#BB32)
        LD (#7F00),A
        LD HL,MRES
        LD DE,#7F01
        LD BC,EMRES-MRES
        LDIR
        RET

MRES
        DISP #7F01
SAVMEM  LD A,(#7F00)
        AND #18
        OR 6
        LD BC,#7FFD
        OUT (C),A
        PUSH BC
        CALL SAVREGS
        PUSH DE
        LDIR
        POP DE
        POP BC
        LD A,(#7F00)
        AND #18
        INC A
        OUT (C),A
        LD HL,#5080
        LD BC,#0880
SAVMS1  PUSH BC
        PUSH HL
        LD B,0
        LDIR
        POP HL
        POP BC
        INC H
        DJNZ SAVMS1
        LD HL,#5A80
        LD BC,#2480
        LDIR
        PUSH DE
        POP IX
        LD HL,#FE02
        LD DE,#0107
        LD B,1
        CALL MOVPAGZ
        LD DE,#0300
        LD B,#40
        CALL MOVPAGS
EXITMEM LD BC,#7FFD
        LD A,(#7F00)
        AND #18
        OR 7
        OUT (C),A
        RET
LODMEM  LD A,(#7F00)
        AND #18
        OR 6
        LD BC,#7FFD
        OUT (C),A
        PUSH BC
        CALL SAVREGS
        EX DE,HL
        PUSH HL
        LDIR
        POP HL
        POP BC
        LD A,(#7F00)
        AND #18
        INC A
        OUT (C),A
        LD DE,#5080
        LD BC,#0880
SAVMS2  PUSH BC
        PUSH DE
        LD B,0
        LDIR
        POP DE
        POP BC
        INC D
        DJNZ SAVMS2
        LD DE,#5A80
        LD BC,#2480
        LDIR
        LD IX,#FE02
        LD DE,#0701
        LD B,1
        CALL MOVPAGZ
        LD DE,#0003
        LD B,#40
        CALL MOVPAGS
        JR EXITMEM

MOVPAGS LD HL,#C000
        PUSH HL
        POP IX
MOVPAGZ LD A,(#7F00)
        AND #18
        PUSH AF
        OR D
        LD D,A
        POP AF
        OR E
        LD E,A
MOVPGZ1 PUSH BC
        LD BC,#7FFD
        OUT (C),E
        LD A,(HL)
        OUT (C),D
        LD (IX),A
        POP BC
        INC IX
        INC HL
        DEC BC
        LD A,B
        OR C
        JP NZ,MOVPGZ1
        RET
SAVREGS LD HL,#8000
        LD DE,#C000
        LD BC,#4000
        RET

        ENT
EMRES

AY_MUTE LD DE,#0E00
AY_MUTL DEC D
        LD BC,#FFFD
        OUT (C),D
        LD B,#BF
        OUT (C),E
        JR NZ,AY_MUTL
        RET

        ORG #DB08

