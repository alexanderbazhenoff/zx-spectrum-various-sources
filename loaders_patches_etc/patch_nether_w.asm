; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


SC_TRSC EQU #260D
CHEAT   EQU #FF    ;#FF - on
                   ;1 - lives
                   ;2 - time
                   ;3 - add-ammo
                   ;4 - invencible
                   ;5 - ghost mode
                   ;6 - skip level keys
PENTFIX EQU #FF    ;#FF - pentagon, #00 - normal
SOUNDS  EQU #FF    ;#FF - ay, #00 - beeper

        DISPLAY "SAVE [fname],#6E7D,",#FFFF-#6E7D

TABLADR EQU #C04D  ;addr of highscore tabl
TABLLEN EQU #003B  ;lenght
TABL_SM EQU #00C5  ;внутрисекторное смещение


        ORG #5B14
        DS 6,CHEAT
        DB PENTFIX,SOUNDS

        ORG #6E9C
        INCBIN "NETH#"

        ORG #E679
        DB 0,3,0        ;bugfix for 7th level (30 diamonds)

        ORG #E683       ;bugfix for 9th level (90 diamonds)
        DB 0,9,0

        ORG #EE56
        DB #45

        ORG #6EC2
        LD A,(#5B14+7)
        CP #00

        ORG #AAEB
        CALL PAUS_IND

        ORG #AB2B
        DUP 3
        LD B,A
        EDUP

        ORG #C2A0
        LD B,A
        JP SAVE_HS_INS


        ORG #B2F7
STOPDRV XOR A
        CALL STPD_1
STPD_0  DJNZ STPD_0
        LD A,(#5D16)
STPD_1  LD BC,#00FF
STPD_2  LD HL,#2A53
        PUSH HL
        JP #3D2F

DAT_XOR LD B,TABLLEN
DT_XORL LD A,(HL)
        XOR B
        LD (DE),A
        INC HL
        INC DE
        DJNZ DT_XORL
        RET
PAUS_IND
        LD HL,#761E
        LD A,(HL)
        PUSH HL
        PUSH BC
        PUSH AF
        LD (HL),0
        LD DE,#4805
        LD HL,PAUS_TX
        CALL #765B
        LD HL,#5905
        LD B,22
PAUS_AF LD (HL),#47
        INC L
        DJNZ PAUS_AF
        POP AF
        POP BC
        POP HL
        LD (HL),A
        RET
PAUS_TX DB "GAME PAUSED",0


        ORG #FE01
SAVE_HS_INS
        AND 2
        JR Z,NO_DSYM
        LD A,D
        OR A
        JR Z,NO_DSYM
        LD (HL),"."
        DEC HL
        DEC D
        LD E,(HL)
NO_DSYM
        LD A,B
        AND #10
        JP Z,#C26B
;       CALL SAVE_HS
;       JP #C2A4
;       JP SAVE_HS

SAVE_HS LD A,(#8327)
        OR A
        RET Z
        LD HL,#5800
        LD E,L
        LD BC,#02FF
        LD D,H
        INC E
        LD (HL),L
        LDIR
        DI
;       CALL #F392
MUTE_SW EQU $-2
        LD (STEK),SP
        CALL REGS
        LDIR
        CALL REGS_1
        DEC BC
        LD D,H
;       LD E,L
        INC E
        LD (HL),L
        LDIR
        LD SP,HL
        DEC H
;       LD (#5C63),HL
        LD (#5C65),HL   ;!!!
        IM 1
        LD IY,#5C3A
        LD HL,#2758
        EXX
        LD (IY),#FF
;       LD HL,#5C92
;       LD (#5C68),HL
        LD HL,#5CB6
        LD (HL),#F4

        LD L,#36
ADR5CC8 EQU $-1
        LD (HL),#36
VAR5CC8 EQU $-1

        LD L,#36
ADR5CFA EQU $-1
        LD (HL),#36
VAR5CFA EQU $-1

        LD A,#3F
VAR5D16 EQU $-1
        LD (#5D16),A
        LD C,5
        CALL TRDOS
        LD A,(23823)
        OR A
        JR NZ,SC_ERROR
        LD HL,TABLADR
        LD DE,#4400+TABL_SM
        CALL DAT_XOR
TR_DOS  LD C,6
        CALL TRDOS
        DI
        LD A,(23823)
        OR A             ;ok
        JR Z,SC_ERROR
        CP #14           ;*break*
        JR NZ,TR_DOS

SC_ERROR
        CALL STOPDRV
        CALL REGS
        EX DE,HL
        LDIR
;       CALL #6E3C
        LD A,#FD
        LD I,A
        IM 2
        LD SP,#3131
STEK    EQU $-2
        EI
        RET

DERR    LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR;    LD HL,#2121
;       LD (23613),HL
;       LD A,#C9
;       LD (#5CC2),A
COMRET  RET
DRIA    EX (SP),HL
        PUSH AF
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
        RET
RIA     DUP 3
        POP  HL
        EDUP
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
STPD_4  JP #3D2F
TRDOS
        LD HL,#4400
TRDOS1  LD DE,#1111
TR_SEC  EQU $-2
        LD B,1
        PUSH HL
;       LD HL,(23613)
;       LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23824),A
        LD (23823),A
        DEC A
        LD (#5D15),A
        LD (#5D17),A
        LD (SP2),SP
        JP #3D13
REGS    LD DE,#4000
REGS_1  LD HL,#5C00
        LD BC,#0400
        RET
;       DUP 7
;       DB #C9
;       EDUP

        ORG #FD00
;       LD HL,#2758
;       EXX
        LD HL,#5B14
        LD A,(HL)
        OR A
        JR Z,NO_UL
        XOR A
        LD (#8327),A

NO_UL   INC L
        LD A,(HL)
        OR A
        JR Z,NO_UT
        LD A,#18
        LD (#74F0),A
        LD (#6FB3),A
        PUSH HL
        LD HL,#FBE2
        LD DE,#000E
        LD B,3
ULT_L   LD (HL),E
        INC L
        LD (HL),E
        INC L
        LD (HL),#AF
        ADD HL,DE
        DJNZ ULT_L
        POP HL

NO_UT   INC L
        LD A,(HL)
        OR A
        JR Z,NO_UA
        LD A,#B7
        LD (#7E03),A
        LD (#7C3B),A

NO_UA   INC L
        LD A,(HL)
        OR A
        JR Z,NO_INV
        LD A,#C9
        LD (#8140),A
        LD A,#C3
        LD (#824C),A

NO_INV  INC L
        LD A,(HL)
        OR A
        JR Z,NO_GM
        LD A,#AF
        LD (#7CBB),A

NO_GM   INC L
        LD A,(HL)
        OR A
        JR Z,NO_SKPLK
        PUSH HL
        LD A,#CD
        LD HL,#B2F7
        LD DE,SKPKDATA
        LD BC,ESKPKDATA-SKPKDATA
        LD (#7437),A
        LD (#7438),HL
        EX DE,HL
        LDIR
        POP HL

NO_SKPLK
        INC L
        LD A,(HL)
        OR A
        JR Z,NO_PENT
        LD DE,#2DA
        LD (#AEA1),DE

NO_PENT DEC L
        LD B,6
CHK_CHT LD A,(HL)
        OR A
        JR Z,Y_SL_HS
        LD A,#C9
        LD (SAVE_HS),A
;       LD A,2
        CALL BORD_FLASH
        JR NO_SL_HS
Y_SL_HS DEC L
        DJNZ CHK_CHT

        LD HL,(#5CF4)
        LD (TR_SEC),HL

        LD DE,ADR5CC8
        LD A,(#5D16)
        LD (VAR5D16),A
        AND 3
        ADD A,#C8
        LD H,#5C
        LD L,A
        LD (DE),A
        INC E
        INC E
        LD A,(HL)
        LD (DE),A
        INC E
        INC E
        LD A,L
        ADD A,#FA-#C8
        LD L,A
        LD (DE),A
        INC E
        INC E
        LD A,(HL)
        LD (DE),A

        LD BC,#EFFE
        IN A,(C)
        RRA
        JR C,NO_REST_HS
        LD B,C
        IN A,(C)
        RRA
        JR C,NO_REST_HS
SHS_KW  IN A,(C)
        RRA
        JR NC,SHS_KW
        LD A,6
        CALL BORD_FLASH
        LD HL,TABLADR
        LD DE,#6000+TABL_SM
        CALL DAT_XOR
SAV_HS1 LD HL,#6000
        LD C,6
        CALL TRDOS1
        DI
        LD A,(23823)
        OR A             ;ok
        JR Z,SAV_HS2
        CP #06           ;no disk
        JR Z,SAV_HS2
        CP #14           ;*break*
        JR NZ,SAV_HS1
SAV_HS2 CALL STOPDRV

NO_REST_HS

        LD DE,TABLADR
        LD HL,#6000+TABL_SM
        CALL DAT_XOR

NO_SL_HS
        JP #6E9C
;       DB #6E

        ORG #6E7D
BORD_FLASH
        HALT
        OUT (#FE),A
        HALT
        HALT
        XOR A
        OUT (#FE),A
        RET
SKPKDATA INCBIN "HLP_KEY"
ESKPKDATA

        ORG #6000
        INCBIN "hiscores"

        ORG #5CF4
        DW SC_TRSC
        ORG #FD00

