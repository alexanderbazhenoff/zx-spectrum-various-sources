; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


START_ADR       EQU #6000
        ORG START_ADR

TEST            EQU 1

                ;!!! maximum lenght of text=#4EDE !!!

TRAINER_POINTS  EQU 4     ;минимум два!!!

                ;номера строк с "off / on":
NPOINT1         EQU 5
NPOINT2         EQU #A
NPOINT3         EQU #F
NPOINT4         EQU #14
                ;номер пустой строки:
NPOINTZ         EQU 1

SUN_ATTR        EQU #3A3E
ATTR_ALLOW      EQU #3838
ATTR_NORMAL     EQU SUN_ATTR

ALLOW           EQU 7
NORMAL          EQU 6

FONT_ADR        EQU #F900
MUS_ADR         EQU #E000
MUS_LEN         EQU #18BF
INT_VECTOR      EQU #6B00
                ;[#6C6C]

TXTROU_TABL_ADR EQU #6D00
TXTOUT_ROUT_ADR EQU TXTROU_TABL_ADR+#30
TXTLIN_ADDR     EQU #4200  ;[-#20!!!]
TXTATR_ADDR     EQU #5820
TXTLINES_COL    EQU #18
TXTLIN_BUF      EQU FONT_ADR+#600
ATRLIN_BUF1     EQU TXTLIN_BUF+36
ATRLIN_BUF2     EQU TXTLIN_BUF+36+18

TXTOUTMAIN_ADR1 EQU TXTROU_TABL_ADR+#1E50
TXTOUTMAIN_ADR2 EQU TXTROU_TABL_ADR+#2139
SUN_ATR_ROUT    EQU TXTROU_TABL_ADR+#1D58
TEXT_ADR        EQU TXTROU_TABL_ADR+#2422

        CALL INSTALL_ALL
        EI
        CALL NEXT_PAGE
MAIN_KOLBASSING
        EI
        HALT
        CALL TXTMOV_CONTR
        LD A,(KB_FN)
        CP #C9
        JR NZ,MAIN_KOLBASSING
        XOR A
        LD (FIRST_TXTLIN_NUMB),A
        LD HL,TRAINER_TEXT
        LD (TXTLINE_NEXTADDR),HL
        CALL NEXT_PAGE

NPOINT1=NPOINT1*2+TXTROU_TABL_ADR
NPOINT2=NPOINT2*2+TXTROU_TABL_ADR
NPOINT3=NPOINT3*2+TXTROU_TABL_ADR
NPOINT4=NPOINT4*2+TXTROU_TABL_ADR
NPOINTZ=NPOINTZ*2+TXTROU_TABL_ADR

        LD BC,(NPOINTZ)
        LD DE,TXTLIN_BUF
        LD HL,NPOINT1
        CALL INS_TS
        LD HL,NPOINT2
        CALL INS_TS
        IF0 TRAINER_POINTS-4
        LD HL,NPOINT3
        CALL INS_TS
        LD HL,NPOINT4
        CALL INS_TS
        ENDIF
        IF0 TRAINER_POINTS-3
        LD HL,NPOINT3
        CALL INS_TS
        ENDIF
DELAY   LD A,(KB_FN)
        OR A
        JR NZ,DELAY

TRAINER_KOLBASSING
        HALT
        LD A,(KB_FN)
        OR A
        JR Z,TRAINER_KOLBASSING
        CP 5
        CALL C,SWITCH_POINTER
        LD A,(KB_FN)
        CP #36
        JR Z,SWITCH_ALL
        CP #C9
        JR NZ,TRAINER_KOLBASSING
        CALL MUS_ADR
        LD HL,#2758
        EXX
        LD IY,#5C3A
        LD A,#3F
        LD I,A
        IM 1
        EI
        LD BC,0
        JP CLS2

;-------trainer routines--------
SWITCH_ALL
        DI
        LD A,TRAINER_POINTS
SWIT_AL PUSH AF
        DEC A
        CALL SWITCH_POINTER0
        POP AF
        DEC A
        JR NZ,SWIT_AL
        CALL PAUSE
        JR TRAINER_KOLBASSING

SWITCH_POINTER
        DI
        DEC A
        CALL SWITCH_POINTER0
PAUSE   EI
        LD B,#F
PAUSE_L HALT
        DJNZ PAUSE_L
        RET


SWITCH_POINTER0
        LD D,'FONT_ADR
        LD H,'TXTLIN_BUF
        LD E,A
        DUP 3
        ADD A,A
        EDUP
        LD L,A
        LD A,(DE)
        CPL
        LD (DE),A
        LD E,(HL)
        INC L
        LD D,(HL)
        INC L
        OR A
        JR Z,SWP_OFF
        INC L,L
SWP_OFF LDI
        LDI
        RET

INS_TS  LD A,L
        LD (DE),A
        INC E
        LD A,H
        LD (DE),A
        INC E
        PUSH BC
        LD BC,4
        LDIR
        POP BC
        DEC L
        LD (HL),B
        DEC L
        LD (HL),C
        INC E,E
        RET

;-------text movement controller
TXTMOV_CONTR
        LD A,(KB_FN)
        CP 9
        JP Z,NEXT_LINE
        CP 8
        JP Z,PREV_LINE
        CP 7
        JR Z,NEXT_PAGE
        CP 6
        JR Z,PREV_PAGE
        RET

TXTLINE_NEXTADDR DW TEXT_ADR+37

;-------print previous textpage---------
PREV_PAGE
        CALL PREV_LC
        LD HL,PREV_LINE
        JR PAGER

;-------print next textpage---------

NEXT_PAGE
        CALL NEXT_LC
        LD HL,NEXT_LINE
PAGER   RET Z
        LD (PAGE_SR),HL
        LD HL,OUT_TXTGFX_SW
        LD (HL),0
        PUSH HL
        LD B,6
PAGERL1 PUSH BC
        EI
        HALT
        DI
        LD B,4
PAGERL2 PUSH BC

        IFN TEST
        LD A,5
        OUT (#FE),A
        ENDIF

        CALL #CDCD
PAGE_SR EQU $-2

        IFN TEST
        LD A,7
        OUT (#FE),A
        ENDIF

        POP BC
        DJNZ PAGERL2
        POP BC
        DJNZ PAGERL1
        POP HL
        LD (HL),H
        EI
        RET

;-------print previous textline---------


TEMPLINE_DEC
        LD HL,FIRST_TXTLIN_NUMB
        LD A,(HL)
        DEC A
        CP #FF
        JR NZ,TLD_NZ
        LD A,#17
TLD_NZ  LD (HL),A
        RET

PREV_LC LD BC,37*#19
        LD HL,(TXTLINE_NEXTADDR)
        XOR A
        SBC HL,BC
        LD A,(HL)
        OR A
        RET

PREV_LINE
        IF0 TEST-1
        LD A,5
        OUT (#FE),A
        ENDIF

        CALL PREV_LC
        RET Z
        CALL COPY_TEXTLINE
        LD HL,(TXTLINE_NEXTADDR)
        LD C,37
        XOR A
        SBC HL,BC
        LD (TXTLINE_NEXTADDR),HL
        CALL TEMPLINE_DEC
;-------copy txt_gfx to output sr-------

        ;in:  A=line_num
COPY_TXTGFX

        DI
        ADD A,A
        LD L,A
        LD H,'TXTROU_TABL_ADR
        LD E,(HL)
        INC L
        LD D,(HL)
        EX DE,HL
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        DEC HL
        DEC HL
        LD (COPY_TXTGFX_SP),SP
        LD SP,HL
        LD A,6
        LD H,'TXTLIN_BUF
        LD D,'FONT_ADR+5
COPY_TXTGFX_L1
        EXA
        LD L,0

        DUP 8
        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #F0
        LD C,A
        INC L
        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #0F
        OR C
        LD C,A
        INC L

        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #F0
        LD B,A
        INC L
        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #0F
        OR B
        LD B,A
        INC L
        PUSH BC
        DEC SP,SP
        EDUP

        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #F0
        LD C,A
        INC L
        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #0F
        OR C
        LD C,A
        INC L

        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #F0
        LD B,A
        INC L
        LD A,(HL)
        LD E,A
        LD A,(DE)
        AND #0F
        OR B
        LD B,A
        PUSH BC

        DUP 4
        DEC SP
        EDUP
        DEC D
        EXA
        DEC A
        JP NZ,COPY_TXTGFX_L1

        LD DE,#1C5
        LD L,.ATRLIN_BUF1

        DUP 8
        LD C,(HL)
        INC L
        LD B,(HL)
        INC L
        PUSH BC
;       DEC SP,SP
        PUSH DE
        EDUP

        LD C,(HL)
        INC L
        LD B,(HL)
        PUSH BC

        DUP 4
        DEC SP
        EDUP
        LD L,.ATRLIN_BUF2

        DUP 8
        LD C,(HL)
        INC L
        LD B,(HL)
        INC L
        PUSH BC
;       DEC SP,SP
        PUSH DE
        EDUP

        LD C,(HL)
        INC L
        LD B,(HL)
        PUSH BC

        LD SP,#3131
COPY_TXTGFX_SP EQU $-2

        IF0 TEST-1
        LD A,7
        OUT (#FE),A
        ENDIF

        LD A,H
        OR A
        RET

;-------print next textline---------

NEXT_LC LD HL,(TXTLINE_NEXTADDR)
        LD A,(HL)
        OR A
        RET

NEXT_LINE
        IF0 TEST-1
        LD A,5
        OUT (#FE),A
        ENDIF

        CALL NEXT_LC
        RET Z
        CALL COPY_TEXTLINE
        LD (TXTLINE_NEXTADDR),HL
        LD A,(FIRST_TXTLIN_NUMB)
        CALL COPY_TXTGFX

TEMPLINE_INC
        LD HL,FIRST_TXTLIN_NUMB
        LD A,(HL)
        INC A
        CP #18
        JR NZ,TLI_NZ
        XOR A
TLI_NZ  LD (HL),A

        RET

;-------copy text and attributes to linebuffer------

        ;in:  HL=text_addr
        ;     [#od] - enter
        ;     [#o6] - normal colour
        ;     [#o7] - allow colour
        ;out: HL=next_addr

COPY_TEXTLINE
        EXX
        LD HL,ATRLIN_BUF1
        LD DE,ATRLIN_BUF2
        LD BC,ATTR_NORMAL
        EXX
        LD DE,TXTLIN_BUF
        LD B,18
        CALL COPY_TL_AL
COPY_TL_L1
        CALL COPY_TL_AL
        LD (DE),A
        INC E
        CALL COPY_TL_AL
        LD (DE),A
        INC E
        EXX
        LD (HL),B
        LD A,C
        LD (DE),A
        INC L
        INC E
        EXX
        DJNZ COPY_TL_L1
        RET

COPY_TL_AL
        LD A,(HL)
        INC HL
        CP ALLOW+1
        RET NC
        EXX
        CP NORMAL
        JR Z,COPYTN
        LD BC,ATTR_ALLOW
        EXX
        RET
COPYTN  LD BC,ATTR_NORMAL
        EXX
        RET

;-------clear screen-------
CLS     LD BC,#3F07
CLS2    HALT
        CALL CLS1
CLS0    LD HL,#5800
        XOR A
CLS_L   DEC HL
        LD (HL),A
        OR (HL)
        JR Z,CLS_L
        RET
CLS1    LD A,C
        OUT (#FE),A
        LD HL,#5800
        LD DE,#5801
        LD (HL),B
        LD BC,#02FF
        LDIR
        RET

;-------keyboard scan---------

KEYBOARD_SCAN
        LD HL,KB_FN
      ;--o/p/q/a/space
        LD BC,#FBFE
        IN A,(C)
        RRA
        JR NC,KB_UP
        LD B,#FD
        IN A,(C)
        RRA
        JR NC,KB_DOWN
        LD B,#DF
        IN A,(C)
        RRA
        JR NC,KB_PAGEDN
        RRA
        JR NC,KB_PAGEUP
        LD B,#7F
        IN A,(C)
        RRA
        JR NC,KB_SPC
      ;--enter
        LD B,#BF
        IN A,(C)
        RRA
        JR NC,KB_ENTER
      ;--cs
        LD B,#FE
        IN A,(C)
        RRA
        LD B,#EF
        JR NC,KB_CURSORE_PGUPDN
      ;--sinclair2
        IN A,(C)
        RRA
        JR NC,KB_SPC
        RRA
        JR NC,KB_UP
        RRA
        JR NC,KB_DOWN
        RRA
        JR NC,KB_PAGEDN
        RRA
        JR NC,KB_PAGEUP
        LD E,1
        LD B,#F7
        IN A,(C)
        RRA
        JR NC,KB_NUM1_4
        INC E
        RRA
        JR NC,KB_NUM1_4
        IFN TRAINER_POINTS-2
        DUP TRAINER_POINTS-2
        INC E
        RRA
        JR NC,KB_NUM1_4
        EDUP
        ENDIF
KB_END  XOR A
        LD (HL),A
        RET

KB_CURSORE_PGUPDN
      ;--cursore/pg_up/pg_dn
        IN A,(C)
        RRA
        RRA
        RRA
        JR NC,KB_PAGEDN
        RRA
        JR NC,KB_UP
        RRA
        JR NC,KB_DOWN
        LD B,#F7
        IN A,(C)
        RRA
        RRA
        RRA
        JR NC,KB_PAGEUP
        RRA
        JR NC,KB_PAGEDN
        RRA
        JR NC,KB_PAGEUP
        JR KB_END

KB_FN   DB #00
        ;last key: [#oo]       - none
        ;          [#o1...#o4] - 1...4
        ;          [#o6]       - page up
        ;          [#o7]       - page down
        ;          [#o8]       - txt up
        ;          [#o9]       - txt down
        ;          [#C9]       - space,0
        ;          [#36]       - enter

KB_PAGEUP
        LD (HL),6
        RET
KB_PAGEDN
        LD (HL),7
        RET
KB_UP
        LD (HL),8
        RET
KB_DOWN
        LD (HL),9
        RET
KB_SPC
        LD (HL),#C9
        RET
KB_ENTER
        LD (HL),#36
        RET
KB_NUM1_4
        LD (HL),E
        RET

;-------int routines----------

INT_ROUTINES
        DI
        PUSH AF,BC,DE,HL
        CALL MUS_ADR+5
        CALL KEYBOARD_SCAN

        IFN TEST
        LD A,4
        OUT (#FE),A
        ENDIF

        ;-----fill sun_attr
        LD A,0
COUNTER1 EQU $-1
        CPL
        LD (COUNTER1),A
        OR A
        LD A,'SUN_ATTR
        JR NZ,SUN_ATTR_NO_SWITCH
        XOR ('SUN_ATTR!.SUN_ATTR)
SUN_ATTR_NO_SWITCH
        LD B,A
        LD C,A
        CALL SUN_ATR_ROUT

        IFN TEST
        LD A,#3
        OUT (#FE),A
        ENDIF

        CALL TXTGFX_KERN

        IFN TEST
        LD A,7
        OUT (#FE),A
        ENDIF

        POP HL,DE,BC,AF
        EI
        RET

        ;-----out txtgfx
TXTGFX_KERN
        LD A,0
OUT_TXTGFX_SW EQU $-1
        OR A
        RET Z

        LD A,(COUNTER1)
        OR A
        LD A,#00
FIRST_TXTLIN_NUMB EQU $-1
        JP Z,TXTOUTMAIN_ADR2
        JP TXTOUTMAIN_ADR1

;*******install all*********************

INSTALL_ALL
        CALL CLS
        LD HL,SCR_FONT
        LD BC,#4020
        CALL CONV_SCR
        DI
        LD HL,#4000
        LD DE,FONT_ADR
;       LD BC,#600
        LD B,6
        LDIR
;       LD HL,#5800
        LD H,#58
        CALL CLS0
        LD HL,SRC_LOGO
        LD BC,#C00C
        CALL CONV_SCR

        LD HL,SRC_MUS_END
        LD DE,MUS_ADR+MUS_LEN
        LD BC,SRC_MUS_END-SRC_TEXT
        LDDR
        EX DE,HL
        INC HL

;-------converting text----------
        XOR A
;       LD HL,SRC_TEXT
        LD DE,TEXT_ADR
        INC HL
        LD B,37
CONV_ZL LD (DE),A
        INC DE
        DJNZ CONV_ZL

CONV_TXT_L
        LD B,36
        LD A,NORMAL
        LD (DE),A
        LD A,(HL)
        CP ALLOW+1
        JR NC,CONV_NA
        INC HL
        LD (DE),A
CONV_NA INC DE
CONV_TXT_L1
        LD A,(HL)
        INC HL
        CP #0D
        JR Z,CONV_ENTER
        LD (DE),A
        INC DE
        DJNZ CONV_TXT_L1
CONV_ENTER
        LD A,B
        OR A
        JR Z,CONV_TXT_NFS ;)
        LD A,#20
CONV_TXT_FS_L
        LD (DE),A
        INC DE
        DJNZ CONV_TXT_FS_L
CONV_TXT_NFS ;)
        LD A,(HL)
        OR A
        JR NZ,CONV_TXT_L
        LD (DE),A

;-------decrunch output lines sr-------
DECRUNCH_OSR
        LD DE,TXTROU_TABL_ADR
        LD HL,TXTOUT_ROUT_ADR
        EXX
        LD B,TXTLINES_COL
TXT_OUT_DECR0
        EXX
        LD B,H
        LD C,L
        EX DE,HL
        LD (HL),C
        INC L
        LD (HL),B
        INC L
        EX DE,HL

        LD (HL),#ED
        INC HL
        LD (HL),#73
        INC HL
        PUSH HL
        INC HL
        INC HL
        CALL TXTOUT_DECRB0
        LD (HL),#EB
        INC HL
        CALL TXTOUT_DECRB0
        LD (HL),#D9
        INC HL
        LD C,6
TXTOUT_DECR1
        LD (HL),#F9
        INC HL
TXTOUT_DECR2
        CALL TXTOUT_DECRB
        LD (HL),#24
        INC HL
        DEC C
        JR NZ,TXTOUT_DECR1
        DEC HL
        LD (HL),#31
        INC HL
        PUSH HL
        EXX
        POP DE
        POP HL
        LD (HL),E
        INC HL
        LD (HL),D
        PUSH DE
        EXX
        POP HL
        INC HL
        INC HL
        LD (HL),#C9
        INC HL
        EXX
        DJNZ TXT_OUT_DECR0
        EXX

;-------decrunch sun_attr fill sr--------
DECR_SUN_ATR
;       LD HL,SUN_ATR_ROUT
        LD DE,#5800+14
        LD BC,#718

INSTALL_SP_SAVE
        LD (HL),#ED
        INC HL
        LD (HL),#73
        INC HL
        LD (INS_SP_RESTORE),HL
        INC HL
        INC HL

DECR_SUN_ATR_L0
        PUSH BC
        LD (HL),#31
        INC HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
DECR_SUN_ATR_L1
        LD (HL),#C5
        INC HL
        DJNZ DECR_SUN_ATR_L1
        LD C,#20
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        POP BC
        DEC C
        JR NZ,DECR_SUN_ATR_L0
INSTALL_SP_REST
        LD (HL),#31
        INC HL
        LD (#2222),HL
INS_SP_RESTORE EQU $-2
        INC HL
        INC HL
        LD (HL),#C9
        INC HL

        ;LD HL,TXTOUT_MAIN_ADR
        LD A,#EB
        CALL INSTALL_TXTROU_MAIN
        XOR A
        CALL INSTALL_TXTROU_MAIN

        LD HL,INT_VECTOR
;       LD B,L
        LD A,H
        LD I,A
        INC A
INT_INIT_L
        LD (HL),A
        INC HL
        DJNZ INT_INIT_L
        LD (HL),A
        LD L,A
        LD H,A
        LD (HL),#C3
        INC HL
        LD (HL),.INT_ROUTINES
        INC HL
        LD (HL),'INT_ROUTINES
        IM 2
        CALL MUS_ADR

        RET

INSTALL_TXTROU_MAIN
        EXA

        EXX
        LD DE,TXTATR_ADDR
        LD BC,#20
        EXX

        LD B,TXTLINES_COL
        LD DE,TXTLIN_ADDR

INSTALL_TXTROU_MAIN_L
        PUSH BC,DE
        EX DE,HL
        LD HL,INSTALL_DATA1
        LD BC,INSTALL_DATA2-INSTALL_DATA1
        LDIR
        EX DE,HL
        POP DE
        PUSH DE
        PUSH HL
        INC HL
        INC HL
        EX DE,HL
        LD C,#20
        ADD HL,BC
        EX DE,HL
        LD (HL),#21
        INC HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD (HL),#D9
        INC HL
        LD (HL),#21
        INC HL
        PUSH HL
        EXX
        POP HL
        LD (HL),E
        INC HL
        LD (HL),D
        EX DE,HL
        ADD HL,BC
        EX DE,HL
        EXX
        INC HL
        INC HL
        LD (HL),#16
        INC HL
        LD (HL),#16
        INC HL
        EXA
        LD (HL),A
        INC HL
        EXA
        LD (HL),#CD
        INC HL
        POP DE
        EX DE,HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC DE
        INC DE
        LD HL,INSTALL_DATA2
        LD C,INSTALL_DATA2E-INSTALL_DATA2
        LDIR
        EX DE,HL
        POP DE
        LD A,E
        ADD A,#20
        LD E,A
        JR NC,INSTALL_TXTROU_MAIN0
        LD A,D
        ADD A,8
        LD D,A
INSTALL_TXTROU_MAIN0
        POP BC
        DJNZ INSTALL_TXTROU_MAIN_L
        LD (HL),#C9
        INC HL
        RET

INSTALL_DATA1
        LD H,'TXTROU_TABL_ADR
        LD L,A
        SLA L
        LD E,(HL)
        INC L
        LD D,(HL)
        DB #ED,#53
INSTALL_DATA2
        INC A
        CP #18
        JR NZ,INSTALL_DATA2E
        XOR A
INSTALL_DATA2E

TXTOUT_DECRB0
        LD (HL),#F9
        INC HL
TXTOUT_DECRB
        LD B,9
TXTOUT_DECRB1
        LD (HL),1
        DUP 3
        INC HL
        EDUP
        LD (HL),#C5
        INC HL
        DJNZ TXTOUT_DECRB1
        RET

CONV_SCR
        LD DE,#4000
CSLOOP  PUSH BC
        PUSH DE
CSLOOP1 LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        LD A,D
        AND 7
        JR NZ,CSLOOP0
        LD A,E
        SUB #E0
        LD E,A
        SBC A,A
        AND #F8
        ADD A,D
        LD D,A
CSLOOP0 DJNZ CSLOOP1
        POP DE
        INC DE
        POP BC
        DEC C
        JR NZ,CSLOOP
        RET

TRAINER_TEXT
        DB 6,".fuckin trainer.yep.fuckin trainer.."         ;00
        DB 6,"                                    "         ;01
        DB 7,"          unlimit хрнвина номер один"         ;02
        DB 6,"[эта хрнвина нужна для бесконечного "         ;03
        DB 6,"            и очень смачного йцукен]"         ;04
        DB 7,"                           off",6,"/ on "     ;05
        DB 6,"                           off /",7,"on "     ;06
        DB 7,"           unlimit хрнвина номер два"         ;07
        DB 6,"[эта хрнвина помогает чувакам       "         ;08
        DB 6,"                страдающим йцукенгш]"         ;09
        DB 7,"                           off",6,"/ on "     ;0A
        DB 6,"                           off /",7,"on "     ;0B
        DB 7,"           unlimit хрнвина номер два"         ;0C
        DB 6,"[эта хрнвина помогает беременным    "         ;0D
        DB 6,"          телкам при фывапролдячсми]"         ;0E
        DB 7,"                           off",6,"/ on "     ;0F
        DB 6,"                           off /",7,"on "     ;10
        DB 7,"           unlimit хрнвина номер три"         ;11
        DB 6,"[а эта хрнвина вообще нахрен никому "         ;12
        DB 6,"                           не нужна]"         ;13
        DB 7,"                           off",6,"/ on "     ;14
        DB 6,"                           off /",7,"on "     ;15
        DB 7,"               1...4",6,"- select items,"     ;16
        DB 7,"   enter",6,"- toggle,"                       ;17
            DB 7,"0 / space",6,"- start"

        ;типа мысль (чтоб потом не забыть):
        ;а может в начале строк вместо #06
        ;#20 ставить?
        ;или ну его на икс??? ;)


ENDCOD  DISPLAY "lenght of code: ",ENDCOD-START_ADR

SRC_LOGO
        INCBIN "sun_logo"

SRC_TEXT DB 0
        INCBIN "sun_txt"
        DB #D
        DB 0
SRC_MUS
;       INCBIN "sun_mus"
        DS #C9,#C9
SRC_MUS_END
SCR_FONT
        INCBIN "sun_fnt.f"
ENDOBJ  DISPLAY "total lenght: ",ENDOBJ-START_ADR

        ORG START_ADR
