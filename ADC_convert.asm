;Start of Code
;author: av3387a
.cseg
.org      0x0000
rjmp      setup
.org      0x003A
;vector for ADC
rjmp      adc_isr
;sub routine for ADC
.org      0x0100
setup:
ldi       r16,          0b11111111
;Start of modified code from Lab
sts       PORTD_DIR,    r16
;PORT D direction
ldi       r16,          0b11111111
sts PORTB_DIR, r16
;PORT B direction
ldi       r16,          0b00000001
sts ADC0_CTRLA, r16
ldi       r16,          0b00000000
sts ADC0_CTRLB, r16
ldi       r16,          0b00010001
sts ADC0_CTRLC, r16
ldi       r16,          0b00000101
sts ADC0_MUXPOS, r16
;input from AIN5
sei
;enable global interrupt
loop:
;loop
nop
rjmp      loop
adc_isr:
push      r16
;preserve workhorse and SREG
lds       r16,          CPU_SREG
push      r16
ldi       r16,          0b00000001
sts ADC0_COMMAND, r16
;enable ADC conversion
lds       r16,          ADC0_RES
;output values
lds       r17,          ADC0_TEMP
sts       PORTB_OUT,    r16
sts       PORTD_DOUT,   r17
pop       r16
;reset workhorse and SREG
sts       CPU_SREG,     r16
pop       r16
ret
