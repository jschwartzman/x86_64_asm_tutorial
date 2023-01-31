#############################################################################
#
#	Makefile for commaSeparate
# 	John Schwartzman, Forte Systems, Inc.
# 	01/25/2023
#
#	Commands:  make release, make debug, make clean
#			   make = make release
#	- OR -
#			  make release DEF=__MAIN__
#			  make debug DEF=__MAIN__
#
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := commaSeparate
SHELL := /bin/bash

##### BUILD WITHOUT DEFINING __MAIN__ IN ORDER TO LINK WITH factorial. ######
################## BUILD THIS BEFORE BUILDING factorial. ####################

ifeq ($(DEF), __MAIN__)	############### STAND ALONE PROGRAM #################

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -D $(DEF) -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -z noexecstack -no-pie $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -D $(DEF) -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -z noexecstack -no-pie $(PROG).obj -o $(PROG)

else	#####################################################################

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -Wall -z noexecstack -no-pie $(PROG).c $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -Wall -g -z noexecstack -no-pie $(PROG).c $(PROG).obj -o $(PROG)


endif	#####################################################################

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst debug release
#############################################################################
