        ORG #9C40
SCRBUF  EQU #C000
        DISPLAY "OUTPUT SCR FOR COLISEUM"

        DI 
        LD HL,SCREEN
        LD DE,SCRBUF
        LD BC,#C020

LOOP    PUSH BC
        PUSH DE
LOOP1   LD A,(HL)
        LD (DE),A
        INC HL
        CALL DOWNL
        DJNZ LOOP1
        POP DE
        INC DE
        POP BC
        DEC C
        JR NZ,LOOP
        LD DE,SCRBUF+#1800
        LD B,3
        LDIR 
        LD B,3
SCR_OL1 PUSH BC
        LD IX,ADRTABL
        EI 
        HALT 
        LD B,8

SCR_OL2 PUSH BC
        LD A,0
COUNTER EQU $-1
        OR A
        JR NZ,NO_PA
        LD E,(IX+2)
        LD D,(IX+3)
        EX DE,HL
        LD BC,#20
        PUSH BC
        PUSH HL
        ADD HL,BC
        EX DE,HL
        LD (IX+2),E
        LD (IX+3),D
        POP BC
        LD HL,#5800
        LD DE,SCRBUF+#1800
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        POP BC
        LDIR 

NO_PA   AND #1F
        JR NZ,NO_NL
        JR NO_NL
NL_S    EQU $-1
        LD E,(IX)
        LD D,(IX+1)
        EX DE,HL
        LD BC,#20
        OR A
        SBC HL,BC
        EX DE,HL
        CALL DOWNL
        LD (IX),E
        LD (IX+1),D

NO_NL   LD HL,#4000
        LD DE,SCRBUF
        LD C,(IX)
        LD B,(IX+1)
        PUSH BC
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        POP BC
        INC BC
        LD (IX),C
        LD (IX+1),B
        LD A,(HL)
        LD (DE),A
        INC IX
        INC IX
        INC IX
        INC IX
        POP BC
        DJNZ SCR_OL2

        LD A,(COUNTER)
        INC A
        LD (COUNTER),A
        XOR A
        LD (NL_S),A
        POP BC
        DEC BC
        LD A,#7F
        IN A,(#FE)
        RRA 
        JR NC,FASTOUT
        LD A,B
        OR C
        JP NZ,SCR_OL1
FASTOUT LD HL,SCRBUF+#1800
        LD DE,#5800
        LD BC,#300
        LDIR 
        LD HL,SCRBUF
        LD DE,#4000
        LD BC,#1800
        LDIR 
        RET 

DOWNL   INC D
        LD A,D
        AND 7
        RET NZ
        LD A,E
        ADD A,#20
        LD E,A
        RET C
        LD A,D
        SUB 8
        LD D,A
        RET 

ADRTABL DW 0
        DW 0

        DW #20*3
        DW #20*3

        DW #20*6
        DW #20*6

        DW #20+#800
        DW #20*9

        DW #20*4+#800
        DW #20*12

        DW #20*7+#800
        DW #20*15

        DW #20*2+#1000
        DW #20*18

        DW #20*5+#1000
        DW #20*21

SCREEN  INCBIN "PICTURE"
ENDSCR  DISPLAY /D,"End obj: ",ENDSCR
