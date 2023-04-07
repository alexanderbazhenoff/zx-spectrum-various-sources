; This Source Code Form is subject to the terms of the MIT
; License. If a copy of the source was not distributed with
; this file, You can obtain one at:
; https://github.com/alexanderbazhenoff/zx-spectrum-various-sources


;-----------------------------------------------------------

;п/п извлечения и загрузки файла из склеенного массива
;с помощью Data Glue 1.0 By alx/brainwave

;эта подпрограмма может служить как фрагментом, который вы
;сможете включить в свои проекты ,так и примером того, что
;можно делать со склеенными данными

;пред использованием необходимо настроить все параметры,
;лишние фрагменты условного ассемблирования можно убрать.


;-----------------------[begin of clipboard]-----------------

load_addr EQU #6100     ;куда грузить массив
tr_dos    EQU #3D13     ;адрес п/п загрузки
dep_addr  EQU #0000     ;адрес распаковщика (=0, если не надо)
indexaddr EQU #6080     ;адрес размещения index#nn
last_trsc EQU #5CF4     ;см. системные переменные tr-dos

;ключи условного транслирования

blok64_sw EQU 1         ;не 0, если кол-во блков меньше 64
                        ;(включая блок с номером "0")
blpack_sw EQU 1         ;не 0, если все блоки были
                        ;предварительно запакованы



blok_i00  EQU .indexaddr;не ноль, если адрес расположения
                        ;index#nn круглый (в hex)
ladr_i00  EQU load_addr ;еслли адрес загрузки блока кругый

        ORG indexaddr
        INCBIN "index#nn"

        ORG #6000

        XOR A
;при вызове в аккамулятор необходимо занести номер блка
;A=(#00...#NN)

        IF0 blok64_sw
        LD L,A
        LD H,0
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        LD DE,indexaddr
        ADD HL,DE
        ELSE
        ADD A,A
        ADD A,A
        IF0 blok_i00
        LD L,A
        LD H,'indexaddr
        ELSE
        LD E,A
        LD D,0
        LD HL,indexaddr
        ADD HL,DE
        ENDIF
        ENDIF

        LD A,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD B,(HL)
        OR A
        JR Z,sec_nad
        INC B
sec_nad LD HL,(last_trsc)
        PUSH AF
tsc_adl
        LD A,D
        OR E
        JR Z,tsc_ade
        INC L
        BIT 4,L
        JR Z,tsc_nad
        INC H
        LD L,0
tsc_nad DEC DE
        JR tsc_adl
tsc_ade EX DE,HL

        LD HL,load_addr

        PUSH HL
        PUSH BC

        LD C,5
        CALL tr_dos
        POP BC
        POP HL
        POP AF

        IF0 ladr_i00
        LD H,'load_addr
        LD L,A
        ELSE
        PUSH DE
        LD E,A
        LD D,0
        LD HL,load_addr
        ADD HL,DE
        POP DE
        ENDIF

        IF0 blpack_sw
        LD C,0
        ENDIF

        LD DE,load_addr
        LDIR

        RET

;-----------------------[end of clipboard]--------------------

