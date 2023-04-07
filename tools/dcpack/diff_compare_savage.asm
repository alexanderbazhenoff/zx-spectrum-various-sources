; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


; Compare differences and save routines for DCpack v1.0 by alx^bw


        ORG #6000

TRKSC1  EQU #3D08       ;FIRST TRACK/SECTOR OF 1
TRKSC2  EQU #7E0D       ;FIRST TRACK/SECTOR OF 2
ADDR    EQU #6367       ;STARTADDR OF DIFFERENCES
LENGHT  EQU #97         ;LENGHT (SEC)
MODE    EQU 0           ;0 - XOR, 1 - PUT DIFFERENCES OF 1,
                        ;2 - PUT DIFFERENCES OF 2

;       DISP #4000
        DI
        LD (STEK),SP
        LD SP,#4800
        LD B,LENGHT
        LD IX,ADDR

LOOP    PUSH BC
        PUSH IX
        LD BC,#0105
        LD DE,TRKSC1
TRK1    EQU $-2
        LD HL,#4800
        PUSH HL
        CALL #3D13
        LD HL,(#5CF4)
        LD (TRK1),HL
        LD BC,#0105
        LD DE,TRKSC2
TRK2    EQU $-2
        LD HL,#4900
        PUSH HL
        CALL #3D13
        LD HL,(#5CF4)
        LD (TRK2),HL
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
;       ENT
