.phony all:
all: mts

mts: mts.c
	gcc -o mts mts.c -lpthread -std=gnu99

.PHONY clean:
clean:
	-rm -rf *.o *.exe
