export	PATH	:=	$(DEVKITARM)/bin:$(PATH)
export	CC	:=	gcc


TARGET	:=	AFSE.SAV

$(TARGET): fifastreet2hack.elf fifastreet2sum$(EXEEXT)
	arm-none-eabi-objcopy -O binary fifastreet2hack.elf $@
	./fifastreet2sum $@

fifastreet2sum$(EXEEXT):	fifastreet2sum.c
	$(CC) $< -o $@

fifastreet2hack.elf:	fifastreet2hack.s
	arm-none-eabi-gcc -Wl,-Ttext=0 -x assembler-with-cpp -nostartfiles -nostdlib $< -o $@

clean:
	rm -f AFSE.sav fifastreet2hack.elf fifastreet2sum$(EXEEXT)
