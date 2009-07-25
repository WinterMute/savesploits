export	PATH	:=	$(DEVKITARM)/bin:$(PATH)

COUNTRY	:=	USA

ifeq ($(strip $(COUNTRY)),USA)
ID:=E
endif

ifeq ($(strip $(COUNTRY)),UK)
ID:=V
endif

TARGET	:=	VCK$(ID).sav

$(CODE).sav:	$(TARGET)
	cp	$< $@

$(TARGET): cookhack.elf cooksum$(EXEEXT)
	arm-eabi-objcopy -O binary cookhack.elf $@
	./cooksum $@

cooksum$(EXEEXT):	cooksum.c

cookhack.elf:	cookhack.s overflow.bin
	arm-eabi-gcc -x assembler-with-cpp -D$(COUNTRY) -nostartfiles -nostdlib $< -o $@

clean:
	rm -f $(TARGET) *.sav cookhack.elf cooksum$(EXEEXT) cookhack.o
