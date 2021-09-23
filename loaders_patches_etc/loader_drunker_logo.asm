        ORG #8000
        DI 
        XOR A
        LD R,A
        LD HL,CODE+1
        LD DE,#FF00
        PUSH HL
        DEC HL
        LD BC,#100
XORKA   LD A,R
        XOR (HL)
        XOR H
        XOR L
        XOR E
        XOR D
        XOR C
        LD (HL),A
        LDI 
        RET PO
        JR XORKA
CODE    EQU $-1
        DISP #FF01
        XOR A
        EI 
        CALL 5633
        LD DE,TEXT
        PUSH DE
        LD BC,ETEXT-TEXT
        CALL 8252
        POP DE
        LD HL,#5B00-#20
        LD B,#20
        PUSH DE
        PUSH HL
        PUSH BC
        LD A,7
        CALL BEEPER
        XOR A
        LD B,A
PAUSH   HALT 
        DJNZ PAUSH
        POP BC
        POP HL
        POP DE
        CALL BEEPER
        RET 
BEEPER  LD (MASK+1),A
LOOP    PUSH BC
        LD A,(DE)
        LD C,A
        LD A,R
        LD B,A
        OR 1
MASK    AND 7
        LD (HL),A
        INC HL
        INC DE
BEEP    PUSH BC
        LD A,#10
        OUT (#FE),A
PAUS1   DJNZ PAUS1
        XOR A
        OUT (#FE),A
        POP BC
        PUSH BC
PAUS2   DJNZ PAUS2
        POP BC
        LD A,C
        DEC A
        LD C,A
        JR NZ,BEEP
        POP BC
        DJNZ LOOP
        RET 


TEXT    DEFB " Cra<kEd bY BeeR DrUnkEr @lx!!! "
ETEXT
ENDCODE