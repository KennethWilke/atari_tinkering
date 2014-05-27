ASM=dasm $< -f3 -o$@ -s$(@:.bin=.sym)

all: colortest.bin playfield.bin test.bin

colortest.bin: colortest.asm
	$(ASM)

playfield.bin: playfield.asm
	$(ASM)

test.bin: test.asm
	$(ASM)

clean:
	@rm -rvf *.bin *.sym
