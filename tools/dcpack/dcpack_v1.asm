; This Source Code Form is subject to the terms of the MIT
; hLicense. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE


; DCPack 1.0 by alx^biranwave.
; A tool to compress differences.


        DISPLAY "DCPack v1.0 by Alx^Brainwave"
        DISPLAY "Special for compressing differences"

EXECUTE EQU #6000
BEGIN   EQU #DED0
LENGHT  EQU #1B6F
DESTIN_ EQU #4000

        ORG #6367
        INCBIN "#d_dif"    ; load diff

        ORG EXECUTE
        JP PACK
        JP UNXOR

DEPACK  LD HL,DESTIN_
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
DEPACK1 PUSH BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD C,B
        BIT 7,B
        JR Z,DEPACK2
        LD B,0
        RES 7,C
        JR DEPACK3
DEPACK2 LD C,(HL)
        INC HL
DEPACK3 LDIR
        POP BC
        DEC BC
        LD A,B
        OR C
        JR NZ,DEPACK1
        RET


UNXOR   LD HL,DESTIN_
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
UNXOR1  PUSH BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD C,B
        BIT 7,B
        JR Z,UNXOR2
        LD B,0
        RES 7,C
        JR UNXOR3
UNXOR2  LD C,(HL)
        INC HL
UNXOR3  LD A,(DE)
        XOR (HL)
        LD (HL),A
        INC HL
        INC DE
        DEC BC
        LD A,B
        OR C
        JR NZ,UNXOR3
        POP BC
        DEC BC
        LD A,B
        OR C
        JR NZ,UNXOR1
        RET

PACK    LD DE,BEGIN
        LD BC,LENGHT
        LD HL,DESTIN_
        LD (COLADR1),HL
        LD (COLADR2),HL
        XOR A
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL

PACK1   LD A,(DE)
        OR A
        JR NZ,PACKNZ
        INC DE
        DEC BC
        LD A,B
        OR C
        JR NZ,PACK1
        RET
PACKNZ  LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        PUSH BC
        PUSH DE
        PUSH HL
        CALL PACKCL
        PUSH HL
        LD HL,(#0000)
COLADR1 EQU $-2
        INC HL
        LD (#0000),HL
COLADR2 EQU $-2
        POP DE
        POP HL
        LD A,D
        OR A
        JR NZ,PACKLL
        LD A,E
        CP #80
        JR NC,PACKLL
        SET 7,E
        LD (HL),E
        INC HL
        RES 7,E
        JR PACKLL0
PACKLL  LD (HL),D
        INC HL
        LD (HL),E
        INC HL
PACKLL0 POP IX
        POP BC
PACKM1  LD A,(IX)
        LD (HL),A
        INC IX
        INC HL
        DEC BC
        DEC DE
        LD A,E
        OR D
        JR NZ,PACKM1
        PUSH IX
        POP DE
        LD A,B
        OR C
        RET Z
        JR PACK1

PACKCL  LD HL,0
PACKCL1 LD A,(DE)
        OR A
        JR Z,PACKCL2
PACKCL3 INC DE
        INC HL
        DEC BC
        LD A,B
        OR C
        JR NZ,PACKCL1
        RET
PACKCL2 PUSH DE
        POP IX
        CP (IX+1)
        JR NZ,PACKCL3
        CP (IX+2)
        JR NZ,PACKCL3
        CP (IX+3)
        JR NZ,PACKCL3
        CP (IX+4)
        JR NZ,PACKCL3
        RET


