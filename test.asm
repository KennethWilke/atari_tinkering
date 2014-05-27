	processor 6502
	include "vcs.h"

	SEG.U variables
	ORG $80

line ds 1 ; animation wait counter

	SEG program
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

frame_start
	; V-sync time
	LDA #2
	STA VSYNC
	LDA #0
	STA WSYNC
	STA WSYNC
	STA WSYNC
	STA VSYNC
	; V-Blank time
	LDX #37
vblank
	DEX
	STA WSYNC
	BNE vblank
	STA VBLANK

	; Picture time
	LDA #192
	STA line
line_start
	
	; End iteration
	STA WSYNC
	DEC line
	BNE line_start

	; Overscan time
	LDX #30
	LDA #2
	STA VBLANK
overscan
	DEX
	STA WSYNC
	BNE overscan

	JMP frame_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ORG $FFFC   ; Interrupt handlers
	.word reset ; RESET
	.word reset ; IRQ
