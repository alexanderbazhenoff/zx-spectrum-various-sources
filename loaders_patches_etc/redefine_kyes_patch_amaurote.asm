; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #67FF

BORDER  EQU 5
INTTABL EQU #7800
FONT    EQU #7A00
K_TABL  EQU #6800+#400

        DI
        LD A,BORDER
        OUT (#FE),A
        LD BC,#7FFD
        LD A,#18
        OUT (C),A
        LD (#5B5C),A
        PUSH BC
        CALL PANEL
        CALL CLS
        POP BC
        LD A,#10
        OUT (C),A
        LD (#5B5C),A
        CALL REDEFK
        CALL PANEL
        DI
        LD HL,#67E8
        PUSH HL
        LD HL,#4000
        LD DE,#67FF
        LD BC,#1800
        JP #33C3

CLS     DI
        LD BC,#7FFD
        LD HL,#FFFF
        LD DE,#1F18
        OUT (C),E
        LD (HL),E
        OUT (C),D
        LD (HL),D
        OUT (C),E
        LD A,D
        CP (HL)
        JP Z,MODE48
        LD A,#18
        OUT (C),A

        LD HL,INTTABL
        LD A,H
        LD I,A
        INC A
        LD B,L
INTI_L  LD (HL),A
        INC HL
        DJNZ INTI_L
        LD (HL),A
        LD H,A
        LD L,A
        LD (HL),#C9
        IM 2

ML      EI
        HALT
        DI
        DUP 5
        LD (0),BC
        EDUP
        DUP 4
        NOP
        EDUP

        LD BC,#7FFD
        LD DE,#1810
        LD HL,BORDER
        OUT (C),E
        LD BC,#01FE
PAUPA1  EQU $-1
        OUT (C),H

PAUS1   DUP 10
        LD (0),BC
        EDUP
        NOP
        LD E,#10
        DJNZ PAUS1

        LD BC,#7FFD
        OUT (C),D
        LD BC,#9EFE
PAUPA2  EQU $-1
        OUT (C),L
        DUP 8
        LD (0),BC
        EDUP
        INC A
        DEC A

PAUS2   DUP 21
        LD (0),BC
        EDUP
        NOP
        NOP
        LD E,#10
        DJNZ PAUS2

        LD R,A
        LD E,#10
        NOP
        LD BC,#7FFD
        OUT (C),E
        LD C,#FE
        OUT (C),H

        LD A,(PAUPA1)
        INC A
        LD (PAUPA1),A
        LD A,(PAUPA2)
        DEC A
        LD (PAUPA2),A
        LD A,158
PAUPA3  EQU $-1
        DEC A
        LD (PAUPA3),A
        OR A
        JP NZ,ML
        OUT (C),H
        LD BC,#7FFD
        LD A,#10
        OUT (C),A
        IM 1
        EI
        RET

MODE48  EI
        HALT
        XOR A
        OUT (#FE),A
        LD HL,#5B00
CL48L   DEC HL
        LD (HL),A
        OR A
        JR Z,CL48L
        RET

REDEFK  LD HL,#3C00
        XOR A
        LD (23659),A
        PUSH HL
        INC H
        LD BC,#300
        LD DE,FONT-#100
        LD (23606),DE
        INC D
FNTDL   LD A,(HL)
        RRA
        OR (HL)
        LD (DE),A
        INC HL
        INC DE
        DEC BC
        LD A,B
        OR C
        JR NZ,FNTDL
        LD A,6
        LD (23693),A
        LD A,2
        CALL 5633
        LD DE,TXTR
        LD BC,TXTRE-TXTR
        CALL 8252
REDRQ   LD A,#DF
        IN A,(#FE)
        BIT 4,A
        JR Z,YEPR
        LD A,#7F
        IN A,(#FE)
        BIT 3,A
        JP Z,NOPR
        JR REDRQ
YEPR    CALL CLSCR
        LD HL,#FE
        LD (REP_KEY),HL
        LD (REP_K2),HL
        LD (REP_K3),HL
        LD (REP_K4),HL
        LD DE,TXTW
        LD BC,TXTWE-TXTW
        CALL 8252
AGAINR  CALL REDFL
        LD (PO_L+1),A
        LD (BI_L),DE
        LD (REP_KEY),HL
        CALL REDFR
        LD (PO_R+1),A
        LD (BI_R),DE
        LD (REP_K2),HL
        CALL REDFU
        LD (PO_U+1),A
        LD (BI_U),DE
        LD (REP_K3),HL
        CALL REDFD
        LD (PO_D+1),A
        LD (BI_D),DE
        LD (REP_K4),HL
        CALL REDFF
        LD (PO_F+1),A
        LD (BI_F),DE
        LD DE,TXTCN
        LD BC,TXTCNE-TXTCN
        CALL 8252
REDRCQ  LD A,#DF
        IN A,(#FE)
        BIT 4,A
        JR Z,NOPRCC
        LD A,#7F
        IN A,(#FE)
        BIT 3,A
        JR Z,NOPC
        JR REDRCQ
NOPC
        CALL PAUSE

        JR YEPR

NOPRCC  LD HL,K_DRIV
        LD DE,#8B4F
        LD BC,K_DRVE-K_DRIV
        LDIR
NOPR    POP HL
        LD (23606),HL
        CALL CLSCR
        LD A,2
        LD (23659),A
        RET

CLSCR   LD B,#0C
        LD HL,#20*4+#5800+#03
CLSCNC  PUSH BC
        PUSH HL
        LD D,H
        LD E,L
        INC DE
        LD (HL),0
        LD BC,25
        LDIR
        POP HL
        LD DE,#20
        ADD HL,DE
        POP BC
        DJNZ CLSCNC
        RET

REDFL   LD DE,TXTLK
        LD BC,TXTRK-TXTLK
        JR KEYINP
REDFR   LD DE,TXTRK
        LD BC,TXTUK-TXTRK
        JR KEYINP
REDFU   LD DE,TXTUK
        LD BC,TXTDK-TXTUK
        JR KEYINP
REDFD   LD DE,TXTDK
        LD BC,TXTFK-TXTDK
        JR KEYINP
REDFF   LD DE,TXTFK
        LD BC,ENTTX-TXTFK


KEYINP  CALL 8252
KEY     LD IY,#5C3A
        EI
        RES 5,(IY+1)
WAITK   BIT 5,(IY+1)
        JR Z,WAITK
        LD A,(IY-50)
        CP #0D
        JR Z,ENTERK
        CP " "
        JR Z,SPCK
        CP #30
        JR C,KEY
        CP #3A
        JR C,NUMB
        OR #20
        CP #61
        JR C,KEY
        CP "v"
        JR Z,KEY
        CP #7B
        JR C,NUMB
        JR KEY

ENTERK  CALL REP_KEY
        JR Z,KEY
        PUSH AF
        LD DE,ENTTX
ENTERK1 LD BC,8
        CALL 8252
        POP AF
        JR DECODK
SPCK    CALL REP_KEY
        JR Z,KEY
        PUSH AF
        LD DE,SPCTX
        JR ENTERK1
NUMB    CALL REP_KEY
        JR Z,KEY
        PUSH AF
        RST #10
        POP AF

        ; DECODING KEY 2 PORT & BIT (A=CODE OF THE KEY)
DECODK  CALL PAUSE
        LD HL,KEYTABL
        LD L,A
        PUSH AF
        LD A,(HL)
        INC H
        LD D,(HL)
        LD E,#E6
        POP HL
        LD L,#FE
        RET

REP_KEY CP #00
        RET Z
REP_K2  CP #00
        RET Z
REP_K3  CP #00
        RET Z
REP_K4  CP #00
        RET


PAUSE   LD B,#0A
PAUSEL  HALT
        DJNZ PAUSEL
        RET
K_DRIV
PO_R    LD A,#3E
        IN A,(#FE)
        CPL
BI_R    AND #E6
        LD (HL),A
        INC HL

PO_D    LD A,#3E
        IN A,(#FE)
        CPL
BI_D    AND #E6
        LD (HL),A
        INC HL

PO_U    LD A,#3E
        IN A,(#FE)
        CPL
BI_U    AND #E6
        LD (HL),A
        INC HL

PO_L    LD A,#3E
        IN A,(#FE)
        CPL
BI_L    AND #E6
        LD (HL),A

PO_F    LD A,#3E
        IN A,(#FE)
        CPL
BI_F    AND #E6

K_DRVE
        ORG K_TABL
KEYTABL DEFS #0D,0
        ;ENT
        DEFB #BF
        DEFS #12,0
        ;SPC
        DEFB #7F
        DEFS #0F,0
        ;   0   1   2   3   4   5   6   7   8  9
        DEFB #EF,#F7,#F7,#F7,#F7,#F7,#EF,#EF,#EF,#EF
        DEFS #27,0
        ;   A   B   C   D   E   F   G   H   I   J
        DEFB #FD,#7F,#FE,#FD,#FB,#FD,#FD,#BF,#DF,#BF
        ;   K   L   M   N   O   P   Q   R   S   T
        DEFB #BF,#BF,#7F,#7F,#DF,#DF,#FB,#FB,#FD,#FB
        ;   U   V   W   X   Y   Z
        DEFB #DF,#FE,#FB,#FE,#DF,#FE
        DEFS #FF,0

        ORG K_TABL+#100
        DEFS #0D,0
        ;ENT
        DEFB 1
        DEFS #12,0
        ;SPC
        DEFB 1
        DEFS #0F,0
        ;   0   1   2   3   4   5   6   7   8  9
        DEFB #01,#01,#02,#04,#08,#10,#10,#08,#04,#02
        DEFS #27,0
        ;   A   B   C   D   E   F   G   H   I   J
        DEFB #01,#10,#08,#04,#04,#08,#10,#10,#04,#08
        ;   K   L   M   N   O   P   Q   R   S   T
        DEFB #04,#02,#04,#08,#02,#01,#01,#08,#02,#10
        ;   U   V   W   X   Y   Z
        DEFB #08,#10,#02,#04,#10,#02


TXTCN   DEFB #16,#0F,#0F,#13,1,"Confirm? (Y/N)",#0D
TXTCNE

TXTR    DEFB #16,#04,#03,#13,1,"Control keys are:"
        DEFB #16,#06,#0B,"Up    Right"
        DEFB #16,#07,#03,#13,0,"(q,w,e,r,t)  (y,u,i,o,p)"
        DEFB #16,#08,#0E,#13,1,"><"
        DEFB #16,#09,#03,#13,0,"(a,s,d,f,g)  (h,j,k,l,ent)"
        DEFB #16,#0A,#09,#13,1,"Left    Down"
        DEFB #16,#0C,#03,#13,1,"Radio menu ",#13,0,"(cs)"
        DEFB #16,#0D,#03,#13,1,"View mode ",#13,0,"(v)"
        DEFB #16,#0E,#03,#13,1,"Fire ",#13,0,"(b,n,m,ss,spc)"
        DEFB #16,#0F,#0E,#13,1,"Redefine? (Y/N)"

TXTRE
TXTW    DEFB #16,#04,#04,#13,1,"Redefine keys options by"
        DEFB #16,#05,#0B,#13,0,"ALX/BW/XPJ"
        DEFB #16,#07,#0A,#13,1,"view:  ",#13,0,"v"
        DEFB #16,#08,#0A,#13,1,"radio: ",#13,0,"<cs>"
TXTWE
TXTLK   DEFB #16,#09,#0A,#13,1,"left:  ",#13,0
TXTRK   DEFB #16,#0A,#0A,#13,1,"right: ",#13,0
TXTUK   DEFB #16,#0B,#0A,#13,1,"up:    ",#13,0
TXTDK   DEFB #16,#0C,#0A,#13,1,"down:  ",#13,0
TXTFK   DEFB #16,#0D,#0A,#13,1,"fire:  ",#13,0
ENTTX   DEFB "<ent>",#0D
SPCTX   DEFB "<spc>",#0D


PANEL   INCBIN "PANEL$"
        ORG #67FF
