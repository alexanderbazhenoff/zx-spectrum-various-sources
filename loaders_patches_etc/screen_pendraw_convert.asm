        ORG #6000
        DISPLAY "Конвертилка из стандартного скрина в"
        DISPLAY "'карандашную рисовалку'"
BEGIN1  LD BC,0
        LD DE,#8000
        LD IX,0
        LD A,(#5800)
        LD (ATTR),A
        LD HL,#5800
        LD (AT_AD),HL
LOOP    XOR A
        LD (IY-50),A
        RES 5,(IY+1)
KEY_L   BIT 5,(IY+1)
        JR Z,KEY_L
        PUSH BC
        CALL SOUND
        POP BC
        LD HL,#2121
AT_AD   EQU $-2
        LD A,#3F
ATTR    EQU $-1
        LD (HL),A
        PUSH BC
        PUSH DE
        LD HL,#5800
        LD DE,#20
        LD A,B
        OR A
        JR Z,NO_AA
ACAL_L  ADD HL,DE
        DJNZ ACAL_L
NO_AA
        LD D,0
        LD E,C
        ADD HL,DE
        POP DE
        POP BC
        LD A,(HL)
        LD (AT_AD),HL
        LD A,(HL)
        LD (ATTR),A
        LD (HL),#7F

        LD A,(IY-50)
        CP " "
        JR Z,EXIT
        CP "0"
        JR Z,STORE
        CP #12
        JR Z,DELETE
        CP 8
        JR Z,POS_XL
        CP 9
        JR Z,POS_XR
        CP 11
        JR Z,POS_YU
        CP 10
        JR Z,POS_YD
        CP "R"
        JR Z,BEGIN
        CP "r"
        JR Z,BEGIN
        JR LOOP

POS_XL  LD A,C
        OR A
        JR Z,LOOP
        DEC C
        JR LOOP
POS_XR  LD A,C
        CP #1F
        JR Z,LOOP
        INC C
        JR LOOP
POS_YU  LD A,B
        OR A
        JR Z,LOOP
        DEC B
        JR LOOP
POS_YD  LD A,B
        CP 23
        JR Z,LOOP
        INC B
        JR LOOP

STORE
        INC IX
        LD A,C
        LD (DE),A
        INC DE
        LD A,B
        LD (DE),A
        INC DE
        PUSH BC
        PUSH DE
        LD A,B
        CALL #0E9E
        LD B,0
        ADD HL,BC
        POP DE
        LD B,8
STOR_L  LD A,(HL)
        LD (DE),A
        INC H
        INC DE
        DJNZ STOR_L
        POP BC
        PUSH BC
        PUSH DE
        LD HL,#5800
        LD A,B
        OR A
        JR Z,NO_AA1
        LD DE,#20
ACAL_L1 ADD HL,DE
        DJNZ ACAL_L1
NO_AA1
        LD D,0
        LD E,C
        ADD HL,DE
        POP DE
        LD A,(ATTR)
        LD (DE),A
        POP BC
        JP LOOP
EXIT    RET 

DELETE  EX DE,HL
        LD DE,11
        OR A
        SBC HL,DE
        EX DE,HL
        DEC IX
        JP LOOP

SOUND   PUSH DE
        LD HL,100
        LD DE,1
        CALL #03B5
        POP DE
        RET 

BEGIN   LD HL,(AT_AD)
        LD A,(ATTR)
        LD (HL),A
        JP BEGIN1
