Print:
	;char in Accu
	;prints to stdout
	IJSR stdout
	rts

SetStdout:
	;addr A
	lda Al
	sta stdout
	lda Ah
	sta stdout+1
	rts
SetStdMemPtr:
	;addr A
	lda Al
	sta stdMemPtr
	lda Ah
	sta stdMemPtr+1
	rts

CharToMem:
	;char in Accu
	;target pointer in stdMemPtr
	;.byte $db
	sta CharToMemChar		;temporarily store the chacter
	MPush A 				;push A to the stack
	lda stdMemPtr 			;get the target pointer and store it in A
	sta Al
	lda stdMemPtr+1
	sta Ah
	lda CharToMemChar 		;get the character back
	sta (A) 				;write the character to mem
	inc stdMemPtr 			;increment the stdMemPtr by1
	bne +
	inc stdMemPtr+1
	+

	MPull A
	rts
	CharToMemChar .byte $00

GoAnsi:
	;changes the X16 into Ansi (ASCII) mode
	;clobbers Accu
	lda #$0F
	jsr BSOUT
	rts

PrintF:
	;Prints a formatted String and inserts Values at placeholder positions
	;A = pointer to String, B - J = subsequent Pointers to Values
	;clobbers = Accu, y, A - J
	;lda #0						;save 0 in to Memory
	lda Al 						;save A 
	sta PrintFSave 				;save A 
	lda Ah 						;save A 
	sta PrintFSave + 1 			;save A 
	ldy #0 						;y = 0 for string index
	ldx #2						;x = 2 points to the next ZeroPage Register A+2 = B
	PrintFLoop:
		lda (A), y 				;get character
		bne +					;character is 0
			rts 				;then return
		+
		cmp #"\"
		bne +
			iny
			lda (A), y
			cmp #"n"
			bne PrintFPrintLoopRewind
				jsr EndLine
				iny
				jmp PrintFLoop
		PrintFPrintLoopRewind
		dey
		+ 
		cmp #"%"
		beq PrintFPercent		;character is %
			jmp PrintFnotPercentTarget
		PrintFPercent:
			iny 				;next character...
			lda (A), y
			sta PrintFPlaceholder
			phy

			lda Ah, x
			sta Ah
			lda Al, x
			sta Al
			inx
			inx

			lda PrintFPlaceholder
			cmp #"i"			;signed int ?
			bne +
				jsr PrintIntShortSigned
			+
			lda PrintFPlaceholder
			cmp #"u"			;unsigned int ?
			bne +
				jsr PrintIntShort
			+
			lda PrintFPlaceholder
			cmp #"h"			;singned hex ?
			bne +
				jsr PrintHexShortSigned
			+
			lda PrintFPlaceholder
			cmp #"x"			;unsigned hex ?
			bne +
				jsr PrintHexShort
			+
			lda PrintFPlaceholder
			cmp #"I"			;signed int ?
			bne +
				;
			+
			lda PrintFPlaceholder
			cmp #"U"			;unsigned int ?
			bne +
				;
			+
			lda PrintFPlaceholder
			cmp #"H"			;singned hex ?
			bne +
				jsr PrintHexLongSigned
			+
			lda PrintFPlaceholder
			cmp #"X"			;unsigned hex ?
			bne +
				jsr PrintHexLong
			+
			lda PrintFPlaceholder
			cmp #"c"			;character ?
			bne +
				jsr PrintChar
			+
			lda PrintFPlaceholder
			cmp #"s"			;string ?
			bne +
				jsr PrintString
			+
			lda PrintFPlaceholder
			cmp #"b"			;binary ?
			bne +
				jsr PrintBinaryShort
			+
			lda PrintFPlaceholder
			cmp #"B"			;binary ?
			bne +
				jsr PrintBinaryLong
			+
			ply
			iny
			lda PrintFSave
			sta Al
			lda PrintFSave + 1
			sta Ah
			jmp PrintFLoop
		PrintFnotPercentTarget:
		jsr Print				;print character to stdout
		iny
		jmp PrintFLoop
		PrintFSave .word 0
		PrintFPlaceholder .byte 0
