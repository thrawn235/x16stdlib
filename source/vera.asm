;Variables
	ADDRx_L		= $9F20
	ADDRx_M		= $9F21
	ADDRx_H		= $9F22
	DATA0		= $9F23
	DATA1		= $9F24
	CTRL		= $9F25
	IEN		= $9F26
	ISR		= $9F27
	IRQLINE_L	= $9F28
	DC_VIDEO	= $9F29
	DC_HSCALE	= $9F2A
	DC_VSCALE	= $9F2B
	DC_BORDER	= $9F2C
	DC_HSTART	= $9F29
	DC_HSTOP	= $9F2A
	DC_VSTART	= $9F2B
	DC_VSTOP	= $9F2C
	L0_CONFIG	= $9F2D
	L0_MAPBASE	= $9F2E
	L0_TILEBASE	= $9F2F
	L0_HSCROLL_L	= $9F30
	L0_HSCROLL_H	= $9F31
	L0_VSCROLL_L	= $9F32
	L0_VSCROLL_H	= $9F33
	L1_CONFIG	= $9F34
	L1_MAPBASE	= $9F35
	L1_TILEBASE	= $9F36
	L1_HSCROLL_L	= $9F37
	L1_HSCROLL_H	= $9F38
	L1_VSCROLL_L	= $9F39
	L1_VSCROLL_H	= $9F3A
	AUDIO_CTRL	= $9F3B
	AUDIO_RATE	= $9F3C
	AUDIO_DATA	= $9F3D
	SPI_DATA	= $9F3E
	SPI_CTRL	= $9F3F

MSetVeraLMH: .macro address, increment=1, decrement=0
	lda <#\1
	sta ADDRx_L
	lda >#\1
	sta ADDRx_M
	lda #(`\address)|(\increment<<4)|(\decrement<<3)
	sta ADDRx_H
	.endm
MResetVera: .macro
	lda #%10000000
	sta CTRL
	.endm	
MSelectVeraData: .macro dataRegister
	lda CTRL 
	and #%11111110
	ora #\dataRegister&1
	sta CTRL
	.endm
MSetDCSel: .macro DCSel
	lda CTRL
	and #%11111101
	ora #(\DCSel&1)<<1
	sta CTRL
	.endm

MEnableLayer0: .macro
	MSetDCSel 0
	lda DC_VIDEO
	ora #%00010000
	sta DC_VIDEO
	.endm
MEnableLayer1: .macro 
	MSetDCSel 0
	lda DC_VIDEO
	ora #%00100000
	sta DC_VIDEO
	.endm
MEnableSprites: .macro
	MSetDCSel 0
	lda DC_VIDEO
	ora #%01000000
	sta DC_VIDEO
	.endm
MEnableChroma: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11111011
	sta DC_VIDEO
	.endm
MDisableLayer0: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11101111
	sta DC_VIDEO
	.endm
MDisableLayer1: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11011111
	sta DC_VIDEO
	.endm
MDisableSprites: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%10111111
	sta DC_VIDEO
	.endm
MDisableChroma: .macro
	MSetDCSel 0
	lda DC_VIDEO
	ora #%00000100
	sta DC_VIDEO
	.endm

MDisableVideo: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11111100
	ora #%00000000
	sta DC_VIDEO
	.endm
MVGAVideo: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11111100
	ora #%00000001
	sta DC_VIDEO
	.endm
MCompositeVideo: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11111100
	ora #%00000010
	sta DC_VIDEO
	.endm
MInterlacedVideo: .macro
	MSetDCSel 0
	lda DC_VIDEO
	and #%11111100
	ora #%00000011
	sta DC_VIDEO
	.endm

MSetHScale: .macro
	MSetDCSel 0
	lda \1
	sta DC_HSCALE
	.endm
MSetVScale: .macro
	MSetDCSel 0
	lda \1
	sta DC_VSCALE
	.endm

MSetBorderColor: .macro
	MSetDCSel 0
	lda \1
	sta DC_BORDER
	.endm

MSetScreenArea: .macro startx, starty, endx, endy
	MSetDCSel 1
	lda \startx>>2
	sta DC_HSTART
	lda \starty>>1
	sta DC_VSTART
	lda \endx>>2
	sta DC_HSTOP
	lda \endy>>1
	sta DC_VSTOP
	.endm

MSetLayer0Text16ColorMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000000
	sta L0_CONFIG
	.endm
