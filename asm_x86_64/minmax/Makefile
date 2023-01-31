#############################################################################
#
#	Makefile for minmax
# 	John Schwartzman, Forte Systems, Inc.
# 	01/19/2023
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#	Builds both versions of minmax.c:  a.out  - c only
#									   minmax - c and assembly
#############################################################################
PROG  := minmax
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -z noexecstack -no-pie $(PROG).c $(PROG).obj -o $(PROG)
	gcc -D C_VERSION $(PROG).c 

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -z noexecstack -no-pie $(PROG).c $(PROG).obj -o $(PROG)

clean:
	rm -f $(PROG) $(PROG).obj $(PROG).lst a.out debug release
#############################################################################
