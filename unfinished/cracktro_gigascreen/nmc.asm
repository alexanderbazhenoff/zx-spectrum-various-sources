; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at https://github.com/aws/mit-0

; a small never released peace of source and the concept for the
ctacktro by alx^bw. never relased.

        ORG #6000
ATTRMODE        EQU 0
                ;0 - BLUE/MAGENTA

DECRUNCHED_FONT EQU #FA00
SCR_ATTR1       EQU #F700
SCR_ATTR2       EQU #F400


        DI 
        LD HL,FONT+2
        LD DE,DECRUNCHED_FONT+#20
        LD BC,#4008
FONTIL1 PUSH BC
        PUSH DE
FONTIL2 LD A,(HL)
        LD (DE),A
        INC HL
        INC D
        DEC C
        JR NZ,FONTIL2
        POP DE
        POP BC
        INC E
        DJNZ FONTIL1

        LD DE,SCR_ATTR1+5
        LD HL,SCR_ATTR2+5
        EXX 
        LD DE,#4205
        LD IX,TEXT-1
PRNTLP  INC IX
        LD A,(IX)
        BIT 7,A
        JR Z,NO_NEWPOS
        PUSH AF
        CALL ENTER0
        POP AF
        AND #7F
        LD D,A
        INC IX
        LD E,(IX)
        LD A,E
        AND #1F
        EXX 
        OR E
        LD E,A
        LD L,A
        EXX 
        JR PRNTLP
NO_NEWPOS
        CP #10
        JR NZ,NO_CHNGATR
        LD (ATR_SW),A
        INC IX
        EXX 
        LD C,(IX)
        INC IX
        LD B,(IX)
        EXX 
        JR PRNTLP
NO_CHNGATR
        CP #11
        JR NZ,NO_CSW
        LD A,(ATR_SW)
        XOR #10
        LD (ATR_SW),A
        JR PRNTLP
NO_CSW  CP #0D
        JR NZ,NO_ENTR
        CALL ENTER
        JR PRNTLP
NO_ENTR OR A
        JR Z,ENDPRINT
        LD H,'DECRUNCHED_FONT
        LD L,A
        PUSH DE
        LD B,6
PRNT_L  LD A,(HL)
        LD (DE),A
        INC H
        CALL DOWN_DE
        DJNZ PRNT_L
        POP DE
        INC E
        EXX 
        LD A,#10
ATR_SW  EQU $-1
        OR A
        JR Z,NO_ATRP
        LD (HL),C
        LD A,B
        LD (DE),A
NO_ATRP INC HL
        INC DE
        EXX 
        JP PRNTLP
ENDPRINT
        LD HL,#2758
        EXX 
        EI 
FLOOP   HALT 
        LD HL,SCR_ATTR1
        LD DE,#5800
        LD BC,#300
        LDIR 
        HALT 
        LD HL,SCR_ATTR2
        LD DE,#5800
        LD BC,#300
        LDIR 
        LD A,#7F
        IN A,(#FE)
        RRA 
        RET NC
        JR FLOOP

DOWN_DE INC D
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

ENTER   LD A,E
        AND #E0
        LD E,A
ENTR2   LD B,6
ENTRL   CALL DOWN_DE
        DJNZ ENTRL
ENTER0  EXX 
        PUSH BC
        LD BC,#20
        LD A,E
        AND #E0
        LD E,A
        LD L,A
        ADD HL,BC
        EX DE,HL
        ADD HL,BC
        POP BC
        EXX 
        RET 


TEXT
        DB #10,#47,#45
        DB "POSSESSED CRAKKAZ FROM"
        DB #80+#42,#2A
        DB #10,#42,#42
        DB "@"
        DB #10,#47,#07
        DB "BRAINWAVE"
        DB #10,#42,#42
        DB "@"
        DB #80+#42,#44
        DB #10,#43,#41
        DB "BRINGS YOU THE NEW AMAZIN"
        DB #80+#40,#66
        DB #10,#43,#42
        DB "MINI CRACK-RELEASE OF"
        DB #80+#40,#84
        DB #10,#42,#42
        DB "<"
        DB #10,#47,#07
        DB "ZZZZZZZZZZZZZZZZZZZZZZZ"
        DB #10,#42,#42
        DB ">"
        DB #80+#40,#AE
        DB #10,#47,#45
        DB "FROM"
        DB #80+#40,#C4
        DB #10,#42,#42
        DB "*"
        DB #10,#47,#07
        DB "XXXXXXXXXXXXXXXXXXXXXXX"
        DB #10,#42,#42
        DB "*"



FONT    INCBIN "nmc_font.f"
