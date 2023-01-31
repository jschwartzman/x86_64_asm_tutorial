#############################################################################
#
#	Makefile for environment
# 	John Schwartzman, Forte Systems, Inc.
# 	12/18/2022
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := environment
SHELL := /bin/bash

release: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -O3 -z noexecstack $(PROG).c $(PROG).obj -o $(PROG)

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -z noexecstack $(PROG).c $(PROG).obj -o $(PROG)

clean:
	rm -f $(PROG) $(PROG).obj $(PROG).lst a.out debug release
#############################################################################
