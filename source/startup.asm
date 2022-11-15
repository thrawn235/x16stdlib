Startup:
	; Start of BASIC program
	*=$0801

	; BASIC "run" line
	.byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00

	; Start of actual program
	*=$0810
jmp Start