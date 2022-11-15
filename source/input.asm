;input
;Variables:
	KEY_UP 		= 145
	KEY_DOWN 	= 17
	KEY_LEFT 	= 147
	KEY_RIGHT 	= 29
	KEY_SPACE 	= 32
	KEY_ESC 	= 3

Keydown:
	jsr GETIN
	rts

UpdateKey:
	jsr GETIN
	sta PressedKey
	rts

ResetKey
	stz PressedKey
	rts

IsPressed:
	;code to check in Accu
	;answer in zero flag
	sec
	sbc PressedKey
	rts

MIsPressed: .macro
	lda \1
	jsr IsPressed
	.endm

PressedKey: .byte $0