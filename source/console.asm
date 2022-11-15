ClearScreen:
	.MLoadR r0, 0
	.MLoadR r1, 0
	.MLoadR r2, 0
	.MLoadR r3, 0
	jsr $FEDB
	rts