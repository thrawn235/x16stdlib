MEndlessLoop .macro
	;round and round and round...
	_endless:
		jmp _endless
	.endm

IJSR .macro
	;indirect jump to subroutine
	pha
	lda \1
	sta _jump+1
	lda \1+1
	sta _jump+2
	pla
	_jump:
		jsr $0000
	.endm

MPush .macro
	;Pushes a ZeroPage Register
	lda \1l
	pha
	lda \1h
	pha
	.endm

MPull .macro
	;Pulls a ZeroPage Register
	pla
	sta \1h
	pla
	sta \1l
	.endm

MLoadR .macro
	;load a value into a Zero Page register
	lda <\2
	sta \1l
	lda >\2
	sta \1h
	.endm

MP .macro
	;load the Target Value of a Pointer stored in a zero page register into the same register
	lda (\1)
	tax
	ldy #1
	lda (\1), y
	sta \1h
	txa
	sta \1l
	.endm