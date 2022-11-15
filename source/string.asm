strcpy: .proc
	;******************************************
	;Purpose..: copy 0 terminated string to memory location
	;			255 chars max
	;Input....: A = pointer to source
	;			B = pointer to target
	;Output...: None
	;Clobbers.: Accu, y
	;Error....: None
	;******************************************
	
	ldy #0
	Loop:
		lda (A),y
		beq Done
		sta (B),y
		iny
		beq Done	;wrap around so bail
		bra Loop
	Done:
	lda #0
	sta (B), y
	rts
	.pend
strcat: .proc
	;******************************************
	;Purpose..: copy String1 to location than append String2
	;			(target location cannot be String2)
	;Input....: A = pointer to source string 1
	;			B = pointer to target
	;			C = pointer to source string 2
	;Output...: None
	;Clobbers.: Accu, x, y
	;Error....: None
	;******************************************

	jsr strcpy				;copy first string

	;add lenth of str1 to target
	sty str2offset
	clc
	lda Bl
	adc str2offset
	sta Bl
	lda Bh
	adc #0
	sta Bh

	MPush A
	lda Cl
	sta Al
	lda Ch
	sta Ah
	jsr strcpy
	MPull A

	rts
	str2offset .byte $0
	.pend
strlen: .proc
	;******************************************
	;Purpose..: returns length of zero terminated string
	;Input....: A = pointer to source
	;Output...: Accu = length of string
	;Clobbers.: Accu, x, y
	;Error....: c
	;******************************************
	ldy #0
	Loop:
		lda (A),y
		beq +
			iny
			jmp Loop
		+
	tya
	rts
	.pend
strcmp:
	;compares two strings
	;(returns 0 if equal and 1 if not)
strcrop:
	;cuts character off a string at the beginnig and/or the end
strchr:
	;finds first occurence of char
strrchar:
	;finds the last occurence of char