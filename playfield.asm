; playfield test

	processor 6502
	include "vcs.h"
	ORG $F000
reset
frame_start
	; clear vblank
	LDA #0
	STA VBLANK

	; set background color to black
	STA COLUBK

	; Wait for vsync
	LDA #2
	STA VSYNC

	STA WSYNC ; 1

	; Load pattern
	LDX $80
	INX
	STX PF1

	STA WSYNC ; 2

	; Store incremented pattern
	STX $80

	STA WSYNC ; 3

	; clear vsync flag
	LDA #0
	STA VSYNC

	; wait through vertical blank (37 scanlines)
	LDX #37
vblank_loop
	STA WSYNC
	DEX
	BNE vblank_loop

	; set playfield color
	LDA #$45
	STA COLUPF

	; draw a different color on each scanline  (192 scanlines)
	LDX #192 ; counter
	LDY #0   ; color
color_loop
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
overscan_loop
	STA WSYNC
	DEX
	BNE overscan_loop

	; end of main loop
	JMP frame_start

	ORG $FFFA   ; Interupt handlers
	.word reset ; NMI
	.word reset ; RESET
	.word reset ; IRQ
