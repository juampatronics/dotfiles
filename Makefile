# Default Makefile template for C/C++ projects
# Juan Pablo de la Cruz Gutierrez

INCLUDES = -I.
LIBS = -L.

ifeq ($(COMP),icc)
CC = icc
CFLAGS = -Wall -O3 -openmp -DBOUNDARY=32 -xHost -vec-report5 -std=c11 # -g 
LDFLAGS = -lm
else
CC = gcc
CFLAGS = -Wall -O3 -fopenmp -std=c11 -DBOUNDARY=32 -march=native -std=c11 \
	 			 -ftree-vectorizer-verbose=1 -ftree-vectorize -g

LDFLAGS = -lm -lgomp
endif

PROG := algebra
SRCS := $(PROG).c
OBJS := $(patsubst %.c,%.o,$(SRCS))
ASM  := $(patsubst %.c,%.s,$(SRCS))

.PHONY:	all clean $(PROG)

%.o:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.s:%.c
	$(CC) $(CFLAGS) $(INCLUDES) -S $<

$(PROG): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $@ $^ $(LDFLAGS)

clean:
	-rm -f *.o $(PROG) *.s 1