SPrintF:
	;SourceAddress = A
	;TargetAddress = J
	;Values        = B-I
	;.byte $db
	lda Jl 				;set Target pointer
	sta stdMemPtr
	lda Jh
	sta stdMemPtr+1
	lda <#CharToMem 	;set stdout to CharToMem
	sta stdout
	lda >#CharToMem
	sta stdout+1

	jsr PrintF

	lda <#$FFD2 		;reset stdout to the Kernal Print routine (FFD2)
	sta stdout
	lda >#$FFD2
	sta stdout+1
	rts

EndLine:
	lda #13
	jsr Print
	rts
PrintChar:
	;prints a single Character
	;A = pointer to Character
	;clobbers: Accu
	lda (A)
	jsr Print
	rts
PrintCharAccu:
	;prints a single Character
	;Accu = poiter to Character
	;clobbers: none
	jsr Print
	rts
PrintString:
	;Prints a 0 terminated String, pointed to by A max 256 characters long
	;A = Pointer to String
	;clobbers = 
	ldy #0
	_loop:
		lda (A), y
		bne +				;character is 0
			jsr Print 		;print once more for 0 EndLine
			rts 			;then return
		+ 	
		phy				;character NOT 0
		jsr Print
		ply
		iny
		jmp _loop
PrintSignAccu:
	pha
	rol
	lda #"+"
	bcc +
		lda #"-"
	+
	jsr Print
	pla
	rts
PrintHexNibbleAccu:
	;Prints a Hex Nibble in the lower 4 bits of Accu
	;Accu = Nibble to Print
	;clobber = Accu, y, A
	tay
	.MLoadR A, #HexArray
	lda (A), y
	jsr Print
	rts
PrintHexShortAccu:
	;prints Hex Number
	;Accu = number to print
	;clobbers = Accu, y, A
	sta _save
	and #%11110000
	lsr
	lsr
	lsr
	lsr
	jsr PrintHexNibbleAccu
	lda _save
	and #%00001111
	jsr PrintHexNibbleAccu
	rts
	_save .byte 0
PrintHexShort:
	;Print Hex byte pointed to by A
	;A = pointer to byte to print
	;clobber = Accu, y 
	lda (A)
	jsr PrintHexShortAccu
	rts
PrintHexLong:
	;print 16bit Hex Number pointed to by (A)
	;A = pointer to Number
	;clobbers = Accu, y, A
	lda (A)
	pha
	ldy #1
	lda (A), y
	jsr PrintHexShortAccu
	pla
	jsr PrintHexShortAccu
	rts
PrintHexShortSignedAccu:
	jsr PrintSignAccu
	clc
	eor #$FF
	adc #$01
	jsr PrintHexShortAccu
	rts
PrintHexShortSigned:
	lda (A)
	jsr PrintSignAccu
	clc
	eor #$FF
	adc #$01
	jsr PrintHexShortAccu
	rts
PrintHexLongSigned:
	lda (A)
	jsr PrintSignAccu
	clc
	eor #$FF
	adc #$01
	pha
	ldy #1
	lda (A), y
	eor #$FF
	adc #$0
	jsr PrintHexShortAccu
	pla
	jsr PrintHexShortAccu
	rts
PrintBinaryShortAccu:
	;print 8bit binary in Accu
	;Accu = byte to Print
	;clobbers = A, y
	ldy #8
	PrintBinaryShortAccuLoop:
	rol
	pha
	lda #"1"
	bcs +	;zero ?
		lda #"0"
	+		;one
	jsr Print
	pla
	dey
	bne PrintBinaryShortAccuLoop
	rts
PrintBinaryShort:
	;print 8bit binary pointed to by A
	;A = pointer to byte to print
	;clobbers = A, y
	lda (A)
	jsr PrintBinaryShortAccu
	rts
PrintBinaryLong:
	;print 16bit binary pointed to by A
	;A = pointer to byte to print
	;clobbers = A, y
	lda (A)
	pha
	ldy #1
	lda (A), y
	jsr PrintBinaryShortAccu
	pla
	jsr PrintBinaryShortAccu
	rts
