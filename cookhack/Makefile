#---------------------------------------------------------------------------------
# path to tools
#---------------------------------------------------------------------------------
export PATH	:=	$(DEVKITARM)/bin:$(PATH)

#---------------------------------------------------------------------------------
# the prefix on the compiler executables
#---------------------------------------------------------------------------------
PREFIX		:=	arm-none-eabi-

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

ifeq ($(strip $(COUNTRY)),FR)
ID:=F
endif

ifeq ($(strip $(COUNTRY)),ITA)
ID:=I
endif

ifeq ($(strip $(COUNTRY)),GER)
ID:=D
endif

#TARGET	:=	~/.config/desmume/VCK$(ID).dsv
TARGET	:=	VCK$(ID).sav

$(CODE).sav:	$(TARGET)
	cp	$< $@

$(TARGET): cookhack.elf cooksum$(EXEEXT)
	$(PREFIX)objcopy -O binary cookhack.elf $@
	./cooksum $@

cooksum$(EXEEXT):	cooksum.c

cookhack.elf:	cookhack.s overflow.bin Makefile
	$(PREFIX)gcc -x assembler-with-cpp -D$(COUNTRY) -nostartfiles -nostdlib $< -o $@

clean:
	rm -f VCK*.sav cookhack.elf cooksum$(EXEEXT)

