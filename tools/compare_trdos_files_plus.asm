        ORG #6000

TRKSC1  EQU #7502       ;FIRST TRACK/SECTOR OF 1
TRKSC2  EQU #8A01       ;FIRST TRACK/SECTOR OF 2
ADDR    EQU #5B00       ;STARTADDR OF DIFFERENCES
LENGHT  EQU #A1         ;LENGHT (SEC)
MODE    EQU 0           ;0 - XOR, 1 - PUT DIFFERENCES OF 1,
                        ;2 - PUT DIFFERENCES OF 2

        DISP #4000
        DI 
        LD (STEK),SP
        LD SP,#4800
        LD B,LENGHT
        LD IX,ADDR

LOOP    PUSH BC
        PUSH IX
        LD B,1
        LD DE,TRKSC1
TRK1    EQU $-2
        LD HL,#4800
        PUSH HL
        CALL LOAD
        LD (TRK1),DE
        LD BC,#0105
        LD DE,TRKSC2
TRK2    EQU $-2
        LD HL,#4900
        PUSH HL
        CALL LOAD
        LD (TRK2),DE
        XOR A
        OUT (#FE),A
        POP DE
        POP HL
        LD BC,#100
        POP IX
CPLOOP  LD A,(DE)
        CP (HL)
        JR Z,ANALOG
        PUSH AF
        LD A,7
        OUT (#FE),A
        POP AF
        IF0 MODE
        XOR (HL)
        ENDIF 
        IF0 MODE-1
        LD A,(HL)
        ENDIF 

        LD (IX),A
ANALOG  INC HL
        INC DE
        INC IX
        DEC BC
        LD A,B
        OR C
        JR NZ,CPLOOP
        LD HL,#5800
ATTRIB  EQU $-2
        LD (HL),#3F
        INC HL
        LD (ATTRIB),HL
        POP BC
        DJNZ LOOP
        LD SP,#3131
STEK    EQU $-2
        RET 
LOAD
LL5B1C  PUSH BC
        PUSH DE
        LD A,D
        OR A
        RRA 
        LD C,A
        LD A,#3C
        JR NC,LL5B28
        LD A,#2C
LL5B28  LD IX,#1FF3
        CALL DOS
        LD A,C
        LD C,#7F
        LD IX,#2A53
        CALL DOS
        LD A,#18
        LD IX,#2FC3
        CALL DOS
        POP DE
        POP BC
LL5B44  PUSH BC
        PUSH DE
        LD IX,#2F1B
        CALL DOS
        POP DE
        INC H
        INC E
        BIT 4,E
        JR Z,LL5B5C
        LD E,#0
        INC D
        POP BC
        DJNZ LL5B1C
        JR LL5B5F
LL5B5C  POP BC
        DJNZ LL5B44
LL5B5F  RET 
DOS     PUSH IX
        JP #3D2F


        ENT 
