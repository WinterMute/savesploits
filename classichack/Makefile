
export	PATH	:=	$(DEVKITARM)/bin:$(PATH)
export	CC		:=	gcc

UNAME	:=	$(shell uname -s)

ifneq (,$(findstring MINGW,$(UNAME)))
	EXEEXT		:=	.exe
endif

COUNTRY	:=	FR

ifeq ($(strip $(COUNTRY)),USA)
ID:=E
endif

ifeq ($(strip $(COUNTRY)),UK)
ID:=V
endif

ifeq ($(strip $(COUNTRY)),FR)
ID:=F
endif

TARGET	:=	VCW$(ID).sav


$(TARGET):	cwghack.elf cwgsum$(EXEEXT)
	arm-eabi-objcopy -O binary $< $@
	./cwgsum $@

cwgsum$(EXEEXT):	cwgsum.c

cwghack.elf:	cwghack.s
	arm-eabi-gcc -Ttext=0 -x assembler-with-cpp -nostartfiles -nostdlib -D$(COUNTRY) $< -o $@

clean:
	rm -f cwgsum$(EXEEXT) cwghack.elf cwghack.o cwghack.sav
