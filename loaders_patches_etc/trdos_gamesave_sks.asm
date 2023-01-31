; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #E827

        LD HL,DESCRIPT
        LD DE,#5CDD
        LD BC,14
        LD A,C
        LD (23814),A
        LDIR
        LD C,#A
        CALL #E042
        LD A,(23823)
        CP C
        JR Z,SF_NER
        OR A
        JR NZ,#E81B
SF_NER  LD A,C
        CP #FF
        JR NZ,FOUND_F
        LD HL,24500
        LD DE,41035
        LD C,#0B
        JP #E806
FOUND_F EI
        HALT
        DI
        LD DE,0
        CALL #D41C
        LD DE,MESSAGE
        CALL #D440
KEYINP  EI
        RES 5,(IY+1)
WAIT_K  BIT 5,(IY+1)
        JR Z,WAIT_K
        LD A,(IY-50)
        CP "n"
        RET Z
        CP "N"
        RET Z
        CP "y"
        JR Z,OVERWR
        CP "Y"
        JR Z,OVERWR
        JR KEYINP
OVERWR  EI
        HALT
        DI
        LD DE,0
        CALL #D41C
        LD A,(23823)
        LD C,8
        CALL #E042
        LD A,(23823)
        OR A
        JR NZ,#E81B
        LD DE,(#5CEB)
        LD HL,24500
        LD BC,#A106
        JP #E806

MESSAGE DB #16,#44,#50,#10,#7,"OVERWRITE? (Y/N)",#FF
DESCRIPT
        DB "GAME    C",#B4,#5F,#4B,#A0,#A1
ZHZH    DISPLAY "#E827...",ZHZH,"=",ZHZH-#E827

