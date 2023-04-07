; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


; text converter for info viewer by alx^brainwave


TESTMOD EQU 1

ADDR    EQU #6402
CONVTO  EQU #6400

 DISPLAY "text converter v1.0 for text viewer"
 DISPLAY
 DISPLAY "input:  text file with name 'textXXX.W'"
 DISPLAY "        xxx is a number of file in DEC (000...127"
 DISPLAY "output: converted file with name 'blokXXX.C'
 DISPLAY
 DISPLAY "WARNING! текстовый файл не должен начинаться с #0D"
 DISPLAY "(код enter'а) и каждая строка текста в файле"
 DISPLAY "должна быть раскрашена и должна заканчиваться"
 DISPLAY "CR (код #0D)! Ошибки дисковых операций не"
 DISPLAY "перехватываются, так что если кто-то хочет"
 DISPLAY "overwrite'ить файлы советую TR-DOS 6.05E :)"

INVERS  EQU 0

        ORG #6000
L_BEG_OBJECT
        DI
        LD SP,#6000
        XOR A
        OUT (#FE),A
        LD A,7
        LD (23624),A
        LD (23693),A
START   LD A,"0"
        LD HL,FILE_NO
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        CALL 3435
        LD HL,HEAD_TXT
        CALL PRINT
DCNG_L  LD HL,SRC_DRIV
        LD A,(HL)
        ADD A,"A"
        LD (SD_TXT0),A
        INC HL
        LD A,(HL)
        ADD A,"A"
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
        LD A,(SRC_DRIV)
        LD C,A
        LD A,(DST_DRIV)
        CP C
        LD B,#C9
        JR Z,ONE_DRIV
        LD C,1
        CALL #3D13
        LD C,#18
        CALL #3D13
        LD B,0
ONE_DRIV
        LD A,B
        LD (SRC_DRIV_SEL),A
        LD (DST_DRIV_SEL),A
        LD A,(SRC_DRIV)
        LD C,1
        CALL #3D13
        LD C,#18
        CALL #3D13
EXECUT_L
        LD DE,SRC_DISCR+4
        CALL FILE_NO_COPY
        LD DE,DST_DISCR+4
        CALL FILE_NO_COPY

        LD HL,SRC_DISCR
        LD A,"W"
        CALL DISCR_COPY

        LD HL,SEAR_TXT
        CALL PRINT
        LD HL,SELO_TXT
        CALL PRINT

        LD A,9
        LD (23814),A
        LD C,#0A
        CALL #3D13
        LD A,C
        CP #FF
        JP Z,NO_CONV
        LD C,8
        CALL #3D13
        LD HL,LOAD_TXT
        CALL PRINT
        LD HL,FNAM_TX0
        CALL PRINT
        LD HL,SELO_TXT
        CALL PRINT
        LD HL,(#5CE8)
        LD (LENGHT_OF_TEXT),HL
        LD A,L
        OR A
        JR Z,FPRIT
        INC H
FPRIT   LD B,H
        LD DE,(#5CEB)
        LD HL,ADDR
        LD C,5
        CALL #3D13

        ;converting routines
        DI
        LD IX,ADDR
        LD HL,ADDR
        LD BC,#0101
LENGHT_OF_TEXT EQU $-2

CONV1   LD A,(IX)
        CP #0C
        JR NZ,CONV2
        INC IX
        DEC BC
        LD A,(IX)
        ADD A,7
        CP #0D
        JR NZ,CONV2
        LD A,15
CONV2   LD (HL),A
        INC IX
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,CONV1
        LD (HL),#0D
        INC HL
        PUSH HL
        XOR A
        LD (HL),A
        LD D,H
        LD E,L
        INC DE
        LD C,#FF
        LDIR
        POP HL
        LD BC,ADDR
        SBC HL,BC
        PUSH HL

        LD HL,CONVTO
        LD IX,ADDR
        PUSH HL
CONV3   LD (CONV_AI),HL
        INC HL
CONV4   LD A,(IX)
        OR A
        JR Z,CONVEND
        CP #0D
        JR Z,CONVENT
        LD (HL),A
        INC IX
        INC HL
CONV5   LD A,(IX)
        CP #0D
        JR Z,CONV6
        LD (HL),A
        INC IX
        INC HL
        JR CONV5

CONV6   LD A,(IX-1)
        CP 16
        JR NC,CONV7
        LD (#0000),A
CONV_AI EQU $-2
        DEC HL
        LD (HL),#0D
        INC HL
        INC IX
        JR CONV3

CONV7   LD (HL),#0D
        LD DE,(CONV_AI)
        LD H,D
        LD L,E
        INC HL
CONV8   LD A,(HL)
        CP #0D
        JR Z,CONV9
        LD (DE),A
        INC HL
        INC DE
        JR CONV8
CONV9   LD (DE),A
        INC HL
        INC DE
        INC IX
        EX DE,HL
        JR CONV3

CONVENT DEC HL
CONVENT1
        LD A,(IX)
        CP #0D
        JR NZ,CONV3
        LD (HL),A
        INC IX
        INC HL
        JR CONVENT1

CONVEND LD (HL),0
        INC HL
        LD (HL),0
        POP HL
        POP DE
        PUSH HL
        ADD HL,DE
        DEC HL
FNDENDL LD A,(HL)
        CP #0D
        JR NZ,F_END
        DEC HL
        DEC DE
        DJNZ FNDENDL
F_END   INC DE
        PUSH DE
        ;end of converting routines


        LD HL,SAVE_TXT
        CALL PRINT
        LD HL,FNAM_TX1
        CALL PRINT
        LD HL,SAV0_TXT
        CALL PRINT

        LD A,"C"
        LD HL,DST_DISCR
        CALL DISCR_COPY

        CALL DST_DRIV_SEL

        POP DE
        POP HL
        LD C,#0B
        CALL #3D13

        CALL SRC_DRIV_SEL

NO_CONV
        CALL FNAM_ADD
        LD HL,FILE_NO
        LD DE,FILE_END
        LD B,3
FNOC_L  LD A,(DE)
        CP (HL)
        JP NZ,EXECUT_L
        INC HL
        INC DE
        DJNZ FNOC_L

        LD HL,DONE_TXT
        CALL PRINT
        EI
        RES 5,(IY+1)
DWKEY   BIT 5,(IY+1)
        JR Z,DWKEY
GEXECTL JP START


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
        PUSH HL
        LD A,2
        CALL 5633
        POP HL
PRINTL  LD A,(HL)
        CP #FF
        RET Z
        PUSH HL
        RST #10
        POP HL
        INC HL
        JR PRINTL

FILE_NO_COPY
        LD HL,FILE_NO
        LD BC,3
        LDIR
        RET
DISCR_COPY
        LD C,#13
        PUSH AF
        CALL #3D13
        POP AF
        LD (#5CE5),A
        RET


SRC_DRIV DB 0
DST_DRIV DB 0
HEAD_TXT DB #13,1,"Text converter V0.1",#13,0," from ACEedit"
         DB "to Alx's viewer for ",#13,1,"CRP #3",#0D,#0D,#0D
         DB #13,1,"Please select:",#0D,#0D
         DB #13,1,"1.",#13,0," Source drive:",#0D
         DB #13,1,"2.",#13,0," Destination drive:",#0D,#0D
         DB "Press ",#13,1,"ENTER",#13,0," to start."
         DB #FF
SD_TXT   DB #13,1,#16,6,17
SD_TXT0  DB 17
DD_TXT   DB #13,1,#16,7,22
DD_TXT0  DB #FF,#FF
LOAD_TXT DB #16,9,0,#13,0,"Loading",#FF
SAVE_TXT DB #16,9,0,#13,0,"Saving",#FF
SEAR_TXT DB #16,9,0,#13,0,"Searching"
FNAM_TX0 DB #13,1," '"
SRC_DISCR
         DB "text    ",#FF
SELO_TXT DB ".W'",#13,0,"...  ",#FF
SAV0_TXT DB ".C'",#13,0,"...   ",#FF
FNAM_TX1 DB #13,1," '"
DST_DISCR
         DB "blok    ",#FF
DONE_TXT DB #13,1,#16,10,0,"Done! ",#13,0,"Press any key.",#FF
FILE_NO  DB "000"
FILE_END DB "128"
L_END_OBJECT

        DISPLAY
        DISPLAY "Test mode is "

        IF0 TESTMOD
        DISPLAY /L,"off."
        ELSE
        DISPLAY /L,"on. RUN and get the saved object!"
        ENDIF

INVERS=#4803
        DUP 8
        ORG INVERS
        DUP 10
        DB #FF-{$}
        EDUP
INVERS=INVERS+#100
        EDUP

        ORG #6000

        IFN TESTMOD
        ORG ADDR
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

DESCR_OBJ DB "convtextC"
BASIC_BEG
 DB 0,1,#24,#00,#FD,#B0,#22,"24575",#22,#3A,#F9,#C0,#B0,#22
 DB "15619",#22,#3A,#EA,#3A,#F7,#22,"convtext",#22,#AF,#0D
 DB #80,#AA,1,0
BASIC_END
        ENDIF
