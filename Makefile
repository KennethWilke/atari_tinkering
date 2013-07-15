all: colortest playfield

colortest: colortest.asm
	dasm colortest.asm -f3 -ocolortest.bin

playfield: playfield.asm
	dasm playfield.asm -f3 -oplayfield.bin

clean:
	rm -rf colortest.bin playfield.bin
