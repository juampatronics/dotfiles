# Default Makefile template for C/C++ projects
# Juan Pablo de la Cruz Gutierrez

INCLUDES = -I.
# LIBS = -L.

STATE=release
ifeq ($(STATE),release)
CFLAGS=-O3
endif

ifeq ($(STATE),debug)
CFLAGS=-g -O0
endif

ifeq ($(STATE),profile)
CFLAGS=-g -pg -O3
endif

ifeq ($(COMP),icc)
CC = icc
CFLAGS += -Wall -openmp -DBOUNDARY=32 -xHost -vec-report5 -std=c11
LDFLAGS = -lm
else
CC = gcc
CFLAGS += -Wall -fopenmp -std=c11 -DBOUNDARY=32 -march=native -std=c11 \
	 			 -ftree-vectorizer-verbose=1 -ftree-vectorize

LDFLAGS = -lm -lgomp
endif

# pass it as an argument to the makefile
# PROG := algebra
SRCS := $(PROG).c
OBJS := $(patsubst %.c,%.o,$(SRCS))
ASM  := $(patsubst %.c,%.s,$(SRCS))

.PHONY:	all clean $(PROG)

%.o:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.s:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -S -masm=intel $<

$(PROG): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $@ $^ $(LDFLAGS)
	-strip -s $(PROG)

asm: $(PROG).s

clean:
	-rm -f *.o $(PROG) *.s 1

