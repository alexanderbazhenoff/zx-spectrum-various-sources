; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at https://github.com/aws/mit-0

; sunshine cracktro by alx^bw. almost done but never released.


        ORG #6000

ATTR_MODE               EQU 0

TEXT_BUFFER_PIX         EQU #F040 ;[#0FC0]
TEXT_BUFFER_ATR1        EQU #EE00 ;[#0240]
TEXT_BUFFER_ATR2        EQU #EB00 ;[#0240]
TEXT_BUFFER_BEGIN       EQU TEXT_BUFFER_ATR2
ENTR                    EQU #0D
ENTR_WR                 EQU #0A
TAB                     EQU #08

        IF0 ATTR_MODE
ATRI0   EQU 2
ATRI1   EQU 1
ATRI2   EQU 3
ATRI4   EQU 5
        ENDIF 

        IF0 ATTR_MODE-1
ATRI0   EQU 2
ATRI1   EQU 2
ATRI2   EQU 3
ATRI4   EQU 6
        ENDIF 

        IF0 ATTR_MODE-2
ATRI0   EQU 2
ATRI1   EQU 2
ATRI2   EQU 4
ATRI4   EQU 6
        ENDIF 

        IF0 ATTR_MODE-3
ATRI0   EQU 2
ATRI1   EQU 1
ATRI2   EQU 4
ATRI4   EQU 6
        ENDIF 

        IF0 ATTR_MODE-4
ATRI0   EQU 2
ATRI1   EQU 1
ATRI2   EQU 5
ATRI4   EQU 6
        ENDIF 

        IF0 ATTR_MODE-5
ATRI0   EQU 2
ATRI1   EQU 2
ATRI2   EQU 5
ATRI4   EQU 6
        ENDIF 

        IF0 ATTR_MODE-6
ATRI0   EQU 2
ATRI1   EQU 1
ATRI2   EQU 4
ATRI4   EQU 5
        ENDIF 

        IF0 ATTR_MODE-7
ATRI0   EQU 2
ATRI1   EQU 3
ATRI2   EQU 4
ATRI4   EQU 6
        ENDIF 

        MACRO ATR0
        DB #C0+ATRI0,#40+ATRI0
        ENDM 

        MACRO ATR1A
        DB #C0+ATRI1,ATRI0
        ENDM 
        MACRO ATR1B
        DB #C0+ATRI1,#07
        ENDM 

        MACRO ATR2A
        DB #C0+ATRI1,#40+ATRI1
        ENDM 
        MACRO ATR2B
        DB #C0+ATRI1,ATRI4
        ENDM 

        MACRO ATR3A
        DB #C0+ATRI2,#40+ATRI2
        ENDM 
        MACRO ATR3B
        DB #C0+ATRI2,#40+ATRI1
        ENDM 

        MACRO ATR4A
        DB #80+ATRI4,#40+ATRI2
        ENDM 
        MACRO ATR4B
        DB #C7,#40+ATRI2
        ENDM 

        MACRO ATR5A
        DB #C0+ATRI4,#40+ATRI4
        ENDM 
        MACRO ATR5B
        DB #C0+ATRI4,#47
        ENDM 

        MACRO ATR6A
        DB #C7,#47
        ENDM 
        MACRO ATR6B
        DB #C7,#40+ATRI1
        ENDM 

        CALL CLS
;       CALL INSTALL
        CALL CLEAR_BUFFER
        LD IX,TEXT1
        CALL PRINT_PAGE
        CALL OUTPUT_BUFFER
MWL     HALT 
        LD HL,TEXT_BUFFER_ATR1
        CALL OUTATR
        HALT 
        LD HL,TEXT_BUFFER_ATR2
        CALL OUTATR
        CALL #1F54
        RET NC
        JR C,MWL
        RET 

OUTATR  LD DE,#5804
        LD BC,#1818
OUTAL   PUSH BC
        LD B,0
        LDIR 
        EX DE,HL
        LD C,8
        ADD HL,BC
        EX DE,HL
        POP BC
        DJNZ OUTAL
        RET 



        ;-------- CLEAR SCREEN ROUTINES ------------------------
CLS     EI 
        HALT 
        LD HL,#5800
        LD DE,#5801
        LD BC,#02FF
        LD (HL),L
        PUSH HL
        LDIR 
        POP HL
        LD A,C
CLS2L   DEC HL
        LD (HL),A
        CP (HL)
        JR Z,CLS2L
        RET 

        ;-------- CLEAR BUFFER ROUTINES ------------------------
CLEAR_BUFFER
        XOR A
        LD HL,TEXT_BUFFER_BEGIN-1
CL_BR_L INC HL
        LD (HL),A
        CP (HL)
        JR Z,CL_BR_L
        RET 

        ;-------- OUTPUT BUFFER ROUTINES -----------------------
OUTPUT_BUFFER
        LD HL,TEXT_BUFFER_PIX
        LD DE,#4004
        LD BC,#0718
OTPBF_L PUSH BC
        PUSH HL

OTPBFL1 PUSH BC
        PUSH HL
        PUSH DE
        LD BC,#18
        LDIR 
        POP DE
        CALL DOWN_DE
        POP HL
        LD BC,24*24
        ADD HL,BC
        POP BC
        DJNZ OTPBFL1
        CALL DOWN_DE
        POP HL
        LD C,#18
        ADD HL,BC
        POP BC
        DEC C
        JR NZ,OTPBF_L
        RET 

        ;-------- PRINT PAGE ROUTINES --------------------------
PRINT_PAGE
        LD BC,#100
        EXX 
        LD HL,TEXT_BUFFER_PIX
        LD DE,TEXT_BUFFER_ATR2
