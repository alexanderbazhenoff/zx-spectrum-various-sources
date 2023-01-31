; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE


TRDOS   PUSH HL
        LD HL,(23613)
        LD (ERR+1),HL
        LD HL,DRIA
        LD (#5CC3),HL
        LD HL,ERR
        EX (SP),HL
        LD (23613),SP
        EX AF,AF'
        LD A,#C3
        LD (#5CC2),A
        XOR A
        LD (23823),A
        LD (23824),A
        EXA
        LD (SP2),SP
        JP #3D13
D_ERR   LD SP,#3131
SP2     EQU $-2
        LD (23823),A
ERR     LD HL,#2121
        LD (23613),A
        LD A,#C9
        LD (#5CC2),A
        LD A,(23823)
        RET
DRIA    EX (SP),HL
        PUSH AF
        LD A,H
        CP 13
        JR Z,RIA
        XOR A
        OR H
        JR Z,NO_ERR
NO_ERR  POP AF
        EX (SP),HL
        RET
RIA     POP HL
        POP HL
        POP HL
        XOR A
        LD (23560),A
        LD A,2
        OUT (#FE),A
        LD A,"R"
        LD HL,#3F7E
        EX (SP),HL
        JP #3D2F
