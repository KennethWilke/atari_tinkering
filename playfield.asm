;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; playfield test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; includes and declarations

	processor 6502
	include "vcs.h"
ANIMATION_SPEED = 20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; RAM variables

	SEG.U variables
	ORG $80

playfield ds 3 ; playfield state
counter   ds 1 ; animation wait counter

	SEG program

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; program code

	ORG $F000

reset
; clear RAM and TIA
	LDX #0
	TXS
	PHA
	TXA
clear_loop
	PHA
	DEX
	BNE clear_loop


	; set background color to black
	LDA #0
	STA COLUBK


	; init PF0 and counter
	LDA #%00010000
	STA PF0
	STA playfield
	LDA ANIMATION_SPEED
	STA counter


frame_start
	; clear vblank
	LDA #0
	STA VBLANK

	; Wait for vsync
	LDA #2
	STA VSYNC

	; decrement time and check to see if it is time to animate
	DEC counter
	BNE full_wsync_wait ; jump if counter != 0

	; reset count
	LDA ANIMATION_SPEED
	STA counter

	; change playfield
	LDA playfield
	


full_wsync_wait
	STA WSYNC ; 1
	STA WSYNC ; 2
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

	; draw scanlines with the colorful background  (192 scanlines)
	LDX #192 ; counter
	LDY #0
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

	ORG $FFFC   ; Interrupt handlers
	.word reset ; RESET
	.word reset ; IRQ
