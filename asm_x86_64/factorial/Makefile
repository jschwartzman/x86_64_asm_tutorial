#############################################################################
#
#	Makefile for factorial
# 	01/21/2023
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#	- OR -
#			  make release DEF=__COMMA__
#			  make debug DEF=__COMMA__
#
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := factorial
SHELL := /bin/bash
EXT	  := ../commaSeparate/commaSeparate

ifeq ($(DEF), __COMMA__)	######### use commaSeparate for output ##########

release: $(PROG).asm Makefile $(EXT).asm $(PROG).c
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o commaSeparate.obj $(EXT).asm
	yasm -D $(DEF) -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -z noexecstack -no-pie $(PROG).obj commaSeparate.obj -o $(PROG)
	gcc -D $(DEF) -z noexecstack -no-pie -Wall $(PROG).c commaSeparate.obj

debug: $(PROG).asm Makefile $(EXT).asm $(PROG).c
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o commaSeparate.obj $(EXT).asm
	yasm -D $(DEF) -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -g -z noexecstack -no-pie $(PROG).obj commaSeparate.obj -o $(PROG)
	gcc -D $(DEF) -z noexecstack -no-pie -g $(PROG).c commaSeparate.obj

else						############### output normally #################

release: $(PROG).asm Makefile $(PROG).c
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -z noexecstack -no-pie $(PROG).obj -o $(PROG)
	gcc -Wall $(PROG).c

debug: $(PROG).asm Makefile $(PROG).c
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -z noexecstack -no-pie $(PROG).obj -o $(PROG)
	gcc -g $(PROG).c

endif	######################## use commaSeparate ##########################

clean:
	@rm -f $(PROG) *.obj *.lst debug release
#############################################################################
