# zed-multicomp
Zedboard implementation of multicomp. The zedboard has enough block ram to support the full 64k using internal ram. The ram code and memory map has been amended accordingly. The VGA routines and roms are based on those from a port to the Papilio-Duo. Some of the memory and clocking routines are based on work by Michael Jørgensen.

Requires a ps2 pmod in JA: https://reference.digilentinc.com/reference/pmod/pmodps2/start

Zedboard 6502 rom is located in https://github.com/mattuna15/zed-multicomp/blob/master/ROMS/6502/basic_rom.hex

The original .hex files can be converted using Srecord. 
http://srecord.sourceforge.net/

Specify intel for input format and ascii-hex as output. Load resulting file into notepad++, remove header and trailer, replace spaces between values for "\n". 

The resulting file then needs to be loaded into the rom file.

<hr>
Project acknowledgments: <br>

http://searle.x10host.com/Multicomp/index.html<br>
https://www.retrobrewcomputers.org/doku.php?id=boards:sbc:multicomp:papilio-duo:start<br>
https://github.com/MJoergen/dyoc <br>

License:

“By downloading these files you must agree to the following: The original copyright owners of ROM contents are respectfully acknowledged. Use of the contents of any file within your own projects is permitted freely, but any publishing of material containing whole or part of any file distributed here, or derived from the work that I have done here will contain an acknowledgement back to myself, Grant Searle, and a link back to this page. Any file published or distributed that contains all or part of any file from this page must be made available free of charge.” - http://searle.x10host.com/Multicomp/index.html


