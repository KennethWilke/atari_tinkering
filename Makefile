all: colortest

colortest: colortest.asm
	dasm colortest.asm -f3 -ocolortest.bin

clean:
	rm -rf colortest.bin
