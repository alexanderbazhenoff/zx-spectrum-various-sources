ATRBUF  EQU #8400
ADRBUF  EQU #BA00
PHASES  EQU 33
CHECK   EQU 0
FADBEF  EQU 0
FADOUT  EQU 3

LOAD_DEP_RUN    EQU #5D7C
LOAD_DEP        EQU LOAD_DEP_RUN+1
DEP             EQU #5D92

PART            EQU #5B16
CHEAT           EQU 1

TRACKSEC        EQU #2606


        ORG PART
        DB 1

        ORG PART-2
        IFN CHEAT
        DW #FFFF
        ELSE 
        DW 0
        ENDIF 

        ORG #5D3B
        INCBIN "LOADER.B"

        ORG #6000
        JP START
FADEOUT0
        DI 
        LD HL,#2758
        EXX 
WAITK   XOR A
        IN A,(#FE)
        CPL 
        AND #1F
        JR Z,WAITK
        LD B,8
FADO0_  PUSH BC
        EI 
        DUP FADOUT
        HALT 
        EDUP 
        LD HL,#5800
        CALL FADE_
        POP BC
        DJNZ FADO0_
        RET 

FADE_   ;LD BC,#300
        LD B,3
FAD_LP  LD D,(HL)
        LD A,D
        AND 1+2+4
        OR A
        JR Z,NODINK
        DEC D
NODINK  LD A,D
        AND 8+16+32
        OR A
        JR Z,NODPAP
        LD A,D
        SUB 8
        LD D,A
NODPAP  LD (HL),D
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,FAD_LP
        RET 
TEST128K
        LD HL,#FFFF
        LD DE,#1310
        CALL TEST128_
        JR Z,MODE128
        XOR A
MODE128 LD (#5B5C),A
        RET 

TEST128_
        LD BC,#7FFD
        OUT (C),E
        LD (HL),E
        OUT (C),D
        LD (HL),D
        OUT (C),E
        LD A,(HL)
        CP E
        RET 
SKIPSEC LD HL,(#5CF4)
SKIPSC_ INC L
        BIT 4,L
        JR Z,SKIPSC1
        LD L,0
        INC H
SKIPSC1 DJNZ SKIPSC_
        LD (#5CF4),HL
        RET 
START
        DI 
        LD SP,#6000
        LD HL,#2758
        EXX 
        LD A,(PART)
        OR A
        JR Z,PART1
        CP 1
        JR Z,PART2

        ;---- PART3
PART3   LD HL,SCREEN3
        CALL MOVESCR
        CALL OUTSCR
        CALL TEST128K
        LD B,#56+#10+#4E
        CALL SKIPSEC
        LD HL,YO_DAT3
        LD DE,#A700
        LD B,1
        LDIR 
        LD HL,LO_YO3
        LD DE,#5B90
        LD C,ELO_YO3-LO_YO3
        JR PART0_

        ;---- PART1
PART1   CALL OUTSCR
        LD HL,YO_DAT1
        LD DE,#B700
        LD B,1
        LDIR 
        LD HL,LO_YO1
        LD C,ELO_YO1-LO_YO1
PART_   LD DE,#5D3B
PART0_  PUSH DE
        LDIR 
        RET 

        ;---- PART2
PART2   LD HL,SCREEN2
        CALL MOVESCR
        CALL OUTSCR
        CALL TEST128K
        LD HL,YO_DAT2
        LD DE,#7300
        LD B,1
        LDIR 
        LD A,#C9
        LD (DEP),A
        LD B,#56
        CALL SKIPSEC
        LD HL,#6300
        PUSH HL
        PUSH HL
        PUSH HL
        LD B,#10
        CALL LOAD_DEP
        POP HL
        LD A,(#5B5C)
        OR A
        JR Z,PART2481
        DI 
        CALL DEP+1
        CALL #6300
PART2481
        POP HL
        LD B,#4E
        CALL LOAD_DEP
        ;--- REINSTALL DEPACKER
        LD HL,#4000
        LD (DEP+#CC),HL
        LD (DEP+#ED),HL
        LD HL,#447F
        LD (DEP+#1D),HL
        INC HL
        LD (DEP+#55),HL
        LD (DEP+#83),HL
        LD (DEP+#EA),HL
        LD HL,#45A0
        LD (DEP+#52),HL
        ;--- END OF REINSTALL
        LD A,(#5B5C)
        OR A
        JR NZ,PART2128A
        CALL FADEOUT0
PART2128A
        DI 
        POP HL
        LD BC,#7FFD
        LD A,#18
        OUT (C),A
        PUSH BC
        CALL DEP+1
        POP BC
        LD A,(#5B5C)
        OR A
        JR Z,PART2482
        PUSH BC
        LD A,#1F
        OUT (C),A
        LD HL,#C000
        LD DE,#4000
        LD B,8
        LDIR 
        POP BC
        LD A,#10
        OUT (C),A
        CALL FADEOUT0
PART2482
        JP #A8ED

MOVESCR LD DE,SCREEN
        LD BC,#1B00
        LDIR 
        RET 

        ;-- LOADER1
LO_YO1
        DISP #5D3B
        LD HL,#6100
        LD B,#56
        CALL LOAD_DEP
        JP #F800
        ENT 
ELO_YO1
        ;-- LOADER3
LO_YO3
        DISP #5B90
        LD A,#C9
        LD (DEP),A
        LD HL,#6000
        PUSH HL
        LD B,#47
        CALL LOAD_DEP
        LD A,(#5B5C)
        OR A
        JR Z,LO_YO348
        LD A,#11
        CALL LO_YO3_BANK
        LD HL,#C000
        LD B,#A
        CALL LOAD_DEP
        LD HL,#C162
        LD DE,#CA00
        LD B,1
        LDIR 
        LD A,#F3
        LD (DEP),A
        LD HL,#D200
        LD B,9
        CALL LOAD_DEP
        LD HL,#C200
        CALL DEP
        LD A,#10
        CALL LO_YO3_BANK
LO_YO348
        DI 
        POP HL
        CALL DEP+1
LO_YO3WK
        XOR A
        IN A,(#FE)
        CPL 
        AND #1F
        JR Z,LO_YO3WK
        LD HL,#300
        LD (#73C5),HL
        JP #7354
LO_YO3_BANK
        DI 
        LD BC,#7FFD
        LD (#5B5C),A
        OUT (C),A
        RET 
        ENT 
ELO_YO3

YO_DAT1 INCBIN "y1#1B.o"
YO_DAT2 INCBIN "y2#2#BA.o"
YO_DAT3 INCBIN "y3#3B.o"
YO_EDAT

OUTSCR  DI 
        LD HL,#BE00
        LD B,L
        LD A,H
        LD I,A
        INC A
INT_IL  LD (HL),A
        INC HL
        DJNZ INT_IL
        LD (HL),A

        IFN CHECK
        LD HL,#5800
        LD BC,#300
        LD D,B
        LD E,C
CHA_L   LD A,(HL)
        OR A
        JR NZ,NO0ATR
        DEC DE
NO0ATR  DEC BC
        INC HL
        LD A,B
        OR C
        JR NZ,CHA_L
        LD A,D
        OR E
        JR Z,NOFADE0
        ENDIF 

        IFN FADBEF
FADEP   LD DE,ATRBUF
        ;LD HL,#5800
        LD H,#58
        LD BC,#300
        PUSH DE
        PUSH HL
        LDIR 
        POP DE
        POP HL
        LD B,8
FADEPL  PUSH BC
        PUSH AF
        PUSH DE
        PUSH HL
        PUSH HL
        EI 
        DUP FADOUT
        HALT 
        EDUP 
        LD B,3
        LDIR 
        POP HL
        CALL FADE_
        POP HL
        POP DE
        POP AF
        POP BC
        DJNZ FADEPL
        LD D,#40
        ELSE 
        LD DE,#4000
        ENDIF 

NOFADE0 LD HL,SCREEN
        LD BC,#C020
LOOP    PUSH BC
        PUSH DE
LOOP1   LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        LD A,D
        AND 7
        JR NZ,AROUND
        LD A,E
        SUB #E0
        LD E,A
        SBC A,A
        AND #F8
        ADD A,D
        LD D,A
AROUND  DJNZ LOOP1
        POP DE
        INC DE
        POP BC
        DEC C
        JR NZ,LOOP
        LD DE,ATRBUF+#1500
        LD B,3
        PUSH HL
        PUSH BC
        LDIR 
        POP BC
        POP HL
        ;LD DE,ATRBUF
        LD D,'ATRBUF
        PUSH DE
        LDIR 
        POP HL
        LD B,6
        ;LD DE,ATRBUF+#1200
        LD D,'ATRBUF+#12
SFAD_L  PUSH BC
        PUSH HL
        PUSH HL
        PUSH DE
        CALL FADE_
        POP DE
        POP HL
        LD B,3
        LDIR 
        LD A,D
        SUB 6
        LD D,A
        POP HL
        POP BC
        DJNZ SFAD_L
        ;LD HL,#C000
        LD H,#C0
        LD DE,#1017
        CALL TEST128_
        JP NZ,MODE48
        LD A,#C3
        LD (#BFBF),A
        LD HL,INT
        LD (#BFC0),HL
        IM 2
        DI 
        LD HL,#4000
        LD DE,#C000
        LD BC,#1B00
        LDIR 
        ;LD HL,ATRBUF
        LD H,'ATRBUF
        LD DE,ATRBUF+1
        LD BC,#2FF
        LD (HL),L
        LDIR 
        LD A,'ATRBUF
        LD HL,ADRBUF
        LD DE,ADRBUF+1
CRADTL  LD B,1
        LD (HL),A
        LDIR 
        INC A
        CP ATRBUF/#100+3
        JR NZ,CRADTL
        PUSH IY
        XOR A
OUT_ML  PUSH AF
        INC A
        LD (PHASE),A
        EI 
        HALT 
        LD DE,#D800
        LD L,E
        LD IX,TABL
        LD IY,ADRBUF
        LD B,3
OUT_L1  LD A,(IX)
        CP 0
PHASE   EQU $-1
        JR NC,NOFADZ1
        LD A,(IY)
        CP ATRBUF/#100+#15
        JR NC,NOFADZ
        ADD A,3
        LD (IY),A
NOFADZ  LD H,A
        INC IY
        INC IX
        LDI 
        JP PE,OUT_L1
ALLATR  POP AF
        INC A
        CP PHASES
        JR NZ,OUT_ML
        POP IY
        LD A,#10
        LD BC,#7FFD
        OUT (C),A
        IM 1
        EI 
        RET 

NOFADZ1 INC IY
        INC IX
        INC L
        INC DE
        DEC BC
        LD A,B
        OR C
        JR NZ,OUT_L1
        JR ALLATR

MODE48  LD B,7
        ;LD HL,ATRBUF+#300
        LD H,'ATRBUF+3
OUT_L   PUSH BC
        LD DE,#5800
        LD BC,#300
        EI 
        DUP FADOUT
        HALT 
        EDUP 
        LDIR 
        POP BC
        DJNZ OUT_L
        RET 

INT     DI 
        PUSH AF
        PUSH BC
        LD A,#15+8
SCREENP EQU $-1
        LD BC,#7FFD
        OUT (C),A
        XOR 8+2
        LD (SCREENP),A
        POP BC
        POP AF
        RET 
TABL    INCBIN "PLASMTBL"
SCREEN  INCBIN "y1$$"
SCREEN2 INCBIN "y2$$"
SCREEN3 INCBIN "y3$$"
ENDOBJ  DISPLAY ENDOBJ-#6000

        ORG #5CF4
        DW TRACKSEC

        ORG #6000
