; Modified version of the example source from
;  http://atariage.com/forums/topic/27194-session-8-our-first-kernel/
; Adjusted to use my compiler, RetroDev

.target "atari_2600"
.include "vcs.h"
.atari_nmi reset
.atari_reset reset
.atari_irq reset

	.org $F000
reset:
frame_start:
	; clear vblank
	LDA #0
	STA VBLANK

	; set background color to black
	STA COLUBK

	; Wait for vsync
	LDA #2
	STA VSYNC

	; wait for 3 scanlines
	STA WSYNC
	STA WSYNC
	STA WSYNC

	; clear vsync flag
	LDA #0
	STA VSYNC

	; wait through vertical blank (37 scanlines)
	LDX #37
vblank_loop:
	STA WSYNC
	DEX
	BNE vblank_loop

	; draw a different color on each scanline  (192 scanlines)
	LDX #192 ; counter
	LDY #0   ; color
color_loop:
	STY COLUBK
	INY
	INY
	STA WSYNC
	DEX
	BNE color_loop

	; set vblank
	LDA #%01000010
	STA VBLANK

	; wait through overscan (30 lines)
	LDX #30
overscan_loop:
	STA WSYNC
	DEX
	BNE overscan_loop

	; end of main loop
	JMP frame_start
