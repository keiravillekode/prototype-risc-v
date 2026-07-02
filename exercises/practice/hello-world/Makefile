CC = zig cc -target riscv32-linux-musl

CFLAGS = -g -Wall -Wextra -pedantic -Werror
LDFLAGS =

ALL_LDFLAGS = -static

ALL_CFLAGS = -std=c99 $(CFLAGS)
ALL_LDFLAGS += $(LDFLAGS)

C_OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
AS_OBJS = $(patsubst %.S,%.o,$(wildcard *.S))
ALL_OBJS = $(filter-out example.o,$(C_OBJS) $(AS_OBJS) vendor/unity.o)

CC_CMD = $(CC) $(ALL_CFLAGS) -c -o $@ $<

all: tests
	qemu-riscv32 ./$<

tests: $(ALL_OBJS)
	@$(CC) $(ALL_LDFLAGS) -o $@ $(ALL_OBJS)

# The .S extension makes the compiler driver run the C preprocessor first, so
# clang's integrated assembler accepts the GAS-style /* */ comments used
# throughout the track.
%.o: %.S
	@$(CC) -c -o $@ $<

%.o: %.c
	@$(CC_CMD)

vendor/unity.o: vendor/unity.c vendor/unity.h vendor/unity_internals.h
	@$(CC_CMD)

clean:
	@rm -f *.o vendor/*.o tests

.PHONY: all clean
