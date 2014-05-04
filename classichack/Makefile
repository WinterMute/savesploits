export	PATH	:=	$(DEVKITARM)/bin:$(PATH)
export	CC		:=	gcc

#---------------------------------------------------------------------------------
# the prefix on the compiler executables
#---------------------------------------------------------------------------------
PREFIX		:=	arm-none-eabi-

UNAME	:=	$(shell uname -s)

#ifneq (,$(findstring MINGW,$(UNAME)))
#	EXEEXT		:=	.exe
#endif

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
	$(PREFIX)objcopy -O binary $< $@
	./cwgsum $@

cwgsum$(EXEEXT):	cwgsum.c

cwghack.elf:	cwghack.s
	$(PREFIX)gcc -Ttext=0 -x assembler-with-cpp -nostartfiles -nostdlib -D$(COUNTRY) $< -o $@

clean:
	rm -f cwgsum$(EXEEXT) cwghack.elf cwghack.o cwghack.sav
