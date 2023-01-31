#############################################################################
#
#	Makefile for cmdline
#	John Schwartzman, Forte Systems, Inc.
#	12/17/2022
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := cmdline
SHELL := /bin/bash

release: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -O3 -no-pie -z noexecstack $(PROG).obj -o $(PROG)
	gcc -O3 $(PROG).c

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -no-pie -z noexecstack -g $(PROG).obj -o $(PROG)
	gcc -g $(PROG).c

clean:
	rm -f $(PROG) $(PROG).obj a.out debug release

#############################################################################
