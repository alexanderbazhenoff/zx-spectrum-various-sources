        DISPLAY "SKATEBOARD CONSTRUCTION SYYSTEM. GAME"
        DISPLAY "OUT LOGO ROUTINES by Alx^BW"
        DISPLAY "Lenght: #0054"

        ORG #D8B6
OutLogo LD DE,#B8D6
        LD HL,#4018
        LD BC,#C008
DC_PixL PUSH BC
        PUSH HL
DC_Pix1 LD A,(DE)
        LD (HL),A
        INC DE
        INC H
        LD A,H
        AND 7
        JR NZ,AROUND
        LD A,L
        ADD A,#20
        LD L,A
        JR C,AROUND
        LD A,H
        SUB 8
        LD H,A
AROUND  DJNZ DC_Pix1
        POP HL
        INC HL
        POP BC
        DEC C
        JR NZ,DC_PixL
        EI 
        HALT 
DC_1    LD HL,#5818
        LD BC,#0818
DC_AtrL PUSH BC
DC_Atr1 LD A,(DE)
        LD (HL),A
        INC HL
        INC DE
        DJNZ DC_Atr1
        LD C,#18
        ADD HL,BC
        POP BC
        DEC C
        JR NZ,DC_AtrL
        RET 
        DS 128,0
