; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the MPL was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/LICENSE

        ORG #6E9C
        INCBIN "NETH#"

        ORG #7437
        CALL INS_

        ORG #B2F7
INS_    ;PUSH BC
        LD A,#FB
        IN A,(#FE)
        AND 1+2+4+8+16
        CP 1+2
        JR NZ,NOSKIP

        XOR A
        LD (#7C6C),A
        INC A
        LD (#FF8E),A

NOSKIP  LD A,(#FF8E)
        ;POP BC
        RET

        ORG #6E9C