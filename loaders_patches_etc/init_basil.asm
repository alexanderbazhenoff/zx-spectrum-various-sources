        ORG 26000

        DI 
        LD HL,TABL
        LD DE,#5B00
        LD BC,#FF
        LDIR 
        LD SP,26000
        LD HL,#FF10
        LD E,#11
        LD BC,#7FFD
        OUT (C),L
        LD (HL),L
        OUT (C),E
        LD (HL),E
        OUT (C),L
        LD A,(HL)
        CP E
        JP Z,MODE48
        LD HL,#5B00
        LD B,4
LOADM   PUSH BC
        PUSH HL
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD C,(HL)
        INC L
        PUSH AF
        PUSH HL
        LD H,C
        CALL LOAD128
        POP HL
        POP AF
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD C,(HL)
        LD H,C
        CALL LOAD128
        POP HL
        LD DE,#10
        ADD HL,DE
        POP BC
        DJNZ LOADM
        LD BC,#7FFD
        LD A,#10
        OUT (C),A
        LD HL,LEV128
        LD DE,#AE10
        LD BC,#99
        LDIR 
        CALL FADE
        DI 


        CALL #C000
        XOR A
        CALL LEV128_

START   XOR A
        LD B,A
BRDM    PUSH BC
        LD A,B
        LD (PAUPAR+1),A
        LD L,#40
        LD A,R
        AND #3F
        LD H,A
