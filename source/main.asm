; test program
;by sebastian gurlin

.include "startup.asm" ;must be the first .include
.include "kernal.asm"
.include "zeroPage.asm"
.include "misc.asm"
.include "stdio.asm"
.include "console.asm"
.include "string.asm"
.include "stdlib.asm"
.include "memory.asm"
.include "vera.asm"
.include "input.asm"

Start:
jsr GoAnsi

MPrintF "Welcome, this is a test program\n"
MPrintF "Opening File...\n"
MFOpen "TEST.TST"
bcc +
	MPrintF "File Error! - Abort\n"
	jmp End
+
sta fileHandle
MPrintF "fileHandle = %u\n", fileHandle

MPrintF "closing file...\n"
lda fileHandle
jsr FClose
bcc +
	MPrintF "File Error! - Abort\n"
	jmp End
+

MPrintF "Opening File...\n"
MFOpen "LOG.TXT", ",P,W"
bcc +
	MPrintF "File Error! - Abort\n"
	jmp End
+
sta fileHandle2
MPrintF "fileHandle = %u\n", fileHandle2

MPrintF "writing to file...\n"
MFPrintF fileHandle2, "test\n"

MPrintF "closing file...\n"
lda fileHandle2
jsr FClose
bcc +
	MPrintF "File Error! - Abort\n"
	jmp End
+

;MPrintF "Vera Layer0 Config %b\n", L0_CONFIG
;MPrintF "Vera Layer1 Config %b\n", L1_CONFIG
;
;MPrintF "Vera Layer1 Mapbase 0x%x00\n", L1_MAPBASE
;
;
;MLoadR A, FOpenFileName
;jsr FOpen
;sta fileHandle
;MFPrintF fileHandle, "i am writing %c to a file", v1, v2, v3
;
;lda fileHandle
;jsr FClose
;
;MFOpen "TEST.NMAP"
;sta fileHandle
;
;MSetVeraLMH 0
;MLoadR B, 4*2
;lda fileHandle
;jsr FReadToVera
;
;lda fileHandle
;jsr FClose
;
;MFOpen "8PXFONT.BIN"
;;.byte $db
;sta fileHandle
;
;MSetVeraLMH $000400
;MLoadR B, 128
;lda fileHandle
;jsr FReadToVera
;
;lda fileHandle
;jsr FClose
;
;
;.MSetLayer0Tile8BitMode
;
;.MSetLayer0Tilebase $0400
;.MSetLayer0Mapbase 0
;;.MSetLayer1Tilebase 0
;
;
;MainLoop:
;	jsr UpdateKey
;
;	MIsPressed #"1"
;	bne ++
;		lda toggleLayer0
;		bne +
;			MEnableLayer0
;			inc toggleLayer0
;			bra ++
;		+
;			MDisableLayer0
;			stz toggleLayer0
;		.section data
;		toggleLayer0 .byte $0
;		.send
;	+
;	MIsPressed #"2"
;	bne +
;	MDisableSprites
;	+
;	;.byte $db
;	MIsPressed #"3"
;	bne ++
;		lda toggleLayer1
;		bne +
;			MEnableLayer1
;			inc toggleLayer1
;			bra ++
;		+
;			MDisableLayer1
;			stz toggleLayer1
;		.section data
;		toggleLayer1 .byte $0
;		.send
;	+
;	MIsPressed #"4"
;	bne +
;		MFOpen "TEST.NMAP"
;		sta fileHandle
;
;		MSetVeraLMH 0
;		MLoadR B, 32*32*2
;		lda fileHandle
;		;jsr FReadToVera
;		MLoadR A, bla
;		jsr FRead
;		;jsr FillVeraMemory
;
;		lda fileHandle
;		jsr FClose
;	+
;
;
;	jsr ResetKey
;	jmp MainLoop

End:
MPrintF "Good Bye.\n"
.MEndlessLoop

.dsection data

str1 	.text "this is a string %c hihi %x und ciao and %s", 0

v1	.byte "U"
v2	.byte $1F
v3	.text "okok",0
v4 .byte 23

fileHandle: .byte $0
fileHandle2: .byte $0

FOpenFileName: .text "TEST.TST",0

bla: .fill 32*32*2
	 .byte 0
