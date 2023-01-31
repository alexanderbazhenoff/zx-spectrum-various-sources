; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

MODE    EQU 1           ;0 - 48k mode
CHEAT   EQU #00         ;0 - off

SC_TRSC EQU #2006

TABLADR EQU #713C  ;addr of highscore tabl
TABLLEN EQU #0049  ;lenght
TABL_SM EQU #00B6  ;внутрисекторное смещение


        ORG #5C4B
        IFN MODE
        DB 1
        ORG #C000,#11
        INCBIN "ffood3"
        ELSE
        DB 0
        ENDIF

        ORG #6000
        INCBIN "ffood#"

        ORG #FF00
        INCBIN "hiscores"

        ;correct kempson test
        ORG #6AA5
        LD B,#14
KMPST   IN A,(#1F)
        AND 1+2+4+8+16
        LD A,0
        JR NZ,KMPSTN
        DEC BC
        LD A,B
        OR C
        JR NZ,KMPST
        DEC A
KMPSTN  LD (#6ABD),A
        RET
        DB 0,0,0,0

        ;correct pause mode
        ORG #67EF
        CALL KEYRQ_P
        RET NZ
PMOD1   CALL KEYRQ_P
        JR Z,PMOD1
PMOD2   CALL KEYRQ_P
        JR NZ,PMOD2
PMOD3   CALL KEYRQ_P
        JR Z,PMOD3
        RET
KEYRQ_P CALL #C619
        LD A,#A0
        JP #C5E3

        ;SYNCHRONIZE!

        ;game over (разворачивание надписи 'fast food')
        ORG #6929
        DB 0,0,0
        CALL SYNC1

        ;level completed
        ORG #640F
        LD BC,#0605
        CALL SYNC0
        ORG #644F
        LD BC,#0305
        CALL SYNC0
        ORG #64A3
        LD BC,#8801
        CALL SYNC0

        ;get ready
        ORG #BCA5
        LD BC,#0709
        CALL SYNC0

        ;innerlevel animation
        ORG #6813
        LD BC,#2727
        JP Z,SYNCL

        ;high score tabl (name entered)
        ORG #6ECD
        LD BC,#8801
        CALL SAVE_HS

        ;'fast food' logo moving
        ORG #6891
        CALL SYNC1
        ORG #68AC
        CALL SYNC1

        ORG #65F0
SYNC1   LD BC,#0105
        JP SYNC0

        ;save highscores
SAVE_HS CALL SYNC0
        IM 1
        LD A,I
        PUSH AF
        XOR A
        LD I,A

        LD C,5
        CALL TRDOS
        LD A,(23823)
        OR A
        JR NZ,SC_ERROR
        LD HL,TABLADR
        LD DE,#5D3B+TABL_SM
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
        POP AF
        LD I,A
        OR A
        JR Z,NOIM2
        IM 2
NOIM2
        EI
        RET

        ORG #5B15
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
TRDOS
        LD HL,#5D3B
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
REND_E


        ORG #6587
SYNC0   EI
SYNCH   HALT
        DJNZ SYNCH
        LD B,C
SYNCL   DEC BC
        LD A,B
        OR C
        JR NZ,SYNCL
        RET

        ;skip level keys
SKPLEVL EQU #661D

        ORG #5B14
        DB CHEAT

        ORG #5CF4
        DW SC_TRSC

        ORG #FDFD
        LD A,(#5B14)
        OR A
        JR Z,NOCHEAT
        XOR A
        LD (#BAE4),A
        LD A,#CD
        LD (#B9D9),A
        LD HL,SKPLEVL
        LD (#B9DA),HL
        LD DE,SKPLVD
        LD BC,ESKPLVD-SKPLVD
        EX DE,HL
        LDIR
        LD HL,#00C0
        LD (#B9FB),HL
        LD HL,#67D0
        LD (HL),30
        LD L,#D4
        LD (HL),29
        LD A,#C3
        LD (SAVE_HS),A
        LD A,2
        CALL BORD_FLASH
        JR NO_SL_HS

NOCHEAT XOR A
        LD I,A

        LD HL,(#5CF4)
        LD (TR_SEC),HL

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
        LD DE,#FF00+TABL_SM
        CALL DAT_XOR
SAV_HS1 LD HL,#FF00
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
        LD HL,#FF00+TABL_SM
        CALL DAT_XOR

NO_SL_HS
        JP #6100

BORD_FLASH
        HALT
        OUT (#FE),A
        HALT
        HALT
        XOR A
        OUT (#FE),A
        RET

SKPLVD
        LD BC,#FBFE
        IN A,(C)
        AND 4+8+16
        JR Z,SKPLEV
        LD A,(#AE73)
        RET
SKPLEV  LD A,1
        LD (#B30A),A
        JP #BA48
ESKPLVD
        DISPLAY "SAVE [maincode],",#6000,",",#9EFE
        DISPLAY "SAVE [res_code],",STOPDRV,",",REND_E-STOPDRV

