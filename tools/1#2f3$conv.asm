; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        DISPLAY "1/3 OF SCR CONVERTER (2 COLUMNS)"
        DISPLAY "CODED BY ALX/BW 2oo2"
        DISPLAY
        DISPLAY "IN: FILE <1/3PIC.C> WITH LENGHT #800"
        DISPLAY "    (1/3 OF SCR WITHOUT ATTR)"
        DISPLAY "OUT: SAVE FILE <...> #C000,#800"
        ORG #6000
        LD HL,PIC
        LD DE,#4000
        LD BC,#800
        LDIR
        LD HL,#4000
        LD DE,#C000
        LD BC,#4020

LOOP    PUSH BC
        PUSH HL
LOOP1   LD A,(HL)
        LD (DE),A
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
AROUND  DJNZ LOOP1
        POP HL
        INC HL
        POP BC
        DEC C
        JR NZ,LOOP
        RET
PIC     INCBIN "1/3PIC"