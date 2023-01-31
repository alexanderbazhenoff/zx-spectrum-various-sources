; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6000
        DISP #4800
        LD (STEKK),SP
        LD SP,#5C00
        LD A,1
        PUSH AF
        CALL ATR_7F
        LD HL,#4020
        LD C,7*32-1
        CALL FILZERO
        LD HL,#5000
        LD C,4*32-1
        CALL FILZERO
        LD IX,TEXT
        LD DE,#5000
        LD B,#60
        CALL PRINT
        CALL ATR_78
        CALL CH_POS
        LD A,C
        LD (POSLOA),A
        LD (POSSAV),A
        LD HL,(#0000)
        LD HL,#5500
        SUB #31
        OR A
        JR Z,NOATS
        LD B,A
ATS     LD C,#55
ATS1    INC L
        LD A,L
        CP 16
        JR NZ,NONT
        INC H
        LD L,0
NONT    DEC C
        JR NZ,ATS1
        DJNZ ATS


NOATS   LD (TRSC),HL
        LD (TRSC1),HL


        POP AF
        OR A
        JR NZ,SAVEPOS
LOADPOS LD DE,#5020
        LD IX,TXTLOA
        LD B,#40
        CALL PRINT

        ;BLOCK1 & 2
        LD HL,#E3BE
        LD B,#14
        CALL LOAD
        LD C,#63
        CALL LOADB
        CALL BLAMINI

        ;BLOCK 3
        LD HL,#A6A1
        LD B,#37
        CALL LOAD
        LD C,#D1
        CALL LOADB
        CALL BLMESP

        ;BLOCK 4
        LD HL,#F8B2
        LD B,7
        CALL LOAD
        CALL BLMESP


        ;BLOCK 5
        LD HL,#9353
        LD C,#DC
        CALL LOADB
        CALL BLMESP

EXIT    LD HL,#4020
        LD C,7*32-1
        CALL FILZERO
        LD HL,#5820
        LD BC,32*19-1
        LD A,#78
        CALL ATRPAIN
        LD HL,#4800
        LD DE,#4801
        LD BC,#7FF
        LD (HL),L
        LD SP,#3131
STEKK   EQU $-2
        JP #33C3

SAVEPOS LD DE,#5020
        LD IX,TXTSAV
        LD B,#40
        CALL PRINT

        ;BLOCK1 & 2
        LD HL,#E3BE
        LD B,#15
        CALL SAVE
        CALL BLAMINI

        ;BLOCK 3
        LD HL,#A6A1
        LD B,#38
        CALL SAVE
        CALL BLMESP

        ;BLOCK 4
        LD HL,#F8B2
        LD B,7
        CALL SAVE
        CALL BLMESP


        ;BLOCK 5
        LD HL,#9353
        LD B,1
        CALL SAVE
        CALL BLMESP
        JR EXIT


FILZERO LD B,8
        XOR A
FILZ_L1 PUSH BC
        PUSH HL
        LD (HL),A
        LD D,H
        LD E,L
        INC DE
        LD B,A
        LDIR
        POP HL
        POP BC
        INC H
        DJNZ FILZ_L1
        RET

LOADB   PUSH HL
        PUSH BC
        LD B,1
        LD HL,#4F00
        PUSH HL
        CALL LOAD
        POP HL
        POP BC
        LD B,0
        POP DE
        LDIR
        RET

SAVE    DI
        LD DE,#0100
TRSC    EQU $-2
LL5B1C  PUSH BC
        PUSH DE
        LD A,D
        OR A
        RRA
        LD C,A
        LD A,#3C
        JR NC,LL5B28
        LD A,#2C
LL5B28  LD IX,#1FF3
        CALL DOS
        LD A,C
        LD C,#7F
        LD IX,#2A53
        CALL DOS
        LD A,#18
        LD IX,#2FC3
        CALL DOS
        POP DE
        POP BC
LL5B44  PUSH BC
        PUSH DE
        LD IX,#2D73
        CALL DOS
        POP DE
        INC H
        INC E
        BIT 4,E
        JR Z,LL5B5C
        LD E,#0
        INC D
        POP BC
        DJNZ LL5B1C
        JR LL5B5F
LL5B5C  POP BC
        DJNZ LL5B44
LL5B5F  LD (TRSC),DE
        RET
DOS     PUSH IX
        JP #3D2F



LOAD    DI
        LD DE,0
TRSC1   EQU $-2
LL5B1C1 PUSH BC
        PUSH DE
        LD A,D
        OR A
        RRA
        LD C,A
        LD A,#3C
        JR NC,LL5B281
        LD A,#2C
LL5B281 LD IX,#1FF3
        CALL DOS
        LD A,C
        LD C,#7F
        LD IX,#2A53
        CALL DOS
        LD A,#18
        LD IX,#2FC3
        CALL DOS
        POP DE
        POP BC
LL5B441 PUSH BC
        PUSH DE
        LD IX,#2F1B
        CALL DOS
        POP DE
        INC H
        INC E
        BIT 4,E
        JR Z,LL5B5C1
        LD E,#0
        INC D
        POP BC
        DJNZ LL5B1C1
        JR LL5B5F1
LL5B5C1 POP BC
        DJNZ LL5B441
LL5B5F1 LD (TRSC1),DE
        RET

BLAMINI LD HL,BLMT1
        LD (BLMPAR),HL
BLMESP  LD DE,#505D
        LD IX,BLMT1
BLMPAR  EQU $-2
        LD B,3
        CALL PRINT
        LD (BLMPAR),IX
        RET
PRINT

PRNTL   PUSH BC
        PUSH DE
PRNTSHR LD L,(IX)
        LD H,0
        LD C,H
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        LD B,#3C
        ADD HL,BC
        LD B,8
PRNTSH1 LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        DJNZ PRNTSH1
        POP DE
        INC E
        POP BC
        INC IX
        DJNZ PRNTL
        RET

TEXT    DEFB "DISK OPTIONS BY ALX/BW/XPJ      "
        DEFB "Press <1>...<4> to select the   "
        DEFB "number of your game position.   "
TXTSAV  DEFB "Please wait...                  "
        DEFB "Saving position no."
POSSAV  DEFB "1   Saved 00%"
TXTLOA  DEFB "Please wait...                  "
        DEFB "Loading position no."
POSLOA  DEFB "1 Loaded 00%"

BLMT1   DEFB "24%"
BLMT2   DEFB "91%"
BLMT3   DEFB "99%"
BLMT4   DEFB "ok!"

ATR_78  LD A,#78
        JR ATR_
ATR_7F  LD A,#7F
ATR_    LD HL,#5820
        LD BC,#20*7-1
        CALL ATRPAIN
        LD HL,#5A00
        LD BC,#20*4-1

ATRPAIN LD D,H
        LD E,L
        INC DE
        LD (HL),A
        LDIR
        RET

CH_POS  LD A,#F7
        IN A,(#FE)
        LD C,#31
        RRA
        RET NC
        INC C
        RRA
        RET NC
        INC C
        RRA
        RET NC
        INC C
        RRA
        RET NC
        JR CH_POS
