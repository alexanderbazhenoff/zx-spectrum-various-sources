        ORG #C000
SPRITES EQU 6
SPR_ADR EQU #8000

        DISPLAY "Sprite convrter for Lamergy 0 intro"
        DISPLAY "Run from STS and remember DE after this"
        DISPLAY "procedure. Than calculate: DE-#8000"
        DISPLAY "It will be the lenght of file"


        LD HL,SPR_ADR
        LD DE,SPR_ADR+1
        LD BC,#3FFF
        LD (HL),0
        LDIR 
        LD HL,SCREEN
        LD DE,#4000
        LD BC,#1B00
        LDIR 
        LD HL,#48E0
        LD BC,#0911
        LD IX,#59E0
        LD DE,SPR_ADR+#C
        CALL CONV
        LD HL,#4000
        LD BC,#0320
        LD IX,#5800
        CALL CONV
        LD HL,#4060
        LD BC,#0303
        LD IX,#5860
        CALL CONV
        LD HL,#4063
        LD BC,#0303
        LD IX,#5863
        CALL CONV
        LD HL,#40C0
        LD BC,#0303
        LD IX,#58C0
        CALL CONV
        LD HL,#40C3
        LD BC,#0303
        LD IX,#58C3

CONV    PUSH HL
        LD HL,SPR_ADR
POINTER EQU $-2
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD (POINTER),HL
        POP HL
        LD A,C
        LD (DE),A
        INC DE
        LD A,B
        LD (DE),A
        INC DE
        PUSH BC
        XOR A
CONV_CA ADD A,8
        DJNZ CONV_CA
        LD B,A
CONV_L0 PUSH BC
        PUSH HL
CONV_L1 LD A,(HL)
        LD (DE),A
        LD (HL),#FF
        INC DE
        INC H
        LD A,H
        AND 7
        JR NZ,C_ALL
        LD A,L
        ADD A,32
        LD L,A
        JR C,C_ALL
        LD A,H
        SUB 8
        LD H,A
C_ALL   DJNZ CONV_L1
        EI 
        HALT 
        POP HL
        INC L
        POP BC
        DEC C
        JR NZ,CONV_L0
        POP BC
        PUSH IX
        POP HL
CONV_A1 PUSH BC
        PUSH HL
        LD A,R
        OR #80
        LD (FILLA),A
        LD A,C
        LD B,0
        LDIR 
        POP HL
        PUSH HL
CONV_A2 LD (HL),#B5
FILLA   EQU $-1
        INC HL
        DEC A
        JR NZ,CONV_A2
        POP HL
        LD C,#20
        ADD HL,BC
        POP BC
        HALT 
        DEC B
        JR NZ,CONV_A1
        LD A,50
        OUT (#FE),A
CONV_P  HALT 
        DEC A
        JR NZ,CONV_P
        OUT (#FE),A
        RET 


SCREEN  INCBIN "trainer$"

