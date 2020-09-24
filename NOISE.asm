;*****************************************************************************
;* NOISE.ASM:	White noise generator (output = PD6 ATmega8), @RES avrfreaks.net
;*****************************************************************************

.include "m8def.inc"


	rjmp	RESET				;reset vector


	.def	temp 	= r16
	.def	byte0 	= r17			; 7  6  5  4  3  2  1  0
	.def	byte1 	= r18			;15 14 13 12 11 10  9  8
	.def	byte2	= r19			;23 22 21 20 19 18 17 16

	.equ	output	= 6			;output -> PD6




;* Main program

RESET:	ldi	temp, high(RAMEND)		;setup stack
	out	SPH, temp
	ldi	temp, low(RAMEND)		;point in RAMEND
	out	SPL, temp

;length 23bit
;14 cycles = 71,429 kHz @ 1MHz RC-clock
;repeat = 2^23/71429 = 8388608/71429 = 117,4sec

	ser	temp
	out	DDRD, temp			;PORTD all outputs
	ldi	byte0, 0x11
loop:	mov	temp, byte2
	andi	temp, 0b01000010		;17,22	1	1	1
	breq	cy2				;	2	1	1
	cpi	temp, 0b01000010		;		1	1
	breq	cy1				;		2	1
	sec					;			1
	rjmp	s1				;			2
cy2:	clc					;	1			
	clc					;	1
cy1:	clc					;	1	1
	clc					;	1	1
s1:	rol	byte0
	rol	byte1
	rol	byte2
	sbrc	byte0, 0			;if bit0 = 0,
	cbi	PORTD, output			; -> PD6 lo
	sbrs	byte0, 0			;if bit0 = 1,
	sbi	PORTD, output			; -> PD6 hi
	rjmp 	loop				; loop for ever