PRNTPGL LD A,(IX)
        OR A
        RET Z
        BIT 7,A
        JR Z,NO_CHANGE_ATR
        EXX 
        AND #7F
        LD E,A
        INC IX
        LD D,(IX)
        EXX 
        JP PR_PG0
NO_CHANGE_ATR
        LD BC,#18
        CP ENTR_WR
        JR NZ,NO_ENTER_WR
        EXX 
        INC B
        EXX 
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        JR PR_PG0
NO_ENTER_WR
        CP ENTR
        JR NZ,NO_ENTER
        LD HL,TEXT_BUFFER_PIX-#18
        LD DE,TEXT_BUFFER_ATR2-#18
        EXX 
        INC B
        LD A,B
        LD C,0
        EXX 
        LD C,#18
ENTR_AL EX DE,HL
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        DEC A
        JR NZ,ENTR_AL
        JR PR_PG0
NO_ENTER
        CP TAB
        JR NZ,NO_TAB
        INC IX
        LD B,(IX)
TAB_L   INC HL
        INC DE
        CALL POS_MNG
        DJNZ TAB_L
        JR PR_PG0
NO_TAB
        ;---PRINT CHR
        PUSH DE
        PUSH HL
        PUSH HL
        LD L,A
        LD H,0

        DUP 3
        ADD HL,HL
        EDUP 

        LD BC,FONT-#100
        ADD HL,BC
        EX DE,HL
        POP HL
        LD BC,#240

        DUP 6
        LD A,(DE)
        LD (HL),A
        INC DE
        ADD HL,BC
        EDUP 
        LD A,(DE)
        LD (HL),A

        POP HL
        POP DE
        EXX 
        PUSH DE
        EXX 
        POP BC
        EX DE,HL
        LD (HL),C
        LD A,H
        DUP 3
        INC H
        EDUP 
        LD (HL),B
        LD H,A
        EX DE,HL
        INC HL
        INC DE
        CALL POS_MNG

PR_PG0  INC IX
        JP PRNTPGL

POS_MNG EXX 
        INC C
        LD A,C
        CP #18
        JR NZ,NO_NXTL
        LD C,0
        INC B
NO_NXTL EXX 
        RET 
        ;------- COUNTER FOR THE NEXT LINE ON SCR$ (DE) --------
DOWN_DE INC D
        LD A,D
        AND 7
        RET NZ
        LD A,E
        ADD A,#20
        LD E,A
        RET C
        LD A,D
        SUB 8
        LD D,A
        RET 

        ; ----- load font
FONT    INCBIN "razdolb_.f"

TEXT1   ATR5B
        DB "WATCHA"
        ATR3A
        DB "!",ENTR,ENTR
        ATR6B
        DB "IT"
        ATR3B
        DB "'"
        ATR6B
        DB "S "
        ATR3B
        DB "TIME "
        ATR2B
        DB "TO "
        ATR3A
        DB "GET"
        ATR4B
        DB TAB,20,"SOMETHING"
        ATR1A
        DB "...",ENTR
        ATR4B
        DB "..."
        ATR5A
        DB "SOMETHING "
        ATR2B
        DB "FROM"
        ATR3A
        DB TAB,18,"THE "
        ATR2A
        DB "DEEP "
        ATR1B
        DB "PAST"
        ATR1A
        DB TAB,8,"IN "
        ATR3B
        DB "GAMEMAKING"
        ATR5B
        DB TAB,19,"HYSTORY"
        ATR1A
        DB "."
        ATR2B
        DB "..."
        ATR6A
        DB "SOMETHING"
        ATR4B
        DB TAB,19,"REALLY "
        ATR3A
        DB "COOL "
        ATR3B
        DB "WHICH"
        ATR1A
        DB TAB,5,"INVADES "
        ATR5A
        DB "OUR"
        ATR2A
        DB TAB,15,"("
        ATR1B
        DB "AND "
        ATR3A
        DB "I "
        ATR2B
        DB "HOPE "
        ATR5B
        DB "YOUR"
        ATR2A
        DB ")"
        ATR6B
        DB TAB,14,"ATTENTION"
        ATR3A
        DB "."
        ATR3B
        DB "..."
        ATR4B
        DB "SOMETHING"
        ATR3A
        DB TAB,21,"SPECIAL "
        ATR4B
        DB "TO "
        ATR1A
        DB "HELP"
        ATR1B
        DB TAB,6,"YOU "
        ATR5B
        DB "TO "
        ATR2A
        DB "REMEMBER"
        ATR5A
        DB TAB,12,"THESE "
        ATR3B
        DB "SPLENDID"
        ATR6A
        DB TAB,14,"TAPE-TIMES"
        ATR1B
        DB "!"
        ATR1A
        DB "SO"
        ATR3A
        DB ",",ENTR_WR
        ATR6B
        DB "IT"
        ATR1A
        DB "'"
        ATR6B
        DB "S "
        ATR6A
        DB "TIME "
        ATR3B
        DB "TO "
        ATR2B
        DB "GET"
        ATR3A
        DB TAB,10,"THE "
        ATR2A
        DB "NEW"
        ATR5B
        DB TAB,12,"RELEASE",ENTR_WR
        ATR1B
        DB "FROM "
        ATR5A
        DB "US"
        ATR1A
        DB "!"
        DB 0

        ;-------- INSTALL ALL ----------------------------------
INSTALL LD HL,INST_
        LD DE,#4000
        LD BC,INSTALL_END-INST_
        PUSH DE
        LDIR 
        RET 
INST_
        DISP #4000
        RET 



        ENT 
INSTALL_END
ZUZU    DISPLAY "END: ",ZUZU
