        ORG #5B14
        DB #FF,#FF


START   EQU #6367
        DISPLAY "savage_main_d",START,#0-#5C0-START-1


        ORG #6003
        LD DE,#4000
        LD C,#20

        PUSH HL,DE,BC
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
        POP HL
        LD L,H
        LD H,C
        DUP 5
        ADD HL,HL
        EDUP 
        LD B,H
        LD C,L
        POP HL
        POP DE
        LDIR 
        RET 

        ORG #639C
        INCBIN "savaged#"

        ORG START
        DI 
        LD A,(#5B14)
        OR A
        JR Z,NO_UL
        XOR A
        LD (#9A16),A
        LD (#E0B0),A
NO_UL   LD A,(#5B15)
        OR A
        JR Z,NO_I
        LD A,#B7
        LD (#9A00),A
        LD (#92A7),A
        LD (#E4BC),A
NO_I    LD B,#40
        LD HL,#F014
        CALL #6003
        JP #9128
        DS 18,0

        ORG #F014
        INCBIN "panel#1_"

        ORG #FF00
        DS #FF,0

        ORG #A74F
        DS #12,0

        ORG START
