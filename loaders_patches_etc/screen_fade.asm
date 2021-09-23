        ORG #FE00
        EI 
        LD B,8
FAD_ML  PUSH BC
        HALT 
        HALT 
        HALT 
        HALT 
        LD HL,#5800
        LD BC,#300
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
        POP BC
        DJNZ FAD_ML
        RET 