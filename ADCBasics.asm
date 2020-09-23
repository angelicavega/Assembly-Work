;--------------CODE IS UNFORMATTED AND NEEDS MODIFICATION--------------------;
;CSC-240 Lab 10 B
; ADC Basics
; This program will show the basic functionality of the Analog-to-Digital Converter (ADC)
; using the "Wait for Conversion" method. The input should come from PB4, and the
; conversion will output on PORTA and PORTC.
.cseg
;
start of code segment
.def
io_set
= r16
; used to set up the
outputs on ports B and D
.def
workhorse
= r17
; multi-purpose
register used to move bytes to/from ADCSRA and ADMUX
.def
adc_value_low = r21
; used to manipulate the
low byte of the result of the ADC conversion
.def
adc_value_high = r22
; used to manipulate the
high byte of the result of the ADC conversion
.org
0x0000
; begin
storing program at location 0x0000
rjmp
setup
; jump over
all interrupt vectors
.org
0x0100
; begin
storing program at location 0x0100
; --------------------------------- setup ------------------------------------
setup:
;
ADD THE FOLLOWING FUNCTIONALITY HERE:
ldi workhorse, 0b11111111
;[1] set direction and control for all ports to
be used
sts PORTA_DIR, workhorse
ldi workhorse, 0b00000111
sts PORTB_DIR, workhorse
;- PORT A[1..7] are output
;- PORT B[0..2] are output, PORT B[4] in the analog input, B[3.5..7] are ignored and set low.
rcall display_all
; test routine to confirm wiring is correct
; ADD THE FOLLOWING FUNCTIONALITY HERE:
ldi workhorse, 0b00000001
sts ADC0_CTRLA , workhorse
;[1] use workhorse to store values to set up ADC
;[2] set ADC ENABLE
;[3] set ADC Sample Accumulation Number to 0 with 1
sample taken, which it already is
ldi workhorse, 0b00010001
sts ADC0_CTRLC,
workhorse
;[4] set ADC Prescalar to 4
;[5] set voltage reference selection to VDD
ldi workhorse,0b00001001
sts ADC0_MUXPOS, workhorse
;[6] set MUX to AIN9 reading PB4
; ---------------- loop sequence -----------------
loop:
; ADD THE FOLLOWING FUNCTIONALITY HERE:
ldi workhorse, 0b00000001
sts ADC0_COMMAND, workhorse
rcall wait_adc
;[1] use workhorse to store values into ADC0_COMMAND
by starting the conversion
;[2] check to see if the ADC conversion is done by:
wait_adc:
lds workhorse, ADC0_INTFLAGS
andi workhorse, 0b00000001
cpi
workhorse, 0b00000001
breq show
rjmp wait_adc
;- loading into workhorse the value of ADC0_INTFLAGS
;
- testing against the interrupt flag (ADC0_RESRDY)
;
- if the flag is not set, keep waiting
; ADD THE FOLLOWING FUNCTIONALITY HERE:
show:
lds adc_value_low, ADC0_RES
lds adc_value_high, ADC0_TEMP
;
[1] load the ADCed values into general purpose registers:
;
- ADC0_RES contains low byte: load it into adc_value_low
;
- ADC0_TEMP contains high byte: load it into adc_value_high
rcall
display_10
; using
display_10 to left shift the result for PORTA, and place high order bits on PORTB.
rjmp
loop
; --------------------------------- display_10 ------------------------------------
; Subroutine to display 10 bits on ATTiny416 pins. The pins are (from lsb to msb):
;
pa1, pa2, pa3, pa4, pa5, pa6, pa7, pb5, pb0, pb1, pb2
; Prerequisites:
;
Must set all of PORTA and PB0, PB1, PB2 as outputs
; Registers to be set before calling:
;
r21:
low 8 bits to be displayed
;
r22:
high 2 bits to be displayed
; Registers modified by this subroutine:
;
r23:
used to manipulate low order bits and display on PORTA
;
r24:
used to manipulate high order bits and display on PORTB
; ---------------------------------------------------------------------------------
display_10:
mov
r23, r21
;copy low byte into manipulation register
lsl
r23
;left shift once to place 7 low order bits correctly, lsb now 0.
sts
PORTA_OUT, r23 ;output value to PORTA
mov
r24, r22;copy the high byte into manipulation register
mov
r23, r21
;get a fresh copy of low byte
rol
r23
;rotate low byte with carry, placing msb in carry bit
rol
r24
;rotate high byte with carry, placing carry bit in lsb
;r24 now contains three high bits of ADC output in three low
order bits
sts
PORTB_OUT, r24 ;output value to PORTB
ret
; ---------------------------------- display_all ----------------------------------
; Subroutine to check the display wiring. Uses display_10 subroutine.
; Prerequisites:
;
None
; Registers to be preppred before calling:
;
None
; Registers modified by this subroutine:
;
r21, r22, r25
; ---------------------------------------------------------------------------------
display_all:
;
CLEAR DISPLAY AND FLASH
ldi
r25, 2
display_all_flash:
ldi
r21, 0xFF
ldi
r22, 0x03
rcall
display_10
rcall
delay_240ms
ldi
r21, 0x00
ldi
r22, 0x00
rcall
display_10
rcall
delay_240ms
dec
r25
brne
display_all_flash
ret
; ---------------------------------- delay_240ms ----------------------------------
; Subroutine to delay the uC by 240 milliseconds. Specifically, delay 799 992 cycles; 240ms at 3.3333 MHz.
; Prerequisites:
;
None
; Registers to be preppred before calling:
;
None
; Registers modified by this subroutine:
;
r18, r19, r20
; ---------------------------------------------------------------------------------
delay_240ms:
ldi
r18, 5
ldi
r19, 15
ldi
r20, 239
delay_next:
dec
r20
brne
delay_next
dec
r19
brne
delay_next
dec
r18
brne
delay_next
nop
ret
