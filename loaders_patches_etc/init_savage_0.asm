; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #5B17
ZZUU    LD A,7
        OUT (#FE),A
        LD A,0
        OUT (#FE),A
        JR ZZUU

        ORG #8000
        INCBIN "savage0#"

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
SCRFADE
        LD HL,#6200
        LD B,L
FAD_LP  LD D,L
        LD A,D
        AND 1+2+4
        OR A
        JR Z,NODINK
        DEC D
NODINK  LD A,D
        AND 8+16+32
        OR A
        JR Z,NODPAP
        LD A,D
        SUB 8
        LD D,A
NODPAP  LD (HL),D
        INC L
        DJNZ FAD_LP
        EI
        LD B,8
FAD_LL  PUSH BC
        HALT
        HALT
        HALT
        HALT
        LD HL,#5800
        LD BC,#300
        LD D,#62
FAD_L1  LD E,(HL)
        LD A,(DE)
        LD (HL),A
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,FAD_L1
        POP BC
        DJNZ FAD_LL
        RET



START   EQU #7FD9
        DISPLAY "savage_main_2",START,#0-#5C0-START-1

        ;---rewriting kernal
        ORG #89FD
        DI
        LD HL,#FD00
        LD B,L
        LD A,H
        LD I,A
        INC A
INIM2L  LD (HL),A
        INC HL
        DJNZ INIM2L
        LD (HL),A
        IM 2
        CALL #8264
        EI
WM_L    LD A,(#9734)
        OR A
        JR Z,WM_L
        LD HL,#FF08
        LD (#FF00),HL
        CALL SCRFADE
        DI
        LD HL,#9736
        LD B,#C0
        CALL #6003
        EI
        HALT
        EX DE,HL
        LD HL,#9736+#1800
        LD B,3
        LDIR
WKEY    XOR A
        IN A,(#FE)
        CPL
        AND #1F
        JR NZ,WKEY
        LD HL,KEY_RQ
        LD (#FF00),HL
        JR $
        DB 0

        ;---clear damaged screen
        ORG #C312
        DS #1B00,0

        ;---clear garbage
        ORG #FE00
        DS #1FF,0
        ORG #9428
        DS #80,0

        ;---including converted scr$
        ORG #9736
        INCBIN "pic#0_"

        ORG START
        DI
        LD SP,#94A8
        LD HL,INTDAT
        LD DE,#FEFE
        LD B,1
        LDIR
        JP #89FD
INTDAT  DI
        CALL #8000
        LD A,1
        LD (#9734),A
        EI
        RET
KEY_RQ  LD A,#7F
        IN A,(#FE)
        RRA
        JP NC,#5B17
        JP #8A49
