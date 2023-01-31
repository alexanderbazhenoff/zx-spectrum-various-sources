# zx-spectrum various sources


Lots of my various ZX-Spectrum assembler sources. Some of them written in the end of 90s, so I can't remember them all.
Here is some my handmade tools and converters, which nowadays usually making on python etc. Others are loaders, screen
output routines and patches, so you can find a 'game poke' or another tips. Unfinished sources also.

## TLDR

These sources are for Zilog Z80 Assembler in Alasm format. You should import and compile this source in
[Alasm](https://zxart.ee/rus/soft/tool/music/pro-tracker-alasm/qid:365628/) ZX-Spectrum assembler
[(I have used v5.08)](https://speccy.info/ALASM) to compile. Or convert this source manually for 
[SjASMPlus](http://speccy.info/SjASMPlus) which is cross-platform.

## Preamble

Since a school days in 90s I was totally passioned by 8-bit `demoscene` culture. A specially crack releases where all
these wonderful effects first time came from. In the begging I was too lazy. So I watched and debug some stuff to see a
code tricks using hardware `shadow monitor` on my [`Scorpion ZS-256`](https://en.wikipedia.org/wiki/Scorpion_ZS-256), a
Sergery Zonov's ZX-Spectrum Russian clone. Later I moved to a Russian demoscene classic ZX-Spectrum clone, 
[`Pentagon 128`](https://en.wikipedia.org/wiki/Pentagon_(computer)) and these all started.

In the end of 90s I was inspired to made not also a [`crack intro`](https://www.youtube.com/watch?v=OU9Jh86ISqQ), just
would love to fix firm bugs, performance, add TR-DOS save/load, exam some history of game making and all these stuff. In
those days cracking games on ZX-Spectrum mostly went to the past, but still here was some revers-research. And yes,
Russian users had their specific disk systems, so you need to adapt them from time to time. If you look on ZX-Spectrum
archive you'll find a various TR-DOS versions of the same game from different crack teams. The reason is only in making
this better than another guys, as `the scene tradition`.

So until the middle 2005 more than 50 crack releases came. Some of them was with an intros, some of them just with sign,
but fixed, packed, etc.

## Folder contents in short

- [**tools**](tools): file compare tools, 
[`RLE packing`](https://github.com/alexanderbazhenoff/zx-spectrum-various/blob/main/tools/rle_pack.asm)
(Run-length encoding) for huge code blocks, [`DCpack`](tools/dcpack) (delta packing tool), various converters, tr-dos
and tape save/load routines. Especially
[`Data Glue Utility`](https://zxart.ee/rus/soft/tool/io-handling/diskovye-utility/data-glue-utility/qid:366462/) which 
allows you to decrease end-of-sector spaces on the disk and move data after loading. 

![Data Glue](https://zxart.ee/zxscreen/type:standard/id:392818/zoom:1/filename:image.png)

Also [`nfo viewer`](https://zxart.ee/rus/soft/demoscene/nfo-viewer/), a text info viewer with two-bitplan colours (25fps
colour mixing like `gigascreen`, a ZX-Spectrum software screen mode). `nfo viewer` was done, but wasn't ever released.

![Nfo Viewer](https://zxart.ee/image/type:prodImage/id:273669/filename:nfoview.png)

- [**unfinished**](unfinished): unfinished cracktros: first one with two-bitplan colours (again my fav 25fps colour
mixing), another is [*`sunshine cracktro`*](unfinished/sunshine_cracktro) which was almost done, but never released.

![Sunshine cracktro](https://zxart.ee/zxscreen/border:7/mode:mix/pal:srgb/type:gigascreen/zoom:1/id:195010/)

- [**loaders, patches, screen output routines, etc**](loaders_patches_etc): mini-cracktros, trainer modes (some
exclusive *'game pokes'* are placed in init patches), methods how to initialize tr-dos variables when #5b00...#6000
memory was used by data (check [`save/load patches`](loaders_patches_etc)), etc.

## Detailed folder contents

Browse folders for README(s) or read traditional [`files.bbs`](files.bbs).

## Related URLs

- [brainwave cracktro v1 sources](https://github.com/alexanderbazhenoff/brainwave-cracktro-v1)
- [brainwave cracktro v2 sources](https://github.com/alexanderbazhenoff/brainwave-cracktro-v2)
- [stripped 512b intro sources](https://github.com/alexanderbazhenoff/stripped-512-bytes-inro)
- [Virtue Da Dirty Soul Intro sources](https://github.com/alexanderbazhenoff/virtue-da-dirty-soul-intro)
- [zxart.ee archive](https://zxart.ee/rus/avtory/a/alx/)
