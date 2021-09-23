        DISPLAY "PLASMFADE V1.0+ (WITHOUT FADEOUT BEFORE)"
        DISPLAY "Warning! USE: EI, CALL PLASMFADE!"
        ORG 25500
ATRBUF  EQU #8400
ADRBUF  EQU #BA00
PHASES  EQU 32

        LD HL,#BE00
        LD B,L
        LD A,H
        LD I,A
        INC A
INT_IL  LD (HL),A
        INC HL
        DJNZ INT_IL
        LD (HL),A

FADEP   LD DE,ATRBUF
        LD HL,#5800
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
        DUP 3
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
NOFADE0 LD HL,SCREEN
        LD DE,#4000
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
        ADD A,#20
        LD E,A
        JR C,AROUND
        LD A,D
        SUB 8
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
        LD DE,ATRBUF
        PUSH DE
        LDIR 
        POP HL
        LD B,6
        LD DE,ATRBUF+#1200
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
        LD HL,#C000
        LD DE,#1017
        LD BC,#7FFD
        OUT (C),E
        LD (HL),E
        OUT (C),D
        LD (HL),D
        OUT (C),E
        LD A,(HL)
        CP E
        JP NZ,MODE48
        LD A,#C3
        LD (#BFBF),A
        LD HL,INT
        LD (#BFC0),HL
        DI 
        IM 2
        LD HL,#4000
        LD DE,#C000
        LD BC,#1B00
        LDIR 
        LD HL,ATRBUF
        LD DE,ATRBUF+1
        LD BC,#2FF
        LD (HL),L
        LDIR 
        LD A,ATRBUF/#100
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
        LD HL,ATRBUF+#300
OUT_L   PUSH BC
        LD DE,#5800
        LD BC,#300
        DUP 3
        HALT 
        EDUP 
        LDIR 
        POP BC
        DJNZ OUT_L
        RET 

INT     PUSH AF
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




FADE_   LD BC,#300
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

TABL    INCBIN "PLASMTBL"
SCREEN  INCBIN "PICTURE"
ENDOBJ  DISPLAY /D,ENDOBJ-25500

