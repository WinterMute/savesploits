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

#if defined(USA)
#define CODE 0x400810
#endif

#if defined(UK)
#define CODE 0x800354
#endif

	.global	_start

_start:
	.word	0x800354
	.hword	1
	.hword	0x0203
	
	.ascii "__CWG_HACK__"
	.word	0x010A010A, 0xAAAAAAAA, 0xAAAAAAAA, 0x01010266
	.word	0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA
	.word	0x01010101, 0xAAAAAAAA, 0x02EB4E18, 0xAAAAAAAA
	.word	0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA
	.word	0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA
	
	
	
	.space	(_start + 0x0f38) - .

	.word	0x800354
	.hword	2
	.hword	0x0202
	
	.ascii "_WinterMute_"

	.space	(_start + 0x0f80) - .

	mov		r0, #0x04000000
	str		r0, [r0, #0x208]	@ IME = 0;

	mov		r1, #0
	strh	r1, [r0, #0x6c]

	mov		r2, #0x1000
	add		r3, r2, r0
	strh	r1, [r3, #0x6c]
	
	mov		r12, r0

	add		r2, r2, r0

	mov		r3, #0x58
	bl		memset

	ldr		r3, dispcnt
	str		r3, [r0]
	str		r3, [r2]

	mov		r5, #0x200
	str		r5, [r0, #0x08]
	str		r5, [r2, #0x08]
	
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


forever:
	b		forever
	
dispcnt:
	.word	0x10100

memset:

.clrloop:
	subs	r3, r3, #4
	str		r1, [r0,r3]
	str		r1, [r2,r3]
	bne		.clrloop
	bx		lr


.pool

	.space (_start + 8192) - .

