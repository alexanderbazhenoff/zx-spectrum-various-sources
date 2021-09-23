# 3D13 TR-DOS call with autoretry and no error messages

TR_DOS  PUSH HL
        PUSH DE
        PUSH BC
        CALL TRDOS
        POP BC
        POP DE
        POP HL
        LD A,(23823)
        OR A
        JR Z,BORD0
        LD A,R
        OUT (#FE),A
        JR TR_DOS

TRDOS   PUSH HL
        LD A,#FF
        LD (#5D15),A
        LD (#5D17),A
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
        EX AF,AF'
        LD (SP2),SP
        JP #3D13
DERR    LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),HL
        LD A,R
        OUT (#FE),A
        LD A,#C9
        LD (#5CC2),A
        LD A,(23823)
COMRET  RET 
DRIA    EX (SP),HL
        PUSH AF
        LD A,R
        OUT (#FE),A
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR NZ,NO_ERR
        LD A,L
        CP #10
        JR Z,DERR
NO_ERR  POP AF
        EX (SP),HL
BORD0   XOR A
        OUT (#FE),A
        RET 
RIA     DUP 3
        POP  HL
        EDUP 
        XOR A
        LD (23560),A
        LD HL,#FFFF
BL      LD A,R
        OUT (#FE),A
        NOP 
        DEC HL
        LD A,L
        OR H
        JR NZ,BL
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F