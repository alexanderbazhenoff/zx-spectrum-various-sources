; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at https://github.com/aws/mit-0

; Dataglue packer by alx^bw


TEST    EQU 1

        IF0 TEST
CONVBUF EQU #6600
        ELSE 
CONVBUF EQU #6000
        ENDIF 

 DISPLAY "data glue v1.0 by alx/brainwave"
 DISPLAY 
 DISPLAY "max lenght of gluing block: #9F00"
 DISPLAY 
 DISPLAY "index: byte0...2 - смещение"
 DISPLAY "                   [byte мл.,ср.,старший]"
 DISPLAY "       byte3     - длина блока (в секторах)"
 DISPLAY 
 DISPLAY "тестовый режим: "
        IF0 TEST
        DISPLAY /L," вкл."
        ELSE 
        DISPLAY /L," выкл."
 DISPLAY "для сохранения кодового блока - RUN OBJECT!"
        ENDIF 



;INVERS EQU 0

        ORG #6000
L_BEG_OBJECT

        XOR A
        OUT (#FE),A
        LD A,7
        LD (23624),A
        LD (23693),A
        CALL 3435
        LD HL,#5900
        LD DE,#5901
        LD BC,#01FF
        LD (HL),L
        LDIR 

        IFN TEST
        LD HL,CODE_MAIN
        LD DE,#4800
        LD BC,CODE_MAIN_END-CODE_MAIN
        PUSH DE
        LDIR 
        RET 
CODE_MAIN
        DISP #4800
        ENDIF 
        IF0 TEST
        LD (STARTSP),SP
        ENDIF 
START   IFN TEST
        LD SP,CONVBUF
        ELSE 
        LD SP,0
STARTSP EQU $-2
        ENDIF 
        LD A,2
        CALL 5633
        CALL CL_ATTR
        LD HL,FILE_NO
        LD A,"0"
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        LD A,#C9
        LD (SRC_DRIV_SEL),A
        LD (DST_DRIV_SEL),A
        LD HL,HEAD_TXT
        CALL PRINT
DCNG_L  LD HL,SRC_DRIV
        LD A,(HL)
        ADD A,"a"
        LD (SD_TXT0),A
        INC HL
        LD A,(HL)
        ADD A,"a"
        LD (DD_TXT0),A
        LD HL,SD_TXT
        CALL PRINT
        EI 
        RES 5,(IY+1)
WKEY    BIT 5,(IY+1)
        JR Z,WKEY
        LD HL,SRC_DRIV
        LD A,(IY-50)
        CP "1"
        CALL Z,SEL_DRIV
        INC HL
        CP "2"
        CALL Z,SEL_DRIV
        CP #0D
        JR NZ,DCNG_L
        PUSH HL
        CALL CL_ATTR
        POP HL
        LD C,(HL)
        DEC HL
        LD A,(HL)
        CP C
        JR Z,SING_DRV
        LD C,1
        CALL DOS
        LD C,#18
        CALL DOS
        XOR A
        LD (SRC_DRIV_SEL),A
        LD (DST_DRIV_SEL),A
SING_DRV
        LD A,(DST_DRIV)
        LD C,1
        CALL DOS
        LD C,#18
        CALL DOS

        LD HL,#5000
        LD BC,#0105
        LD DE,#0008
        CALL DOS
        CALL SRC_DRIV_SEL
        LD HL,#50E4
        LD A,(HL)
        CP 128
        JP Z,ERR_NOSPC
        INC HL
        LD A,(HL)
        INC HL
        LD H,(HL)
        OR H
        JP Z,ERR_NOSPC
        LD L,A
;       LD (FREE_SEC_COL),HL
        LD HL,(#50E1)
        LD (FREE_TRSEC),HL
        XOR A
        LD HL,#5600
        PUSH HL
        POP IX
        LD B,8
IND_CL  LD (HL),0
        INC HL
        DJNZ IND_CL
        LD (FILE_NOR),A

EXECUT_L
        PUSH IX
        LD HL,FNAME
        CALL PRINT
        LD HL,DISCRIPT
        CALL DISCR_COPY
        CALL SRC_DRIV_SEL
        XOR A
        LD (23823),A
        LD A,9
        LD (23814),A
SEAR_L  LD C,#0A
        CALL DOS0
        LD A,(23823)
        CP C
        JR Z,SEAR_OK
        OR A
        JR NZ,SEAR_L
SEAR_OK LD A,C
        CP #FF
        JP Z,OPEREND
        LD C,8
        CALL DOS
        LD HL,FILE_LOAD
        CALL PRINT

        POP IX
        LD L,(IX)
        LD H,(IX+1)
        LD A,(IX+2)
        LD BC,(#5CE8)
        ADD HL,BC
        ADC A,0
        LD (IX+4),L
        LD (IX+5),H
        LD (IX+6),A
        PUSH BC
        LD A,C
        OR A
        JR Z,CNADS1
        INC B
CNADS1  LD (IX+3),B
        LD H,'CONVBUF
        LD L,(IX)
        LD DE,(#5CEB)
        LD C,5
        CALL DOS
        POP HL
        LD C,(IX)
        LD B,0
        ADD HL,BC
        PUSH HL
        PUSH HL
        PUSH IX
        LD HL,FILE_SAVE
        CALL PRINT
        CALL DST_DRIV_SEL
        POP IX
        POP BC
        LD C,B
        LD B,0
SAVE_SEC
;       LD HL,#2121
;FREE_SEC_COL EQU $-2
        LD HL,(#50E5)
        XOR A
        SBC HL,BC
        JP C,ERR_NOSPC
;       LD (FREE_SEC_COL),HL
        LD (#50E5),HL
        LD DE,#2121
FREE_TRSEC EQU $-2
        LD L,(IX+1)
        LD H,(IX+2)
        LD A,H
        OR L
        JR Z,NADTRS1
MADTRL  INC E
        BIT 4,E
        JR Z,NADTR
        LD E,0
        INC D
NADTR   DEC HL
        LD A,H
        OR L
        JR NZ,MADTRL
NADTRS1
        POP BC
        PUSH BC
        LD C,6
        LD HL,CONVBUF
        CALL DOS
        CALL COPY_5CF4_TO_LSTS

        POP BC
        LD A,'CONVBUF
        ADD A,B
        LD H,A
        LD L,0
        LD DE,CONVBUF
        LD B,L
        LDIR 
        CALL FNAM_ADD
        LD A,(FILE_NOR)
        INC A
        CP 128
        JP Z,OPEREND2
        LD (FILE_NOR),A
        DUP 4
        INC IX
        EDUP 
        JP EXECUT_L

HEADR_CR
        LD E,(IX)
        LD A,(IX+1)
        OR E
        RET Z
;       LD HL,(FREE_SEC_COL)
        LD HL,(#50E5)
        LD A,L
        OR H
        JP Z,ERR_NOSPC
        LD A,E
        OR A
        JR Z,NO_SAV_HV
        DEC HL
;       LD (FREE_SEC_COL),HL
        LD (#50E5),HL
        CALL DST_DRIV_SEL
        LD D,'CONVBUF
        LD HL,INNERSEC_STRING
        LD BC,EINNERSEC_STRING-INNERSEC_STRING
        LDIR 
        LD HL,CONVBUF
        LD DE,(LAST_SAVED_TRSEC)
        LD BC,#0106
        CALL DOS
        CALL COPY_5CF4_TO_LSTS
NO_SAV_HV

        LD HL,GL_DISCRIPT
        CALL DISCR_COPY
        LD HL,CR_GL_DISCRIPT
        CALL PRINT

        LD HL,#2121
LAST_SAVED_TRSEC EQU $-2
        LD DE,(FREE_TRSEC)
        LD (#5CEB),DE
        LD B,0
CRGLH_L INC E
        BIT 4,E
        JR Z,CRGLH_0
        INC D
        LD E,0
CRGLH_0 INC B
        LD A,B
        CP #FF
        JR NZ,CRGLH_1
        CALL CRGLDISCR

CRGLH_1 LD A,D
        CP H
        JR NZ,CRGLH_L
        LD A,E
        CP L
        JR NZ,CRGLH_L
        LD A,B
        OR A
        JR Z,CRGLH_2
        CALL CRGLDISCR
CRGLH_2 LD (#50E1),HL
        LD HL,#5000
        LD DE,#0008
        LD BC,#0106
        CALL DOS
        LD HL,CR_GL_INDEX_TXT
        CALL PRINT
        LD HL,INDX_DISCRIPT
        CALL DISCR_COPY
        LD A,(FILE_NOR)
        LD L,A
        LD H,0
        DUP 4
        ADD HL,HL
        EDUP 
        PUSH HL
        POP DE

        ADD HL,HL
        AND #F
        ADD A,"0"
        LD B,A
        LD A,H
        ADD A,"0"
        LD C,A
        LD (#5CE3),BC

        LD HL,#5600
        LD C,#0B
        JP DOS

COPY_5CF4_TO_LSTS
        LD HL,(#5CF4)
        LD (LAST_SAVED_TRSEC),HL
        RET 

CRGLDISCR
        PUSH HL,DE,BC
        LD HL,#5CE8
        LD (HL),0
        INC HL
        LD (HL),B
        INC HL
        LD (HL),B
        LD A,(#50E4)
        CP 128                  ;??
        JP Z,ERR_NOSPC          ;??
        PUSH AF
        LD C,9
        CALL DOS
        POP AF
        INC A
        LD (#50E4),A
        LD HL,#5CDD+6
        INC (HL)
        POP BC,DE,HL
        LD (#5CEB),DE
        LD B,0
        RET 



FNAM_ADD
        LD HL,FILE_NO+2
        LD B,2
FNAM_AD0
        LD A,(HL)
        INC A
        LD (HL),A
        CP ":"
        RET NZ
        LD (HL),"0"
        DEC HL
        DJNZ FNAM_AD0
        INC (HL)
        RET 

SRC_DRIV_SEL
        NOP 
        LD A,(SRC_DRIV)
DR_SEL  LD C,A
        LD (#5CF6),A
        LD A,(#5D16)
        AND 4+8+16+32+64+128
        OR C
        LD (#5D16),A
        RET 
DST_DRIV_SEL
        NOP 
        LD A,(DST_DRIV)
        JR DR_SEL

SEL_DRIV
        LD A,(HL)
        INC A
        AND 3
        LD (HL),A
        RET 

PRINT
PRINTL  LD A,(HL)
        CP #FF
        RET Z
        PUSH HL
        RST #10
        POP HL
        INC HL
        JR PRINTL

DISCR_COPY
        LD C,#13
        JP #3D13

DOS0    EXA 
        PUSH HL
        LD HL,(23613)
        LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23824),A
        LD (23823),A
        DEC A
        LD (#5D15),A
        LD (#5D17),A
        LD (SP2),SP
        EXA 
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

DOS     PUSH IX,HL,DE,BC,AF
        CALL DOS0
        POP AF,BC,DE,HL,IX
        EXA 
        LD A,(23823)
        OR A
        RET Z
        CP 7
        JR Z,ERR_WRPRT
        CP 20
        JR Z,ERR_BREAK
        LD A,2
        OUT (#FE),A
        DUP 4
        HALT 
        EDUP 
        XOR A
        OUT (#FE),A
        EXA 
        JR DOS
        RET 
OPEREND2
        CALL HEADR_CR
        LD HL,ERRTXT_END2
        JR OPEND0
OPEREND CALL HEADR_CR
        LD HL,ERRTXT_END
OPEND0  CALL PRINT
        JR ERR1
ERR_WRPRT
        LD HL,ERRTXT_WRPRT
        JR ERR0
ERR_BREAK
        LD HL,ERRTXT_BREAK
        JR ERR0
ERR_NOSPC
        LD HL,ERRTXT_NOSPC
ERR0    PUSH HL
        LD HL,ERR_TXT0
        CALL PRINT
        POP HL
        CALL PRINT
        LD A,2
        OUT (#FE),A
        LD A,(#5CF6)
        ADD A,"a"
        LD (ERR_DRV),A
        LD HL,ERRTXT0
        CALL PRINT
ERR1    RES 5,(IY+1)
ERWKEY  BIT 5,(IY+1)
        JR Z,ERWKEY
        JP START

CL_ATTR XOR A
        OUT (#FE),A
        LD HL,#5820
        LD DE,#5821
        LD BC,#00DF
        LD (HL),A
        LDIR 
        RET 

SRC_DRIV DB 0
DST_DRIV DB 0
HEAD_TXT DB #16,0,0,#13,1,"data glue utility 1.0",#13,0," by "
         DB #13,1,"alx/bw",#0D,#0D
         DB "select drive:",#0D,#0D
         DB #13,1,"1.",#13,0," source:",#0D
         DB #13,1,"2.",#13,0," destination:",#0D,#0D
         DB "press ",#13,1,"enter",#13,0," to start.",#FF
SD_TXT   DB #16,4,11,#13,1
SD_TXT0  DB 1
DD_TXT   DB #16,5,16,#13,1
DD_TXT0  DB #FF,#FF
FNAME    DB #13,1,#16,2,0,"'"
DISCRIPT DB "blok"
FILE_NO  DB "    R'",#13,0,", searching...",#16,2,8,#13,1,"."
         DB #13,0,#FF
FILE_NOR DB #FF
FILE_LOAD
         DB #16,2,13,"loading...   ",#FF
FILE_SAVE
         DB #16,2,13,"gluing... ",#0D,#FF
ERRTXT0
         DB #16,3,0,#13,0,"drive ",#13,1
ERR_DRV  DB "  ",#13,0
         DB "error:",#FF
ERR_TXT0
         DB #16,3,15,#FF
ERRTXT_NOSPC
         DB "no free space!",#FF
ERRTXT_WRPRT
         DB "write protect!",#FF
ERRTXT_BREAK
         DB "break",#13,0," pressed!",#FF
ERRTXT_END
         DB #16,2,13,"not found!  "
ERRTXT_END2
         DB #16,3,0,"operation complete.",#FF
CR_GL_DISCRIPT
         DB #16,3,0,"creating header...       ",#FF
CR_GL_INDEX_TXT
         DB #16,3,0,"saving index...   ",#FF
GL_DISCRIPT
         DB "glued_a CDG"
INDX_DISCRIPT
         DB "index#00C"
INNERSEC_STRING
         DB "---data glue 1.0 by alx/bw---"
EINNERSEC_STRING

        IFN TEST
        ENT 
CODE_MAIN_END
L_END_OBJECT
        ENDIF 

        IFN TEST
        ORG #E000
        CALL COP_DISCR
        LD HL,BASIC_BEG
        LD DE,BASIC_END-BASIC_BEG
        LD C,#0B
        CALL #3D13
        LD A,9
        LD (23814),A
        LD C,#0A
        CALL #3D13
        LD A,C
        PUSH AF
        LD C,8
        CALL #3D13
        LD HL,(#5CE8)
        DEC HL,HL,HL,HL
        LD (#5CE8),HL
        LD (#5CE6),HL
        LD A,"B"
        LD (#5CE5),A
        POP AF
        LD C,9
        CALL #3D13
        CALL COP_DISCR
        LD HL,L_BEG_OBJECT
        LD DE,L_END_OBJECT-L_BEG_OBJECT
        LD C,#0B
        JP #3D13
COP_DISCR
        LD HL,DESCR_OBJ
        LD C,#13
        JP #3D13

DESCR_OBJ DB "DGlue1_0C"
BASIC_BEG
 DB 0,1,#24,#00,#FD,#B0,#22,"24575",#22,#3A,#F9,#C0,#B0,#22
 DB "15619",#22,#3A,#EA,#3A,#F7,#22,"DGlue1_0",#22,#AF,#0D
 DB #80,#AA,1,0
BASIC_END
        ENDIF 