PrintIntShortAccu:
	sta PrintIntShortAccuTemp
	MPush A
	MLoadR A, #PrintIntShortAccuDivisorsTable
	lda PrintIntShortAccuTemp
	;.byte $db
	ldy #0
	PrintIntShortAccuLoop
		ldx #1
		sec
		PrintShortAccuDecLoop:
			sbc (A), y
			bmi PrintIntShortAccuMinus
			inx
		bra PrintShortAccuDecLoop
		PrintIntShortAccuMinus:
		dex
		clc
		adc (A), y
		pha
		txa
		clc
		adc #$30
		jsr Print
		pla
		iny
		cpy #3
		bne PrintIntShortAccuLoop
		MPull A
	rts
	PrintIntShortAccuDivisorsTable: .byte 100,10,1
	PrintIntShortAccuTemp: .byte $0
PrintIntShort:
	lda (A)
	jsr PrintIntShortAccu
	rts
PrintIntShortSigned:
	lda (A)
	jsr PrintSignAccu
	clc
	eor #$FF
	adc #$01
	lda (A)
	jsr PrintIntShortAccu
	rts

stdout: 	.addr BSOUT
stdMemPtr: 	.addr $0000

strPtr:		.word 0
strIndex:	.byte 0
HexArray: 	.text "0123456789ABCDEF"

MPrintF: .macro source, B=0, C=0, D=0, E=0, F=0, G=0
	;macro to print inline strings
	MPush A
	MLoadR A, #txt
	.if \B != 0
		MPush A
		MLoadR B, #\B
	.endif
	.if \C != 0
		MPush A
		MLoadR C, #\C
	.endif
	.if \D != 0
		MPush A
		MLoadR D, #\D
	.endif
	.if \E != 0
		MPush A
		MLoadR E, #\E
	.endif
	.if \F != 0
		MPush A
		MLoadR F, #\F
	.endif
	.if \G != 0
		MPush A
		MLoadR G, #\G
	.endif
	jsr PrintF
	.if \B != 0
		MPull G
	.endif
	.if \C != 0
		MPull F
	.endif
	.if \D != 0
		MPull E
	.endif
	.if \E != 0
		MPull D
	.endif
	.if \F != 0
		MPull C
	.endif
	.if \G != 0
		MPull B
	.endif
	MPull A
	jmp +
	txt .text \1,0
	+
	.endm
MSPrintF: .macro target, source, B=0, C=0, D=0, E=0, F=0, G=0
	;macro to print inline strings to memory
	MLoadR A, txt
	MLoadR J, \target
	.if \B != 0
		MLoadR B, #\B
	.endif
	.if \C != 0
		MLoadR C, #\C
	.endif
	.if \D != 0
		MLoadR D, #\D
	.endif
	.if \E != 0
		MLoadR E, #\E
	.endif
	.if \F != 0
		MLoadR F, #\F
	.endif
	.if \G != 0
		MLoadR G, #\G
	.endif
	jsr PrintF
	jmp +
	txt .text \source,0
	+
	.endm
MFPrintF: .macro handle=0, source, B=0, C=0, D=0, E=0, F=0, G=0
	;macro to print inline strings
	MPush A
	MLoadR A, #txt
	.if \B != 0
		MPush A
		MLoadR B, #\B
	.endif
	.if \C != 0
		MPush A
		MLoadR C, #\C
	.endif
	.if \D != 0
		MPush A
		MLoadR D, #\D
	.endif
	.if \E != 0
		MPush A
		MLoadR E, #\E
	.endif
	.if \F != 0
		MPush A
		MLoadR F, #\F
	.endif
	.if \G != 0
		MPush A
		MLoadR G, #\G
	.endif
	ldx \handle
	jsr FPrintF
	.if \B != 0
		MPull G
	.endif
	.if \C != 0
		MPull F
	.endif
	.if \D != 0
		MPull E
	.endif
	.if \E != 0
		MPull D
	.endif
	.if \F != 0
		MPull C
	.endif
	.if \G != 0
		MPull B
	.endif
	MPull A
	jmp +
	txt .text \source,0
	+
	.endm