MSetLayer0Text256ColorMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00001000
	sta L0_CONFIG
	.endm
MSetLayer0Tile2BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000001
	sta L0_CONFIG
	.endm
MSetLayer0Tile4BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000010
	sta L0_CONFIG
	.endm
MSetLayer0Tile8BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000011
	sta L0_CONFIG
	.endm
MSetLayer0Bitmap1BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000100
	sta L0_CONFIG
	.endm
MSetLayer0Bitmap2BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000101
	sta L0_CONFIG
	.endm
MSetLayer0Bitmap4BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000110
	sta L0_CONFIG
	.endm
MSetLayer0Bitmap8BitMode: .macro
	lda L0_CONFIG
	and #%11110000
	ora #%00000111
	sta L0_CONFIG
	.endm
MSetLayer1Text16ColorMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000000
	sta L1_CONFIG
	.endm
MSetLayer1Text256ColorMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00001000
	sta L1_CONFIG
	.endm
MSetLayer1Tile2BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000001
	sta L1_CONFIG
	.endm
MSetLayer1Tile4BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000010
	sta L1_CONFIG
	.endm
MSetLayer1Tile8BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000011
	sta L1_CONFIG
	.endm
MSetLayer1Bitmap1BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000100
	sta L1_CONFIG
	.endm
MSetLayer1Bitmap2BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000101
	sta L1_CONFIG
	.endm
MSetLayer1Bitmap4BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000101
	sta L1_CONFIG
	.endm
MSetLayer1Bitmap8BitMode: .macro
	lda L1_CONFIG
	and #%11110000
	ora #%00000111
	sta L1_CONFIG
	.endm
MSetLayer0Mapbase: .macro address
	;set Layer0 Mapbase alligned to 256 (only the top 8bit are specified)
	lda >#\address>>8
	sta L0_MAPBASE
	.endm
MSetLayer1Mapbase: .macro address
	;set Layer0 Mapbase alligned to 256 (only the top 8bit are specified)
	lda >#\address>>8
	sta L1_MAPBASE
	.endm
MSetLayer0Tilebase: .macro address
	;set Layer0 Mapbase alligned to 1024 (only the top 6bit are specified)
	lda L0_TILEBASE
	and #%000011
	adc #>\address
	sta L0_TILEBASE
	.endm
MSetLayer1Tilebase: .macro address
	;set Layer1 Mapbase alligned to 1024 (only the top 6bit are specified)
	lda L1_TILEBASE
	and #%000011
	lda (>#\address & %111100)>>8  
	sta L1_TILEBASE
	.endm

MSetLayer0MapSize: .macro height, width
	lda L0_CONFIG
	and #%00001111
	ora #((\height&%00000011)<<6)+(\width&%00000011)<<4)
	sta L0_CONFIG
	.endm
MSetLayer1MapSize: .macro height, width
	lda L1_CONFIG
	and #%00001111
	ora #((\height&%00000011)<<6)+(\width&%00000011)<<4)
	sta L1_CONFIG
	.endm

FReadToVera: .proc
	;******************************************
	;Purpose..: Read Data from file directly to Vera Memory
	;Input....: Accu = file handle
	;			VeraHML = Vera address (call MVeraLMH)
	;			B = lenth of the data in bytes
	;Output...: None
	;Clobbers.: A, B, Accu
	;Error....: None
	;******************************************
	;.byte $db
	tax
	.MSelectVeraData 0 		;select Vera Data0 register
	jsr CHKIN				;set the Logical File number to use

	Loop:
		inc Bl
		dec Bl
		bne +
			inc Bh
			dec Bh
			beq Done
			dec Bh
		+
		dec Bl

		jsr BASIN
		sta DATA0
		bra Loop
	Done:
	jsr CLRCHN
	rts
	.pend

FillVeraMemory: .proc
	;******************************************
	;Purpose..: Fill Vera memory area with a repeated byte value
	;Input....: Accu = byte to write
	;			VeraHML = Vera address (call MVeraLMH)
	;			B = lenth of the data in bytes
	;Output...: None
	;Clobbers.: A, B, Accu
	;Error....: None
	;******************************************

	sta temp 				;save for later
	.MSelectVeraData 0 		;select Vera Data0 register

	lda temp
	Loop:
		inc Bl
		dec Bl
		bne +
			inc Bh
			dec Bh
			beq Done
			dec Bh
		+
		dec Bl
		sta DATA0
		bra Loop
		Done:
	rts
	temp .byte $0
	.pend