BRD     LD A,R
        XOR (HL)
        OUT (#FE),A
        XOR A
        OUT (#FE),A
        LD A,R
        XOR (HL)
PAUPAR  AND 0
        LD B,A
        INC B
PAUSB   DJNZ PAUSB
        DEC L
        JR NZ,BRD
        POP BC
        INC B
        INC B
        INC B
        JR NZ,BRDM
        LD HL,54784
        PUSH HL
        LD DE,#FC00
        LD BC,#400
        PUSH BC
        LDIR 
        POP BC
        POP HL
        PUSH HL
        POP DE
        INC DE
        LD (HL),C
        LDIR 
        LD A,200
        LD (23607),A
        LD SP,27000
        JP #8000

MODE48  LD IX,#5B00
        LD B,4
        LD DE,(#5CF4)
LOAD48L PUSH BC
        LD B,(IX+1)
        LD (IX),E
        LD (IX+2),D
        CALL ADDSEC
        LD B,(IX+4)
        CALL ADDSEC
        LD BC,#10
        ADD IX,BC
        POP BC
        DJNZ LOAD48L
        LD HL,LOAD48
        LD DE,#AE10
        LD BC,#99
        LDIR 
        EI 
        CALL FADE
        CALL #C000
        DI 
        XOR A
        CALL LOADL4_
        LD HL,LEVEL
        LD (#5B47),HL
        LD HL,FINAL
        LD (#5B44),HL
        LD HL,#8D22
        LD (#AEFF),HL

        JP START

ADDSEC  INC E
        BIT 4,E
        JR Z,NONTRK
        LD E,0
        INC D
NONTRK  DJNZ ADDSEC
        RET 

LOAD48
        DISP #AE10

LOADL48 LD A,(#8069)
LOADL4_ CALL DAT128L
        LD E,(HL)
        INC L
        LD B,(HL)
        INC L
        LD D,(HL)
        INC L
        INC L
        PUSH HL
LADR1   LD H,#B0
        CALL LOAD
        POP HL
        LD B,(HL)
LADR2   LD H,#E4
        CALL LOAD
        CALL CLS11
        CALL CLS11
        CALL CLS111
        CALL CLS_S
        RET 

LEVEL   LD A,#B0
        LD (LADR1+1),A
        LD A,#E4
        JR LLEV48
FINAL   LD A,#D0
        LD (LADR1+1),A
        LD A,#B0
LLEV48  LD (LADR2+1),A
        PUSH HL
        PUSH BC
        PUSH DE
        EXX 
        EX AF,AF'
        PUSH HL
        PUSH DE
        PUSH BC
        PUSH AF
        PUSH IY
        LD A,I
        PUSH AF
        LD A,#3F
        IM 1
        LD IY,#5C3A
        LD HL,#2758
        EXX 
PPLOAD  CALL LOADL48
        EXX 
        POP AF
        LD I,A
        IM 2
        POP IY
        POP AF
        POP BC
        POP DE
        POP HL
        EX AF,AF'
        EXX 
        POP DE
        POP BC
        POP HL
        RET 





        ENT 
FADE
        INCLUDE "$FADE0"
        RET 
LOAD128 DI 
        PUSH BC
        LD BC,#7FFD
        OUT (C),A
        POP BC
        LD C,5
        LD L,0
        LD DE,(#5CF4)
LOAD12_ PUSH BC
        PUSH DE
        PUSH HL
        CALL LL_3D13
        DI 
        POP HL
        POP DE
        POP BC
        LD A,(23823)
        OR A
        JR NZ,LOAD12_
        RET 

LL_3D13 LD (REG_A+1),A
        PUSH HL
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
        LD (SP2),SP
REG_A   LD A,#C3
        JP #3D13
D_ERR   LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),A
        LD A,#C9
        LD (#5CC2),A
        RET 
DRIA    EX (SP),HL
        PUSH AF
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR Z,NO_ERR
NO_ERR  POP AF
        EX (SP),HL
        RET 
RIA     POP HL
        POP HL
        POP HL
        XOR A
        LD (23560),A
        LD A,2
        OUT (#FE),A
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F
TABL
        DISP #5B00
        DEFB #11,#0B,#C1,#11,#12,#CC
        INCBIN "LEVEL10"
        DEFB #11,#0D,#DF,#11,#11,#ED
        INCBIN "LEVEL20"
        DEFB #13,#0C,#C1,#13,#12,#CD
        INCBIN "LEVEL30"
        DEFB #13,#08,#DF,#13,#08,#E7
        INCBIN "LEVEL40"
HEAD    JP LEV128H
LOADLEV JP #AE3B
LOADFC  JP #AE10

DAT128L ADD A,A
        ADD A,A
        ADD A,A
        ADD A,A
        LD HL,#5B00
        LD E,A
        LD D,L
        ADD HL,DE
        RET 
LEV128H CALL DAT128L
        INC HL
        INC HL
        INC HL
        INC HL
        INC HL
        INC HL
        INC HL
        LD DE,#FFE0
        LD BC,#0A
        LDIR 
        RET 

LL3D13  LD (REG_A+1),A
        PUSH HL
        LD HL,(23613)
        LD (ERR1+1),HL
        LD HL,DRIA1
        LD (#5CC3),HL
        LD HL,ERR1
        EX (SP),HL
        LD (23613),SP
        EX AF,AF'
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23823),A
        LD (23824),A
        LD (SP21),SP
REG_A1  LD A,#C3
        JP #3D13
D_ERR1  LD SP,#3131
SP21    EQU $-2
        LD (23823),A
ERR1    LD HL,#2121
        LD (23613),A
        LD A,#C9
        LD (#5CC2),A
        RET 
DRIA1   EX (SP),HL
        PUSH AF
        LD A,H
        CP 13
        JR Z,RIA1
        XOR A
        OR H
        JR Z,NO_ERR1
NO_ERR1 POP AF
        EX (SP),HL
        RET 
RIA1    POP HL
        POP HL
        POP HL
        XOR A
        LD (23560),A
        LD A,2
        OUT (#FE),A
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F
CLS11   LD HL,#5800
CLS111  LD A,L
CLS_L1  LD (HL),A
        INC L
        JR NZ,CLS_L1
        INC H
        RET 
CLS_S   XOR A
        LD HL,#4FFF
CLS_SL  DEC HL
        LD (HL),A
        OR (HL)
        JR Z,CLS_SL
        RET 

LOAD    DI 
        LD C,5
        LD L,0
        PUSH HL
        LD DE,(#5CF4)
LOAD_   PUSH BC
        PUSH DE
        PUSH HL
        CALL LL3D13
        DI 
        POP HL
        POP DE
        POP BC
        LD A,(23823)
        OR A
        JR NZ,LOAD_
        RET 
ENT 



LEV128
        DISP #AE10
LEV128_
        PUSH AF
        CALL CLS
        POP AF
        LD IX,#B000
        CALL DAT128L
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD C,(HL)
        INC L
        PUSH HL
        LD H,C
        CALL MOVLEV
        POP HL
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD H,(HL)

        LD IX,#E400
        CALL MOVLEV
        LD HL,#5900
        CALL CLS1
        RET 

LEV128F
        PUSH AF
        CALL CLS
        POP AF
        LD IX,#D000
        CALL DAT128L
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD C,(HL)
        INC L
        PUSH HL
        LD H,C
        CALL MOVLEV
        POP HL
        LD A,(HL)
        INC L
        LD B,(HL)
        INC L
        LD H,(HL)

        LD IX,#B000
        CALL MOVLEV
        RET 

MOVLEV  PUSH IX
        LD C,0
        LD L,C
        LD E,A
        LD D,#10
MOVL_L  PUSH BC
        LD BC,#7FFD
        OUT (C),E
        LD A,(HL)
        OUT (C),D
        LD (IX),A
        POP BC
        INC HL
        INC IX
        DEC BC
        LD A,B
        OR C
        JR NZ,MOVL_L
        RET 
CLS     LD HL,#5800
CLS1    LD A,L
CLS_L   LD (HL),A
        INC L
        JR NZ,CLS_L
        RET 
