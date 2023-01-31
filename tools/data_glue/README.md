# Data Glue v1.0

by alx^brainave о1.о9.2оо5


## What's this?

A packer utility to glue innersector space. Please read russian info.txt file for details.

I used this tool to make some later crack releases and decrease total space on the floppy disk.
This version includes the latest fixed sources in depacker which wasn't uploaded to web
archives. But I am not sure that you can really need this, source I made this tool for me.

At the beginning you can select source disk drive and the destination disk drive. Then this
start to search blocks with names like `blokXXX.R`, where `RRR` is the number of the file
(0...127). If there is no number this will start to glue data in the found blocks. At the
end this save a file with `index#XX`, where `XX` is the number of total glued files.

The format of index file is:

- byte +00, +01, +02 - offset from the beginning of the data. the byte arrangement is as
follows: low, medium, high.
- byte +03 - the high byte of data length.

...and again and again.

Read russian manual and `glue_load.asm` for example of address, length and total sectors
load calculation.

## Howto?

This sources in ALASM 5.x format. So you can download them to build in ZX-Spectrum emulator,
otherwise convert yourself to modern assemblers like sjasm.

## What's the files?

- `main.asm`: Data glue packer sources.
- `glue_load.asm`: Data glue depack routines.
- `info.txt`: Original readme file from 00s.
- `README.md`: This file.

## URLs

- [zxart.ee](https://zxart.ee/rus/soft/tool/io-handling/diskovye-utility/data-glue-utility/data-glue-utility/)
- [virtual trdos](https://vtrd.in/release.php?r=b473e64b082b05132b10445d1bc2ab8d)
