/*
	Copyright 2009 Dave Murphy (WinterMute)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

	.global _start

#if defined(USA)
#define CODE 0x56434B45
#endif

#if defined(UK)
#define CODE 0x56434B56
#endif



#define	REG_BASE	0x04000000

_start:

	.word	CODE
	.hword	1
	.hword	0x0203
	.incbin	"overflow.bin"
	.word	0x55555555

#if defined(USA)
	.word	0x02179AB4
#endif

#if defined(UK)
	.word	0x02179C94
#endif

	mov		r12, #REG_BASE
	str		r12, [r12, #0x208]	@ IME = 0;

	mov		r1, #0
	strh	r1, [r12, #0x6c]

	mov		r2, #0x1000
	add		r3, r2, r12
	strh	r1, [r3, #0x6c]
	
	add		r2, r2, r12
	mov		r0, r12
	mov		r3, #0x58
	bl		memset


	ldr		r3, dispcnt
	str		r3, [r12]
	str		r3, [r2]

	mov		r5, #0x200
	str		r5, [r12, #0x08]
	str		r5, [r2, #0x08]
	
	mov		r0, r12
	add		r0, r0, #0x240
	str		r1, [r0]
	strh	r1, [r0, #0x04]
	strb	r1, [r0, #0x06]
	strb	r1, [r0, #0x08]
	
	mov		r1, #0x81
	strb	r1, [r0]
	mov		r1, #0x84
	strb	r1, [r0,#0x02]

	mov		r4, #0x05000000		@ engine A palette

	mov		r1, #0x7f
	str		r1, [r4]
	str		r1, [r4,#0x400]		@ engine B palette

	add		r0, r4, #0x01000000
	add		r2, r0, #0x00200000

	mov		r1, #0
	mov		r3, #0x1800
	bl		memset

	add		r11, r12, #0x1a0
	
	ldrh	r0,[r11,#0x204-0x1a0]
	and		r0,r0,#~(1<<11)
	strh	r0,[r11,#0x204-0x1a0]

	ldr		r0, eepromselect
	strh	r0,[r11]

	mov		r0,#03
	strb	r0,[r11,#0x02]
	bl		eepromwait

	mov		r0,#0
	strb	r0,[r11,#0x02]
	bl		eepromwait

	mov		r0,#0
	strb	r0,[r11,#0x02]
	bl		eepromwait

	mov		r1,#0x02200000
	add		r2,r1,#0x2000

readeeprom:
	mov		r0,#0
	strb	r0,[r11,#0x02]
	
	bl		eepromwait
	ldrb	r0,[r11,#02]
	strb	r0,[r1],#1
	cmp		r1,r2
	bne		readeeprom

	mov		r0,#0x40
	strh	r0,[r11]
	
	adr		r0,stage2
	adr		r1,_start
	sub		r0,r0,r1
	add		r0,r0,#0x2200000
	bx		r0

eepromwait:
	ldrh	r0,[r11]
	tst		r0, #128
	bne		eepromwait
	bx	lr

memset:

.clrloop:
	subs	r3, r3, #4
	str		r1, [r0,r3]
	str		r1, [r2,r3]
	bne		.clrloop
	bx		lr

dispcnt:
	.word	0x10100

eepromselect:
	.word	0xA240

stage2:
	mov		r1, #0xf800
	str		r1, [r4]
	str		r1, [r4,#0x400]		@ engine B palette

forever:
	b	forever

	.pool
	.space (_start + 0x378) - .


	.word	CODE
	.hword	2
	.hword	0x0202


	.space (_start + 0xBD0) - .


	.word	CODE
	.hword	3
	.hword	0x0202
	.space (_start + 0xF04) - .



	.word	CODE
	.hword	4
	.hword	0x0202
	.space (_start + 0x1238) - .



	.word	CODE
	.hword	5
	.hword	0x0202



	.space (_start + 0x2000) - .
