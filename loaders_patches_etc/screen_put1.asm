        ORG 46912
SCFROM  EQU 40000
SCRTO   EQU #4000

        XOR A
        LD HL,#5800
        LD D,H
        LD E,L
        INC DE
        LD (HL),A
        LD BC,#2FF
        LDIR 
        INC A
        LD (COMINK+1),A
        LD (COMPAP+1),A
        LD HL,SCFROM
        LD DE,SCRTO
        LD BC,#1800
        LDIR 
        PUSH DE
        POP IX
        LD B,7
LP0     PUSH HL
        PUSH IX
        PUSH BC
        HALT 
        HALT 
        HALT 
        LD BC,#300
LP1     LD A,(HL)
        PUSH AF             ;1
        PUSH AF             ;2
        AND 1+2+4
COMINK  CP #FE
        JR NZ,NOINK
        POP AF              ;1
        AND 1+2+4+64+128           ;7
        OR (IX)                    ;19
        LD (IX),A                  ;19
        JR YEPINK
NOINK   LD (#2222),IX
        LD (#2222),HL
        LD A,I
        POP AF
YEPINK  POP AF              ;0
        PUSH AF             ;1
        RRA 
        RRA 
        RRA 
        AND 1+2+4
COMPAP  CP #FE
        JR NZ,NOPAP
        POP AF              ;0A
        AND 8+16+32+64+128
        OR (IX)
        LD (IX),A
        JR YEPPAP
NOPAP   LD (#2222),IX
        LD (#2222),HL
        LD A,I
        POP AF              ;0B
YEPPAP  INC HL
        INC IX
        DEC BC
        LD A,B
        OR C
        JR NZ,LP1
        LD A,(COMINK+1)
        INC A
        LD (COMINK+1),A
        LD A,(COMPAP+1)
        INC A
        LD (COMPAP+1),A
        POP BC
        POP IX
        POP HL
        DJNZ LP0
        RET 

        DISP 40000
        INCBIN "SPYHUNT$"
