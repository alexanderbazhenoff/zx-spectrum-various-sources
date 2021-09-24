# zx-spectrum various sources

Lots of my various ZX-Spectrum assembler sources. Some of them written in the end of 90s, so I can't remember them all. Here is some my handmade tools and converters, which nowadays usually making on python etc. Others are loaders and patches, so you can find a 'game poke' or another tips. Also unfinished sources.

## TLDR

This sources is a Zilog Z80 Assembler in Alasm format. You should import and compile this source in [Alasm](https://zxart.ee/rus/soft/tool/music/pro-tracker-alasm/qid:365628/) ZX-Spectrum assembler [(I have used v5.08)](https://speccy.info/ALASM) to compile. Or convert this source manually for [SjASMPlus](http://speccy.info/SjASMPlus) which is crossplatform.

## Folder contents

- **tools**: file compare tools, RLE packing (Run-length encoding) for huge code blocks, various converters, tr-dos and tape save/load routines. Especially [`Data Glue Utility`](https://zxart.ee/rus/soft/tool/io-handling/diskovye-utility/data-glue-utility/qid:366462/) which allows you to decrease end-of-sector spaces on the disk and move data after loading. Also [`nfo viewer`](https://zxart.ee/rus/soft/demoscene/nfo-viewer/), a text info viewer with two-bitplan colours (25fps coloure mixing like 'Gigascreen'). `nfo viewer` was done, but wasn't released.
- **unfinished**: unfinished cracktro with two-bitplan colours (again my fav 25fps colour mixing). Also `sunshine cracktro` which was almost done, but never released.
- **loaders, patches, screen output routines, etc**: You can find some tricks and 'game pokes' here.

## URLs

- [brainwave cracktro v1 sources](https://github.com/alexanderbazhenoff/brainwave-cracktro-v1)
- [brainwave cracktro v2 sources](https://github.com/alexanderbazhenoff/brainwave-cracktro-v2)
- [stripped 512b intro sources](https://github.com/alexanderbazhenoff/stripped-512-bytes-inro)
- [Virtue Da Dirty Soul Intro sources](https://github.com/alexanderbazhenoff/virtue-da-dirty-soul-intro)