FOpen: .proc
	;******************************************
	;Purpose..: Opens a Filestream
	;Input....: A = pointer to Filename
	;		  : C = command string (",P,W")
	;Output...: Accu = Filehandle
	;Clobbers.: Accu, x, y
	;Error....: c
	;******************************************

	jsr GetFreeFileNumber
	sta fileNumber
	;lda #1 					;logical file number
	ldx #8 						;device 8 (sdcard)
	tay							;secondary address
	jsr SETLFS
	bcc +						;Error?
		jsr FileError
	+

	;Add ,s,w to filename
	MLoadR B, #fileName
	;MLoadR C, #sw 
	jsr strcat
	MLoadR A, #fileName
	jsr strlen
	ldx #<fileName
	ldy #>fileName
	jsr SETNAM

	jsr OPEN
	;bcc +						;Error?
	;	jsr FileError
	;+
	lda fileNumber				;return logical file number
	rts

	fileNumber: .byte $0
	;sw:			.text ",P,A", $0
	fileName	.text "                   ", $0
	.pend
GetFreeFileNumber: .proc
	MPush A
	MLoadR A, #fileNumbers
	ldy #0
	Loop:
		lda (A), y
		beq +
			iny
			cpy #14
			;we ran out...
			beq +
			jmp Loop
		+
	lda #1	
	sta (A), y
	MPull A
	tya
	rts
	.pend

MFOpen: .macro filename, commandstring=",P,W"
	MLoadR A, #file
	MLoadR C, #command
	jsr FOpen
	jmp next
	file: .text \filename, $0
	command: .text \commandstring, $0
	next:
	.endm

FClose: .proc
	;******************************************
	;Purpose..: Closes a Filestream
	;Input....: Accu = FileHandle
	;Output...: None
	;Clobbers.: x, y
	;Error....: None
	;******************************************

	tay
	lda #0
	sta fileNumbers,y
	tya
	jsr CLOSE
	;bcc +
	;	jsr FileError
	;+
	;jsr CLRCHN
	rts 
	.pend

FPrintF: .proc
	;******************************************
	;Purpose..: Write formatted strings to File
	;Input....: x = FileHandle, A = pointer to string, B-J subsequent Pointers to Values
	;Output...: None
	;Clobbers.: x, y
	;Error....: None
	;******************************************
	jsr CHKOUT	;set the Logical File number to use
	bcc +
		jsr FileError
	+
	
	jsr PrintF

	ldx #0
	jsr CHKOUT	;back to the screen
	rts
	.pend

FWrite: .proc
	;******************************************
	;Purpose..: write unformatted data to a file
	;Input....: Accu = FileHandle
	;			A = pointer to source
	;			B = length of Data to read in bytes
	;Output...: None
	;Clobbers.: A,B, Accu, x, y
	;Error....: None
	;******************************************

	tax
	jsr CHKOUT	;set the Logical File number to use

	Loop:
		lda (A)
		jsr BASOUT
		inc Al
		bne +
		inc Ah
		+
		beq +
		dec Bl
		dec Bh
		beq Done
		+
		;sta (B)
		bra Loop
	Done:

	ldx #0
	jsr CHKOUT	;back to the screen
	rts
	.pend
FRead: .proc
	;******************************************
	;Purpose..: Write formatted strings to File
	;Input....: Accu = file handle
	;			A = pointer to target
	;			B = lenth of the data in bytes
	;Output...: None
	;Clobbers.: A, B, Accu
	;Error....: None
	;******************************************

	tax
	jsr CHKOUT	;set the Logical File number to use

	Loop:
		jsr BASIN
		sta (A)
		inc Al
		beq +
		inc Ah
		+
		dec Bl
		beq +
		dec Bh
		beq Done
		+
		sta (B)
		bra Loop
	Done:

	ldx #0
	jsr CHKOUT	;back to the screen
	rts
	.pend

FileError:
	jsr READST
	.byte $db
	rts


fileNumbers:
	.byte $1, $1
	.fill 12, $0
