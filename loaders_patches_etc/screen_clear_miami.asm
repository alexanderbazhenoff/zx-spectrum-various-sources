        ORG #E700

BORDER  EQU 5      ;БОРДЮР ДЛЯ ЗАСТАВКИ
TABL    EQU #ED00  ;АДР. ТАБЛИЦЫ ДЛЯ
                   ;ВЫВОДА
INTABL  EQU #EF00  ;ТАБЛИЦА ДЛЯ INT'А
INTVEC  EQU #EEEE  ;УКАЗАТЕЛЬ ВЕКТОРА INT
INTVEC1 EQU #EEEF  ;^+1
TSTBYT  EQU #EF18  ;АДРЕСС БАЙТА ДЛЯ ПРО-
                   ;ВЕРКИ НА НАЛИЧИЕ 128KB
        DI 
        LD BC,#7FFD
        LD HL,TSTBYT
        LD HL,TEST
        LD DE,#4000
        LD BC,10
        LDIR 

        LD BC,#7FFD
        LD HL,TSTBYT
        LD E,#16+8
        CALL #4000

        CP E
        JP Z,MOD48
        LD HL,INTABL
        LD DE,INTABL+1
        LD BC,#100
        LD A,H
        LD I,A
        DEC A
        LD (HL),A
        LDIR 
        IM 2
        LD A,#C9
        LD (INTVEC),A
        LD HL,CLCL
        LD (INTVEC1),HL
        LD H,C
        LD L,H

        EI 
        HALT 
        LD A,#C3
        LD (INTVEC),A
        EI 
L_LOOP  INC HL
        LD B,15
L_PAUS  DJNZ L_PAUS
        INC DE
        INC DE
        JP L_LOOP

CLCL    POP DE
        LD A,H
        CP 1
        JP C,MOD48
        LD A,L
        CP #3F
        JP C,MOD48




        LD A,#C9
        LD (INTVEC),A
        EI 
        CALL CLS

        LD HL,TABL
        PUSH HL
        LD DE,TABL+1
        LD (HL),#18+BORDER
        LD BC,320
        LDIR 
        EXX 
        LD BC,#7FFD
        EXX 

        LD BC,160
        POP HL
        LD DE,TABL+319

BMLP    EI 
        HALT 
        LD (#2222),HL   ;16
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL
        LD (#2222),HL

                        ;10
BORD    LD A,#10        ;7
        LD (HL),A       ;6
        INC HL          ;6
        INC HL          ;6
        LD (DE),A       ;6
        DEC DE          ;6
        DEC DE          ;6
        EXX             ;4

        LD HL,#ED00     ;10
        LD DE,318       ;10

BLP1    LD A,(HL)       ;7
        AND #18
        OUT (C),A       ;12
        LD A,(HL)
        AND 7           ;7
        OUT (#FE),A     ;11
        INC HL          ;6
        LD A,(#7E7E)    ;13
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)
        LD A,(#7E7E)    ;TT=104
        LD A,(HL)
        LD A,(HL)       ;6
        LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        LD A,(HL)
        JP JUMP

JUMP    DEC DE          ;6
        LD A,D          ;4
        OR E            ;4
        JP NZ,BLP1      ;10
        EXX 
        DEC BC
        LD A,B
        OR C
        JP NZ,BMLP
        LD BC,#7FFD
        LD A,#10
        OUT (C),A
        JR EXIT

MOD48   EI 
        CALL CLS
EXIT    XOR A         ;AND NOW ONLY FOR
        OUT (#FE),A   ;MIAMI COBRA
        LD A,#3B
        LD I,A
        IM 1
        LD BC,#FDFE
        IN A,(C)
        AND 1+2+4+8+16
        CP 2+4+8+16
        JR NZ,NOCHEA
        LD B,#BF
        IN A,(C)
        AND 1+2+4+8+16
        CP 1+4+8+16
        JR NZ,NOCHEA
        LD B,C
        IN A,(C)
        AND 1+2+4+8+16
        CP 1+2+8+16
        JR NZ,NOCHEA
        EI 
        HALT 
        LD A,7
        OUT (C),A
        LD B,10
CH_PAUS HALT 
        DJNZ CH_PAUS

        XOR A
        OUT (C),A
        LD A,#C9
        LD (#CEA0),A




NOCHEA  LD HL,#9D00
        PUSH HL
        EI 
        LD HL,#E700
        LD DE,#E701
        LD BC,#FB00-#E700
        LD (HL),0
        JP #33C3


CLS     HALT 
        LD HL,#5AFF
        LD DE,#5AFE
        LD (HL),0
        LD BC,#1AFF
        LDDR 
        RET 

TEST    OUT (C),L
        LD (HL),L
        OUT (C),E
        LD (HL),E
        OUT (C),L
        LD A,(HL)
        RET 
