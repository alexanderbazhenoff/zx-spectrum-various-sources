        ORG #6000

LOMODE  EQU 0     ;разновидность бордюрных выебонов
DEXOR   EQU 1     ;расксоривание при загрузке

LPILOT  EQU #0D98 ;длительность пилота [#0C98-stanandard]
TPILOT  EQU #98   ;частота пилота       [#A4-standard]
PPILOT  EQU #2F   ;пауза после пилота   [#2F-standard]
CPILOT  EQU #020F ;цвета при пилоте (цвет/xor) [#020F]

BITSUB  EQU #23   ;разница в длит. импульса для битов
                  ;0 и 1 [#42]
BITPAU  EQU #22   ;мин длина импульса   [#3E]
ENDPAU  EQU #3B   ;пауза после сохранения данных [#3B]
COLETC  EQU #3B0E ;цвета при сохр. данных      [#3B0E]

LFLP    EQU #2    ;пауза при сканинге пилот-тона [#415]

        JR LOA
        LD HL,SCR
        LD DE,#4000
        LD BC,#1B00
        LDIR 

        LD IX,#4000
        LD DE,#1B00
        LD A,#FF
        CALL SAVE
        RET 

        LD HL,#4000
        LD DE,#4001
        LD BC,#1AFF
        LD (HL),L
        LDIR 

LOA
        LD IX,#4000
        LD DE,#1B00
        LD A,#FF
        SCF 
        CALL load
        LD HL,#4000
        LD BC,#1B00
DEXORL  LD A,(HL)
        XOR L
        LD (HL),A
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,DEXORL
        RET 

        ;JP NC,error

        ;---- save pilot
SAVE    LD      HL,LPILOT
LL04D0  EX      AF,AF'
        INC     DE
        DEC     IX
        DI 
        LD      A,'CPILOT
        LD      B,A
LL04D8  DJNZ    LL04D8
        OUT     (#FE),A
        XOR     .CPILOT
        LD      B,TPILOT
PILLEN  EQU $-1
        DEC     L
        JR      NZ,LL04D8
;       PUSH HL
;       LD HL,PILLEN
;       DEC (HL)
;       POP HL
        DEC     B
        DEC     H
        JP      P,LL04D8

        ;----- pause after pilot
        LD      B,PPILOT
LL04EA  DJNZ    LL04EA

        ;----- save data
        OUT     (#FE),A
        LD      A,#0D
        LD      B,#37
LL04F2  DJNZ    LL04F2
        OUT     (#FE),A
        LD      BC,#3B0E
        EX      AF,AF'
        LD      L,A
        JP      LL0507
LL04FE  LD      A,D
        OR      E
        JR      Z,LL050E
        LD      L,(IX+#00)
LL0505  LD      A,H
        XOR     L
LL0507  LD      H,A
        LD      A,#01
        SCF 
        JP      LL0525
LL050E  LD      L,H
        JR      LL0505
LL0511  LD      A,C
        BIT     7,B
LL0514  DJNZ    LL0514
        JR      NC,LL051C
        LD      B,BITSUB
LL051A  DJNZ    LL051A
LL051C  OUT     (#FE),A
        LD      B,BITPAU
        JR      NZ,LL0511
        DEC     B
        XOR     A
        INC     A
LL0525  RL      L
        JP      NZ,LL0514
        DEC     DE
        INC     IX
        LD      B,#31
        LD      A,#7F
        IN      A,(#FE)
        RRA 
        RET     NC
        LD      A,D
        INC     A
        JP      NZ,LL04FE
        LD      B,#3B
LL053C  DJNZ    LL053C
        RET 

load   INC D
       EX AF,AF'
       DEC D
       DI 
       LD A,8
       OUT (#FE),A
       LD HL,#053F
       PUSH HL
       IN A,(#FE)
       RRA 
       AND #20
       OR 2
       LD C,A
       CP A
LL822  RET NZ
LL823  CALL LL946
       JR NC,LL822
       LD HL,LFLP
LL831  DJNZ LL831
       DEC HL
       LD A,H
       OR L
       JR NZ,LL831
       CALL LL942
       JR NC,LL822
LL843  LD B,#96         ;#9C
       CALL LL942
       JR NC,LL822
       LD A,#C6
       CP B
       JR NC,LL823
       INC H
       JR NZ,LL843
LL858  LD B,#C9
       CALL LL946
       JR NC,LL822
       LD A,B
       CP #D6
       JR NC,LL858

       ;--- load data
       CALL LL946
       RET NC
       LD A,C
       XOR 3
       LD C,A
       LD H,0
       LD B,#A8         ;#B0
       JR LL915
LL884  EX AF,AF'
       JR NZ,LL894
       JR NC,LL904
        IFN DEXOR
        EXA 
        LD A,L
        XOR LX
       LD (IX),A
        EXA 
        ELSE 
        LD (IX),L
        ENDIF 
       JR LL909
LL894  RL C
       XOR L
       RET NZ
       LD A,C
       RRA 
       LD C,A
       INC DE
       JR LL911
LL904  LD A,(IX)
       XOR L
       RET NZ
LL909  INC IX
LL911  DEC DE
       EX AF,AF'
       LD B,#AA         ;#B2
LL915  LD L,1
LL917  CALL LL942
       RET NC
       LD A,#B4         ;#CB
       CP B
       RL L
       LD B,#A8         ;#B0
       JP NC,LL917
       LD A,H
       XOR L
       LD H,A
       LD A,D
       OR E
       JR NZ,LL884
       LD A,H
       CP 1
       RET 
LL942  CALL LL946
       RET NC

        IFN LOMODE


LL946  LD A,#12         ;#16
LL948  DEC A
       JR NZ,LL948
;       NOP
;       NOP
       AND A
LL952  INC B
       RET Z
       LD A,#7F
       IN A,(#FE)
       RRA 
       NOP 
       XOR C
       AND #20
       JR Z,LL952
       LD A,C
       CPL 
       LD C,A
        IF0 LOMODE-1
        LD R,A
        AND 7
        OR 8
        OUT (#FE),A
        SCF 
        ENDIF 
        IF0 LOMODE-2
        LD R,A
        AND 4
        OR 8
        OUT (#FE),A
        SCF 
        RET 
        ENDIF 
        RET 

        ELSE 

LL946  LD A,#12         ;#16
LL948  DEC A
       JR NZ,LL948
       AND A
LL952  INC B
       RET Z
       LD A,#7F
       IN A,(#FE)
       RRA 
;      NOP
       XOR C
       AND #20
       JR Z,LL952
       LD A,C
       CPL 
       LD C,A

        PUSH BC
        AND 4
        LD C,A
        RRA 
        OR C
        RRA 
        OR C
        AND 7
        OR 8
        NOP 
        OUT (#FE),A
        POP BC
        SCF 
        RET 

        ENDIF 

SCR    INCBIN "Castle0"
