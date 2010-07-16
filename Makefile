export	PATH	:=	$(DEVKITARM)/bin:$(PATH)

COUNTRY	:=	UK

ifeq ($(strip $(COUNTRY)),USA)
ID:=E
endif

ifeq ($(strip $(COUNTRY)),UK)
ID:=V
endif

ifeq ($(strip $(COUNTRY)),ES)
ID:=S
endif

#TARGET	:=	~/.config/desmume/dump_VCK$(ID).dsv
TARGET	:=	VCK$(ID).sav

$(CODE).sav:	$(TARGET)
	cp	$< $@

$(TARGET): cookhack.elf cooksum$(EXEEXT)
	arm-eabi-objcopy -O binary cookhack.elf $@
	./cooksum $@

cooksum$(EXEEXT):	cooksum.c

cookhack.elf:	cookhack.s overflow.bin Makefile
	arm-eabi-gcc -x assembler-with-cpp -D$(COUNTRY) -nostartfiles -nostdlib $< -o $@

clean:
	rm -f VCK*.sav cookhack.elf cooksum$(EXEEXT)