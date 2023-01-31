; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        DISPLAY "SKATEBOARD CONSTRUCTION SYSTEM.
        DISPLAY "SAVE/LOAD OPTION"
        ORG #C100
FILE_LEN EQU #0060
TEMP_SP EQU #C700
SEC_BUF EQU #C700
FONT    EQU #3C00
LIN1ADR EQU #506A
LIN2ADR EQU #508A
        JP LOAD
        JP LOADSCR
SAVE    DI
        LD (STEK),SP
        LD SP,TEMP_SP
        EI
        CALL ENTER_FILENAME
        CALL SEL_DRIVE
        CALL SEARCHING_MES
        LD HL,0
        LD (#5CF4),HL
        LD BC,#810
SEA_SAL PUSH BC
        PUSH BC
        LD BC,#105
        LD DE,(#5CF4)
        LD HL,SEC_BUF
        PUSH HL
        CALL TR_DOS
        POP HL
        POP BC
        CALL SEARCH_FILE
        LD A,C
        OR A
        JP NZ,S_FOUND
        POP BC
        DJNZ SEA_SAL
        LD DE,8
        LD HL,SEC_BUF
        LD BC,#105
        CALL TR_DOS
        LD HL,(SEC_BUF+#E5)
        LD A,H
        OR L
        JP Z,NO_DSPACE
        LD A,(SEC_BUF+#E4)
        CP 128
        JP NC,NO_DSPACE
        LD HL,FILE_DISCRIPT
        LD DE,SEC_BUF+#40
        LD BC,14
        LDIR
        LD HL,(SEC_BUF+#E1)
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        PUSH HL
        LD (BODY_TRSC),HL
        LD HL,SEC_BUF
        LD DE,8
        LD BC,#106
        CALL TR_DOS_NOB
        POP DE
        PUSH DE
        CALL SAVE_BODY
        LD HL,(#5CF4)
        PUSH HL
        LD HL,0
        LD (#5CF4),HL
        LD BC,#810
SEA_EDI PUSH BC
        PUSH BC
        LD BC,#105
        LD DE,(#5CF4)
        LD HL,SEC_BUF
        PUSH HL
        CALL TR_DOS
        POP HL
        POP BC
        LD DE,BYTE0
        LD A,1
        CALL SEARCH1
        LD A,C
        OR A
        JR NZ,END_OF_CAT_FOUND
        POP BC
        DJNZ SEA_EDI
        JP NO_DSPACE
END_OF_CAT_FOUND
        POP BC
        PUSH IX
        POP DE
        DEC DE
        LD HL,FILE_DISCRIPT
        LD BC,14
        LDIR
        LD HL,#1111
BODY_TRSC EQU $-2
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        CALL PRNTMES1
        DB "SAVING DIR  ",#FF
        LD DE,(#5CF4)
        DEC E
        LD HL,SEC_BUF
        LD BC,#106
        CALL TR_DOS
        LD DE,8
        LD HL,SEC_BUF
        LD BC,#105
        CALL TR_DOS
        LD HL,(SEC_BUF+#E5)
        LD BC,FILE_LEN
        OR A
        SBC HL,BC
        LD (SEC_BUF+#E5),HL
        LD A,(SEC_BUF+#E4)
        INC A
        LD (SEC_BUF+#E4),A
        POP HL
        LD (SEC_BUF+#E1),HL
        LD HL,SEC_BUF
        LD DE,8
        LD BC,#106
        CALL TR_DOS
        JP EXIT

S_FOUND POP BC
        CALL PRNTMES1
        DB "FILE EXIST  ",#FF
        CALL PRNTMES2
        DB "OVERWRITE?  ",#FF
OW_KEY  RES 5,(IY+1)
WAITK1  BIT 5,(IY+1)
        JR Z,WAITK1
        LD A,(IY-50)
        CP "N"
        JR Z,EXIT1
        CP "n"
        JR Z,EXIT1
        CP 7
        JR Z,EXIT1
        CP 14
        JR Z,EXIT1
        CP "Y"
        JR Z,OVERW
        CP "y"
        JR Z,OVERW
        JR OW_KEY
OVERW   LD E,(IX)
        LD D,(IX+1)
        PUSH DE
        PUSH IX
        LD BC,#0E
        POP HL
        PUSH HL
        OR A
        SBC HL,BC
        LD DE,DISCRIPT_OWS
        LD BC,15
        LDIR
        POP HL
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        LD HL,SEC_BUF
        LD DE,8
        LD BC,#105
        CALL TR_DOS
        LD HL,DISCRIPT_OWS
        LD DE,#7A40
        LD BC,16
        LDIR
        LD HL,SEC_BUF
        LD DE,8
        LD BC,#106
        CALL TR_DOS_NOB
        POP DE
        CALL SAVE_BODY
EXIT1   JP EXIT

SAVE_BODY
        LD (#5CF4),DE
        CALL PRNTMES1
        DB "SAVING BODY ",#FF
        CALL PR_FNAM
        LD DE,(#5CF4)
        LD BC,#6006
        LD HL,#5FB4
        JP TR_DOS


LOADSCR CALL EXCHANGE_DISCR
        LD HL,LOAD_SC
        LD (LOAD_SW),HL
        CALL LOAD
        LD HL,LOAD_DT
        LD (LOAD_SW),HL
        JP EXCHANGE_DISCR

EXCHANGE_DISCR
        LD HL,FILE_DISCRIPT+8
        LD DE,FILE_DIS_SCR
        LD B,6
EC_D_L  LD C,(HL)
        LD A,(DE)
        LD (HL),A
        LD A,C
        LD (DE),A
        INC HL
        INC DE
        DJNZ EC_D_L
        RET

LOAD    DI
        LD (STEK),SP
        LD SP,TEMP_SP
        EI
        CALL ENTER_FILENAME
        CALL SEL_DRIVE
        CALL SEARCHING_MES
        LD DE,0
        LD BC,#805
        LD HL,SEC_BUF
        PUSH HL
        CALL TR_DOS
        POP HL
        LD C,128
        CALL SEARCH_FILE
        LD A,C
        OR A
        JP Z,NO_FILE
        CALL PRNTMES1
        DB "LOADING FILE",#FF
        LD E,(IX)
        LD D,(IX+1)
        JP LOAD_DT
LOAD_SW EQU $-2
LOAD_DT LD BC,#5F05
        LD HL,#5FB4
        CALL TR_DOS
        LD DE,(#5CF4)
        LD BC,#105
        LD HL,SEC_BUF
        PUSH HL
        CALL TR_DOS
        POP HL
        LD DE,#BEB4
        LD BC,#00E2
        LDIR

EXIT    CALL CLEAR1LIN
        CALL CLEAR2LIN
EXIT_WC DI
        LD SP,#3131
STEK    EQU $-2
        RET

LOAD_SC LD BC,#1B05
        LD HL,#4000
        CALL TR_DOS
        JR EXIT_WC

ENTER_FILENAME
        CALL CL_LA
        LD A,#FF
        LD (#5C00),A
        LD HL,#10A
        LD (#5C09),HL
        LD C,2
INP_POS EQU $-1
        RES 3,(IY+48)
        CALL PRNTMES1
        DB "ENTER NAME: ",#FF
        LD IX,FILENAME
INP_PO1 EQU $-2
EFN_L   LD A,":"
        LD (EF_MES+1),A
        LD (IX),"_"
        HALT
        CALL PR_FNAM
        RES 5,(IY+1)
WAITK   BIT 5,(IY+1)
        JR Z,WAITK
        CALL SOUND
        LD A,(IY-50)
        CP #0D
        JR Z,ENTER
        CP 8
        JR Z,EFN_L
        CP 9
        JR Z,EFN_L
        CP 10
        JR Z,EFN_L
        CP 11
        JR Z,EFN_L
        CP 14
        JP Z,EXIT11
        CP 7
        JP Z,EXIT11
        CP 12
        JR Z,DELETE
        CP 6
        JR NZ,NO_CLP
        LD HL,#5C6A
        LD A,(HL)
        XOR 8
        LD (HL),A
        JR EFN_L

NO_CLP  EX AF,AF'
        LD A,C
        CP 10
        JR Z,EFN_L
        INC C
        EX AF,AF'
        LD (IX),A
        INC IX
        JR EFN_L

DELETE  LD A,C
        OR A
        JR Z,EFN_L
        DEC C
        LD (IX),#20
        DEC IX
        LD (IX),"_"
        JR EFN_L

EXIT11  LD A,":"
        LD (EF_MES+1),A
        LD (IX),#20
        LD A,C
        LD (INP_POS),A
        LD (INP_PO1),IX
        JP EXIT

ENTER   LD A,(EF_MES)
        OR #20
        CP #61
        JP C,EFN_L
        CP #65
        JP NC,EFN_L
        LD A,":"
        LD (EF_MES+1),A
        LD (IX),#20
        LD A,C
        LD (INP_POS),A
        LD (INP_PO1),IX
        CALL PR_FNAM
        LD HL,FILENAME
        LD DE,FILE_DISCRIPT
        LD BC,8
        LDIR
        RET

SEARCH_FILE
        LD A,14
        LD DE,FILE_DISCRIPT
SEARCH1 LD (SYM_2SEARCH),A
        LD (DISCRIPT_2SEARCH),DE
        LD DE,#1111
DISCRIPT_2SEARCH EQU $-2
SF_L    PUSH HL
        PUSH DE
        LD B,6
SYM_2SEARCH EQU $-1
SF_COMP LD A,(DE)
        CP (HL)
        INC HL
        INC DE
        JR NZ,SF_COM1
        DJNZ SF_COMP
        PUSH HL
        POP IX
        POP DE
        POP HL
        RET

SF_COM1 POP DE
        POP HL
        PUSH BC
        LD BC,16
        ADD HL,BC
        POP BC
        DEC C
        JR NZ,SF_L
        RET




SEL_DRIVE
        LD A,(EF_MES)
        OR #20
        SUB "a"
        LD C,1
        CALL TRDOS
        LD A,(23823)
        OR A
        RET Z
        JP OP_ERROR


SOUND   PUSH BC
        LD HL,#18
        LD C,2
SOUN_L  LD A,L
        OUT (#FE),A
        LD B,0
SOUN_L1 DJNZ SOUN_L1
        LD A,H
        OUT (#FE),A
        LD B,0
SOUN_L2 DJNZ SOUN_L2
        DEC C
        JR NZ,SOUN_L
        POP BC
        RET

SEARCHING_MES
        CALL PRNTMES1
        DB "SEARCHING...",#FF
        RET

PR_FNAM
        CALL PRNTMES2
EF_MES  DB "A:"
FILENAME
        DB "         ",#FF
        RET

NO_FILE
        CALL PRNTMES1
        DB " NO FILE!   ",#FF
        JR CL_2LIN
OP_ERROR
        CALL PRNTMES1
        DB "DISK ERROR! ",#FF
CL_2LIN CALL CLEAR2LIN
        EI
        LD B,40
ER_PAUS HALT
        LD A,2
        OUT (#FE),A
        DJNZ ER_PAUS
        JP EXIT
NO_DSPACE
        CALL PRNTMES1
        DB "DISK IS FULL",#FF
        JR CL_2LIN

CLEAR1LIN
        LD DE,LIN1ADR
        JR CLEARLI
CLEAR2LIN
        LD DE,LIN2ADR
CLEARLI CALL PRNTMES
        DB "            ",#FF
        RET

PRNTMES2
        LD DE,LIN2ADR
        JR PRNTMES
PRNTMES1
        LD DE,LIN1ADR
PRNTMES POP HL
        LD A,(HL)
        INC HL
        PUSH HL
        CP #FF
        RET Z
        PUSH DE
        LD DE,FONT
FONTADR EQU $-2
        LD H,0
        LD L,A
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,DE
        POP DE
        PUSH DE
        LD B,8
OUTL_L  LD A,(HL)
        SRL A
        OR (HL)
        LD (DE),A
        INC D
        INC HL
        DJNZ OUTL_L
        POP DE
        INC E
        JR PRNTMES

CL_LA   LD DE,LIN1ADR-1
        CALL PRNTMES
        DB #20,#FF
        LD DE,LIN2ADR-1
        CALL PRNTMES
        DB #20,#FF
        RET

TR_DOS  PUSH HL
        PUSH DE
        PUSH BC
        CALL TRDOS
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        RET Z
        CP 6
        JP Z,OP_ERROR
        CP 7
        JP Z,OP_ERROR
        CP #14
        JP Z,OP_ERROR
        JR TR_DOS

TR_DOS_NOB
        PUSH HL
        PUSH DE
        PUSH BC
        CALL TRDOS
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        RET Z
        JR TR_DOS_NOB

TRDOS   PUSH HL
        LD (REG_A),A
        LD A,#FF
        LD (#5D15),A
        LD (#5D17),A
        LD HL,(23613)
        LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        EX AF,AF'
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23823),A
        LD (23824),A
        EX AF,AF'
        LD (SP2),SP
        LD A,#3E
REG_A   EQU $-1
        JP #3D13
DERR    LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),HL
        LD A,#C9
        LD (#5CC2),A
COMRET  RET
DRIA    EX (SP),HL
        PUSH AF
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR NZ,NO_ERR
        LD A,L
        CP #10
        JR Z,DERR
NO_ERR  POP AF
        EX (SP),HL
        RET
RIA     DUP 3
        POP  HL
        EDUP
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F
FILE_DISCRIPT
        DB "        skt",#E2,#5F,#60
DISCRIPT_OWS
        DS 16,0
BYTE0   DB 0
FILE_DIS_SCR
        DB "scr",#00,#1B,#1B

ENDOBJ  DISPLAY
        DISPLAY "End object: ",ENDOBJ
