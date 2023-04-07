; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources

        ORG #5B14
        DB #FF,#FF


START   EQU #6367
        DISPLAY "savage_main_1",START,#0-#5C0-START-1


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

        ORG START
        DI
        LD A,(#5B14)
        OR A
        JR Z,NO_UL
        XOR A
        LD (#9997),A
        LD (#E0B0),A
NO_UL   LD A,(#5B15)
        OR A
        JR Z,NO_I
        LD A,#B7
        LD (#9981),A
        LD (#92B5),A
        LD (#E4D8),A
NO_I    LD B,#40
        LD HL,#F014
        CALL #6003
        JP #9128

        ORG #639C
        INCBIN "savage1#"

        ORG #6391
INS_FC
        LD HL,#9131
        LD (HL),#C3
        INC HL
        LD (HL),.FCEXIT
        INC HL
        LD (HL),'FCEXIT
        RET

        ORG #639D
FCEXIT  CALL #B228
        JP #5B17


        ORG #F014
        INCBIN "panel#1_"

        ORG #9254
        LD B,#FF
PAUSE   LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        DEC BC
        LD A,B
        OR C
        JR NZ,PAUSE
        CALL INS_FC

        ORG #FF00
        DS #FF,0

        ORG #A769
        DS #12,0

        ORG #5B17
ZZUU    LD A,7
        OUT (#FE),A
        LD A,0
        OUT (#FE),A
        JR ZZUU

        ORG START
